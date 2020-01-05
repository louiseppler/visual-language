class FunctionRet /*return*/ extends Field{  
  int l = 1;
  int id;
  
  FieldComparator funcComp;
      
  List<Integer> compileConnectors;    
  
  FunctionRet(int id, int x, int y, String str) {
    super(id,x,y);
    this.isCompileElement = true;
    if(str.length() >= 3) {
      l = Integer.parseInt(str.subSequence(0,3).toString());
    }
  }
 
  @Override
  String saveStr() {
    return makeString(l);
  }
   
  @Override
  void drawIcon(int x, int y, int s) {
    strokeWeight(1.1);
    fill(255); stroke(0,128,0);
    rect(x,y+s*0.25,(l+2)*s,s*0.5);
    textAlign(CENTER); textSize(s*0.33*(int(largeWriting)*0.5+1));
    fill(0,128,0);
    ellipse(x+s*0.5,y+s*0.5,s/32,s/32); //connectordot
    text("return", x+s*((l+2.0)/2), y+s*0.5); 
    
    lineFormatting(false);
    for(int i = 1; i < l+1; i++) {
       line(i*s+x+s*0.5,y+s*0.25,i*s+x+s*0.5,y-s*0.5);
    }
  }
  
  @Override
  void setup(Field[][] fields) {
    changeSize(l, fields);
  }
  
  void changeSize(int newl, Field[][] fields) {
    if(newl < 1) {return;}
    //deleting old fields
    fields[x+1+l][y] = new Field(0,x+1+l,y);
    for(int i = newl; i < l; i++) {
      fields[x+1+i][y] = new Field(0,x+1+i,y);
      fields[x+1+i][y-1] = new Field(0,x+1+i,y-1);
    }
    
    //adding new fields
    l = newl;
    for(int i = 0; i < newl; i++) {
      fields[x+1+i][y] = new Field(85,x+1+i,y);
      addLine(x+1+i,y-1,fields,false);
    }
    
    fields[x+1+l][y] = new FunctionRef(86,x+1+l,y,x,y);
  }
  
  void delete(Field[][] fields) {
    fields[x+1+l][y] = new Field(0,x+1+l,y);
    for(int i = 0; i < l; i++) {
      fields[x+1+i][y] = new Field(0,x+1+i,y);
      fields[x+1+i][y+1] = new Field(0,x+1+i,y+1);
    }
    fields[x+1+l][y] = new Field(0,x+1+l,y);
  }
  
  @Override
  void compileSetComponets(Element element, Field[][] fields) {
    for(int i = 0; i < l; i++) {
      FieldLine f = (FieldLine)fields[x+1+i][y-1];
      element.connectors.add( f.getCompilerLocation(fields) );
    }
    if(funcComp != null) {
      funcComp.compileSetComponetsLoc(element, fields);
    }
  }
  
  @Override
  void prepareWrite(Element e) {
    compileConnectors = e.connectors;
  }
  
  @Override
  void writeCode(Code code, Element e) {
    if(funcComp == null) {
      arrangeConnectors(e.connectors, code.standartForm, code); //move all registers to standart form
      code.addText("ret");
    }
    else {
      funcComp.writeCodeLoc(code,e);
      code.addText(funcComp.getReverseConditionCmd() + "condition" + str(code.conditionCount));
      arrangeConnectors(e.connectors, code.standartForm, code); //move all registers to standart form
      code.addText("ret");
      code.addText("condition"+str(code.conditionCount)+":");
      code.conditionCount += 1;
    }
  }
  
  
}
