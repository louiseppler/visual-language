class FieldOperator extends Field { //TODO subcalsses for each operation
  int x; int y;

  FieldOperator(int id, int x, int y, String str) {
    super(id,x,y);  
    isCompileElement = true;
    this.x = x; //? don't get why this is needed, but won't work otherwise
    this.y = y;
    this.str = str;
    //println("str"+str);
  }
  
  void setup(Field[][] fields) {
   if(id == 3) {
      addLine(x,y+1,fields,true);
    }
    if(id == 4) {
      addLine(x,y+1,fields,true);
      addLine(x,y-1,fields,false);
    }
    if(id == 11 || id == 12) {
      addLine(x,y+1,fields,true);
      addLine(x,y-1,fields,false);
    }
    if(id == 13 || id == 14 || id == 15 || id == 16 || id == 17) {
      addLine(x,y+1,fields,true);
      addLine(x-1,y-1,fields,false);
      addLine(x+1,y-1,fields,false);
    } 
    if(id == 17) {
      addLine(x+1,y+1,fields,true);
    }
  }
  
  @Override
  String saveStr() {
    return str;
  }

  void drawField(int x, int y, int s, boolean selected){
    fill(255);
    if(selected) { fill(224); }
    stroke(255);
    strokeWeight(1);
    rect(x,y,s,s);
  }
 
  void drawIcon(int x, int y, int s) {
    draw_id(x,y,s,id,false);
  }
  
  @Override
  void pressed() {
    if(id == 3) {
      container.textEditor.startEditing(this,"text to print before read");
    }
    if(id == 4) {
      container.textEditor.startEditing(this,"text to print before printing number");
    }
  }
  
  @Override
  void changeText(String text) {
    str = text;
  }
  
  void delete(Field[][] fields) {
    if(id == 3) {
      fields[x][y+1] = new Field(0,x,y+1);
    }
    if(id == 11 || id == 12 || id == 4) {
      fields[x][y+1] = new Field(0,x,y+1);
      fields[x][y-1] = new Field(0,x,y-1);
    }
    if(id == 13 || id == 14 || id == 15 || id == 16 || id == 17) {
      fields[x][y+1] = new Field(0,x,y+1);
      fields[x-1][y-1] = new Field(0,x-1,y-1);
      fields[x+1][y-1] = new Field(0,x+1,y-1);
    } 
    if(id == 17) {
      fields[x+1][y+1] = new Field(0,x,y+1);
    }
  }
  
  @Override
  void compileSetComponets(Element element, Field[][] fields) {
    if(id == 11 || id == 12 || id == 4) {
      FieldLine f = (FieldLine)fields[x][y-1];
      element.connectors.add(f.getCompilerLocation(fields));
    }
    if(id == 13 || id == 14 || id == 15 || id == 16 || id == 17) {
      FieldLine f1 = (FieldLine)fields[x+1][y-1];
      element.connectors.add(f1.getCompilerLocation(fields));
      FieldLine f2 = (FieldLine)fields[x-1][y-1];
      element.connectors.add(f2.getCompilerLocation(fields));
    } 
    FieldLine f = (FieldLine)fields[x][y+1];
    element.defines.add( f.getCompilerLocation(fields) );
    if(id == 17) {
      FieldLine f2 = (FieldLine)fields[x+1][y+1];
      element.defines.add( f2.getCompilerLocation(fields) );
    }
    
  }
  
  @Override
  void writeCode(Code code, Element e) {
    switch(id) {
      case 3:
        read(code,e);
        break;
      case 4:
        printt(code,e);
        break;
      case 11:
        twoOperator("inc", code, e);
        break;
      case 12:
        twoOperator("dec", code, e);
        break;
      case 13:
        addd(code, e);
        break;
      case 14:
        subb(code, e);
        break;
      case 15:
        mul(code, e);
        break;
      case 16:
        divv(code, e);
        break;
      case 17:
        divv(code,e);
        break;
    }
   
    
    code.addLine();
  }
  
  void twoOperator(String cmd, Code code, Element e) {
    int n = e.connectors.get(0);
    int d = e.defines.get(0);
    code.addText(cmd + "  " + code.registers[n]);
    
    if(n != d) {
      code.addText("mov" + "  " + code.registers[d] + ", " + code.registers[n]);
    }
  }
  
  void addd(Code code, Element e) {
    code.addComment("add");
    int n1 = e.connectors.get(0);
    int n2 = e.connectors.get(1);
    int d = e.defines.get(0);
    if(d == -1) {print("WARN: unused add"); return;}
        
    if(d == n1) {
      code.addText("add" + "  " + code.registers[n1] + ", " + code.registers[n2]);
    }
    else if(d == n2) {
      code.addText("add" + "  " + code.registers[n2] + ", " + code.registers[n1]);
    }
    else {
      code.addText("mov" + "  " + code.registers[d] + ", " + code.registers[n1]);
      code.addText("add" + "  " + code.registers[d] + ", " + code.registers[n2]);
    }
  }
  
  void subb(Code code, Element e) {
    code.addComment("subtract");
    int n1 = e.connectors.get(0);
    int n2 = e.connectors.get(1);
    int d = e.defines.get(0);
    if(d == -1) {print("WARN: unused subtraction"); return;}

    if(d == n2) {
      code.addText("sub" + "  " + code.registers[n2] + ", " + code.registers[n1]);
    }
    else {
     code.addText("sub" + "  " + code.registers[n2] + ", " + code.registers[n1]);
     code.addText("mov" + "  " + code.registers[d] + ", " + code.registers[n2]);    
    }
  }
  
  void mul(Code code, Element e) { //TODO push rax (if needed)
    code.addComment("multiply");
    int n1 = e.connectors.get(0);
    int n2 = e.connectors.get(1);
    int d = e.defines.get(0);
    if(d == -1) {print("WARN: unused multiplication ("+x+","+y+")"); return;}
  
    boolean b1 = (code.registers[n1].equals("rax") || code.registers[n2].equals("rax") || code.registers[d].equals("rax"));
    boolean b2 = (code.registers[n1].equals("rdx") || code.registers[n2].equals("rdx") || code.registers[d].equals("rdx"));
  
     if(!b1) {code.addText("push rax");}
     if(!b2) {code.addText("push rdx");}
     code.addText("mov" + "  " + "rax" + ", " + code.registers[n1]);
     code.addText("mul" + "  " + code.registers[n2]);
     code.addText("mov" + "  " + code.registers[d] + ", " + "rax");
     
     if(!b2) {code.addText("pop  rdx");}
     if(!b1) {code.addText("pop  rax");}
  }
  
  void printt(Code code, Element e) {
    code.addComment("print");
    int n = e.connectors.get(0);
    int d = e.defines.get(0);
    
     if((d != -1 && !code.registers[d].equals("rax")) || !code.registers[n].equals("rax")) {
      code.addText("push rax");
    }
    
    if(str != "") {
      code.printText(str);
    }
    
    code.addText("mov" + "  " + "rax" + ", " + code.registers[n]);
    code.addText("call iprintLF");

    if(n != d && d != -1) {
     code.addText("mov" + "  " + code.registers[d] + ", " + code.registers[n]);
    }
    
     if((d != -1 && !code.registers[d].equals("rax")) || !code.registers[n].equals("rax")) {
      code.addText("pop  rax");
    }
  }
  
  void read(Code code, Element e) {
    code.addComment("read");
    int d = e.defines.get(0);
    if(d == -1) {print("WARN: unused read"); return;}
    
    if(str != "") {
      code.printText(str);
    }
    
      
    if(!code.registers[d].equals("rax")) {
      code.addText("push rax");
    }
    
    code.addText("call getinput");
    code.addText("mov" + "  " + code.registers[d] + ", " + "rax");
    
    if(!code.registers[d].equals("rax")) {
      code.addText("pop  rax");
    }
  }
  
  void divv(Code code, Element e) {
    //code.addComment("divide");
    int n2 = e.connectors.get(0);
    int n1 = e.connectors.get(1);
    int d1 = e.defines.get(0);
    
    //boolean b = true; //avoids poping new written rdx at end
    //if(code.registers[d1] == "rdx") {b = false;}
    //if(id == 17 &&  code.registers[ e.defines.get(1) ] == "rdx") { b = false; }
    
    
    //if(b){
    //code.addText("push" + " " + "rdx");
    //code.addText("xor" + "  " + "rdx" + ", " + "rdx");
    //}
    
    //code.addText("mov" + "  " + "rax" + ", " + code.registers[n1]);
    //code.addText("div" + "  " + code.registers[n2]);
    //code.addText("mov" + "  " + code.registers[d1] + ", " + "rax");
    
    //if(id == 17) {
    //  int d2 = c.defines.get(1);
    //  code.addText("mov" + "  " + code.registers[d2] + ", " + "rdx");
    //}
    
    //if(b) {
    
    //code.addText("pop" + "  " + "rdx");
    //}

    code.addComment("divide");
    
    int a1 = 3;
    int a2 = 4;
    if(!code.registers[a2].equals("rax") || !code.registers[a1].equals("rsi")) {
      print("ERROR; in file operator, registers were redefined");
      exit();
      return;
    }
    
    boolean b1 = (e.connectors.contains(a1) || e.defines.contains(a1));
    boolean b2 = (e.connectors.contains(a2) || e.defines.contains(a2));

    if(!b1){code.addText("push rsi");}
    if(!b2){code.addText("push rax");}
    code.addLine();

    arrangeConnectors(e.connectors, new ArrayList<Integer>(Arrays.asList(a1,a2)), code); 
    code.addText("call divide");
    arrangeConnectors(new ArrayList<Integer>(Arrays.asList(a2,a1)), e.defines,  code);
    code.addLine();
    
    if(!b2){code.addText("pop  rax");}
    if(!b1){code.addText("pop  rsi");}
    code.addLine();


  }

  
}
