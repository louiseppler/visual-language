class FunctionCall extends Field { //TODO cmd click; jump to funciton -- connect function
  String str = "";
  int oldL1;
  int oldL2;
   
  FunctionDef func;
  FieldComparator funcComp;
  
  FunctionCall(int id, int x, int y, int index, String str, Field[][] fields) {
    super(id,x,y);
    this.isCompileElement = true;
    fields[x][y] = new FieldOperator(id,x,y,"");
    fields[x][y].str = str(index);
    if(str != "") {
      this.str = str;  
    }
  }
  
  @Override
  void setup(Field[][] fields) {
    if(str.length() < 6) {return;}
    int fx = Integer.parseInt(str.subSequence(0,3).toString());
    int fy = Integer.parseInt(str.subSequence(3,6).toString());
    
    if(fields[fx][fy].id != 81) { println("ERROR: function referenced is not of id 81"); return;}
    
    changeFunction((FunctionDef) fields[fx][fy], fields);
   }
  
  String saveStr() {
    if(func == null) {return "";}
    return makeString(func.x) + makeString(func.y);
  }
  
  void changeFunction(FunctionDef f, Field[][] fields){
    func = f;
     
    changedSize(fields);
  }
  
  void changedSize(Field[][] fields) {
    //Delete old
    for(int i = l(); i < oldL1; i++) {
      fields[x+1+i][y] = new Field(0,x+1+i,y);
      fields[x+1+i][y-1] = new Field(0,x+1+i,y-1);
    }
    for(int i = l(); i < oldL2; i++) {
      fields[x+1+i][y] = new Field(0,x+1+i,y);
      fields[x+1+i][y+1] = new Field(0,x+1+i,y-1);
    }
    
    //Adding new
    for(int i = 0; i < l(); i++) {
      fields[x+1+i][y] = new Field(88,x+1+i,y);
    }
    for(int i = 0; i < l1(); i++) {
         addLine(x+1+i,y-1,fields,false);
    }
    for(int i = 0; i < l2(); i++) {
        addLine(x+1+i,y+1,fields,true);
    }
    
    oldL1 = l1();
    oldL2 = l2();
  }
  
  void drawIcon(int x, int y, int s){
    strokeWeight(1.1);
    fill(255); stroke(0,0,255);
    rect(x,y+s*0.25,(l()+2)*s,s*0.5);
    textAlign(CENTER); textSize(s*0.33*(int(largeWriting)*0.75+1));
    fill(0,0,255);
    String str;
    if(func == null) {str = "call ___";}
    else {str = "call " + func.name;}
    text(str, x+s*((l()+2.0)/2), y+s*0.666);
    
    lineFormatting(false);
    for(int i = 1; i < l1()+1; i++) {
       line(i*s+x+s*0.5,y+s*0.25,i*s+x+s*0.5,y-s*0.5);
    }
    for(int i = 1; i < l2()+1; i++) {
      line(i*s+x+s*0.5,y+s*0.75+1,i*s+x+s*0.5,y+s*1.5);
 
    }
  }
  
  int l() {
    int l1 = l1();
    int l2 = l2();
    if(l1 < l2) { return l2;}
    return l1;
  }
  
  int l1() {
    if(func == null) {return 0;}
    return func.l;
  }
  
  int l2() {
    if(func == null) {return 0;}
    if(func.funcRet == null) {return 0;}
    return func.funcRet.l;
  }
  
  @Override
  void delete(Field[][] fields) {
    for(int i = 0; i < l(); i++) {
      fields[x+1+i][y] = new Field(0,x+1+i,y);
      fields[x+1+i][y+1] = new Field(0,x+1+i,y+1);
    }
    fields[x+1+l()][y] = new Field(0,x+1+l(),y);
  }
  
  @Override
  void compileSetComponets(Element element, Field[][] fields) {
    for(int i = 0; i < l1(); i++) {
      FieldLine f = (FieldLine)fields[x+1+i][y-1];
      element.connectors.add( f.getCompilerLocation(fields) );
    }
    for(int i = 0; i < l2(); i++) {
      FieldLine f = (FieldLine)fields[x+1+i][y+1];
      if(f == null) {return;}
      element.defines.add( f.getCompilerLocation(fields) );
    }
    
    if(funcComp != null) {
      funcComp.compileSetComponetsLoc(element, fields);
    }
  }
  
  @Override
  void writeCode(Code code, Element e) {
    if(func == null) {println("WARN: functionCall doesn't call a funciton"); return; }
     code.addComment("call function: " + func.name);
     
    if(funcComp == null) {//no comparison
      if(func.funcRet == null) {
        writeCodeJmp(code, e); //no return
      }
      else {
        writeCodeCall(code, e); //with return
      }
    }
    else { //with comparison
      funcComp.writeCodeLoc(code,e);
      code.addText(funcComp.getConditionCmd() + "condition" + str(code.conditionCount));
      code.addText("jmp  condition" + str(code.conditionCount+1));//jump to "continue"
      
      code.addText("condition"+str(code.conditionCount)+":");
      if(func.funcRet == null) {
        writeCodeJmp(code, e); //no return
      }
      else {
        writeCodeCall(code, e); //with return
      }
      
      code.addText("condition"+str(code.conditionCount+1)+":"); //"continue"
      code.conditionCount += 2;
    }
    
    
    code.addLine();
  }

  void writeCodeJmp(Code code, Element e) { //no return
    //arrange regsiters for function
    arrangeConnectors(e.connectors,func.compileConnectors,code);
    //jump to the segment
    code.addText("jmp"+" segment"+str(func.compileSegment));
  }
  
  void writeCodeCall(Code code, Element e) {
    
     //preserve values on stack
     for(int i = 0; i < e.inuse.size(); i++) {
       code.addText("push "+code.registers[e.inuse.get(i)]);
     }
     
     //arrange regsiters for function
     arrangeConnectors(e.connectors,func.compileConnectors,code);
     //call function
     code.addText("call segment"+str(func.compileSegment));
     //convert form return form(standart form) to define form
     arrangeConnectors(code.standartForm, e.defines, code); 
     
     //restore values from stack
     for(int i = e.inuse.size()-1; i >= 0; i--) {
       code.addText("pop  "+code.registers[e.inuse.get(i)]);
     }
     
  }
  
}
