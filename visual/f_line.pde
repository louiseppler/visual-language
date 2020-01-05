class FieldLine extends Field {
  
  boolean noOrigin = true;
  int ox; int oy; //originX, originY
  boolean isOrigin;
  
  int compilerLocation;

  FieldLine(boolean isOrigin, int x, int y) {
    super(10,x,y);
    this.isOrigin = isOrigin;
  }
  
  FieldLine(String str, int x, int y) {
    super(10,x,y);
    if(str.equals("isOrigin")) {
      isOrigin = true;
    }
    else if(str.length() >= 6) {
      
      ox = Integer.parseInt(str.subSequence(0,3).toString());
      oy = Integer.parseInt(str.subSequence(3,6).toString());
      noOrigin = false;
    } 
  }
  
  @Override
  void moved() {
    ox = movedX(ox,oy);
    oy = movedY(ox,oy);
    super.moved();
  }
  
  String saveStr() {
    if(isOrigin){
      return "isOrigin";
    } 
    if(noOrigin) {
      return "";
    }
    return makeString(ox) + makeString(oy);
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
   if(str != "f") {
      drawLineLocal(x,y);
    }
  }
  
  void drawLineLocal(int x, int y) {
    final String[] names = {">","≥","<","≤","=","≠","=0","≠0"};
    String[] parts = str.split(" ");
    if(!isOrigin && !noOrigin) {
      drawLine(this.x+0.5,this.y+0.5,ox+0.5,oy+0.5);
      
      //lineFormatting(false);
      //line(x+fieldSize*0.5,y+fieldSize*0.5,locationX+(ox+0.5)*fieldSize,locationY+(oy+0.5)*fieldSize);
    }
  }
  
  int getCompilerLocation(Field[][] fields) {
    if(isOrigin) {return compilerLocation;}
    //println(x,y);
    if(fields[ox][oy].id != 10) {println("ERROR at field:" + x + " " + y);     return 0;}
    FieldLine f = (FieldLine)fields[ox][oy];
    return f.compilerLocation;
  }
  
  @Override
  void drawCompile(Field[][] fields, int x, int y, int s) {
    if(drawDebugNumbers) {
      textSize(20);
      textAlign(LEFT); fill(128,0,0);
      text(str(getCompilerLocation(fields)), x+10,y+20);
    }
  }
}
