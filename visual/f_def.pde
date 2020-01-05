class DefNumber extends Field {
  
  int value = 0;
  
  DefNumber(int x, int y, String str) {
    super(8,x,y);
    isCompileElement = true;
    if(str.length() > 0) {
      value = int(str);
    }
  }
  
  @Override
  String saveStr() {
    return str(value);
  }
  
  @Override
  void setup(Field[][] fields) {
    addLine(x,y+1,fields,true); 
  }
  
  @Override
  void drawIcon(int x, int y, int s) {
     fill(255,0,255);
     textAlign(CENTER); textSize(s*0.333*(int(largeWriting)*0.75+1));
     text(str(value), x+s*0.5,y+s*0.666);
     lineFormatting(false);
     line(x+s*0.5,y+s*0.875,x+s*0.5,y+s*1.5);
  }
  
  void draged(int x2, int y2) {
    int dx = x2-x;
    int dy = y2-y;
    if(dy > 5 || dy < -5) {return;}
    
    print(dx + " " + dy);
    
    if(dy < 0) {
     value = 0;
    }
    else {
      value += dx * int(pow(10,dy));
    }
    
    //float d = ;
    //value += int(d);
    if(value < 0) {value = 0;}
  }
  
  @Override
  void delete(Field[][] fields) {
    fields[x][y+1] = new Field(0,x,y+1);
  }
  
  @Override
  void compileSetComponets(Element element, Field[][] fields) {
    FieldLine f = (FieldLine)fields[x][y+1];
    element.defines.add( f.getCompilerLocation(fields) );
  }
  
  @Override
  void writeCode(Code code, Element e) {
    code.addComment("define number");
    int d = e.defines.get(0);
    if(d == -1) {println("WARN: unused define");return;}
    code.addText("mov" + "  " + code.registers[d] + ", " + str(value));
    code.addLine();
  }
}
