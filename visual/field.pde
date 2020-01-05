class Field {
  int id;
  String str = "";
  int x; int y;
  
  boolean isCompileElement = false;
  int compileSegment;

  Field(int id, int x, int y) {
    this.id = id;
    this.x = x;
    this.y = y;
  }
  
  void setup(Field[][] fields) { //called after all fields are initialised
                                 //fixes problems with overwriting other fields  
  }
 
  String saveStr() {
    return "";
  }
    
  void drawField(int x, int y, int s, boolean selected){
    fill(255);
    if(selected) { fill(224); }
    stroke(255);
    strokeWeight(1);
    rect(x,y,s,s);
  }
  
  void pressed() {}
  
  void changeText(String text) {}
  
  void drawIcon(int x, int y, int s){}
  
  void addLine(int x, int y, Field[][] fields, boolean isOrigin) {
    if(fields[x][y] == null || fields[x][y].id != 10) { //avoids overwriting old connections
      fields[x][y] = new FieldLine(isOrigin,x,y);
    }
  }
  
  void moved() {
    x = movedX(x,y);
    y = movedY(x,y);
  }
  
  int movedX(int x, int y) {
    Mouse m = container.mouse;
    if(m.x3 <= x && x < m.x4 && m.y3 <= y && y < m.y4) {
      return x + (m.fieldAtX-m.fieldOldX);
    } 
 
    return x;
  }
  
  int movedY(int x, int y) {
    Mouse m = container.mouse;
    if(m.x3 <= x && x < m.x4 && m.y3 <= y && y < m.y4) {
      return y + (m.fieldAtY-m.fieldOldY);
    } 

    return y;
  }
  
  String makeString(int i) { //makes a string out of an int that is always three chars long
    if(i < 10)  {return "00"+ str(i);}
    if(i < 100) {return "0" + str(i);}
    if(i < 1000){return str(i);}
    println("ERROR: number out of range");
    return "000";
  }
  
  void delete(Field[][] fields) {}
  
  //FieldLine getLine(Field field) {
  //  if(field instanceof FieldLine) {
  //    return (FieldLine)field;
  //  }
  //  println("ERROR, expected FieldLine");
  //  drawError();
  //  return null;
  //}
  
  //TODO
  //void drawError() {
  //  noFill();
  //  strokeWeight(3);
  //  stroke(196,0,0);
  //  int s = container.mouse.fieldSize;
  //  rect(x*s,y*s,s,s);
  //}
  
  void compileSetComponets(Element element, Field[][] fields) {}
  
  void drawCompile(Field[][] fields, int x, int y, int s) {}
    
  void prepareWrite(Element e) {}
  
  void writeCode(Code code, Element e) {}
  
  void arrangeConnectors(List<Integer> start, List<Integer> end, Code code) {
    int max = end.size();
    if(max > start.size()) {max = start.size();}
    
    for(int i = 0; i < max; i++) {
      if(start.get(i) != end.get(i)) {
         code.addText("push "+code.registers[start.get(i)]);
      }
    }
    for(int i = max-1; i >= 0; i--) {
      if(start.get(i) != end.get(i)) {
         code.addText("pop "+code.registers[end.get(i)]);
      }
    }
  }

}
