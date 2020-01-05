class FunctionDef /*Define*/ extends Field {  
  String name;
  int l = 1;
  int id;
  String str = "";
  
  //boolean hasReturn = true;
  FunctionRet funcRet;
  List<Integer> compileConnectors;
    
  FunctionDef(int id, String name, int x, int y, String str,Field[][] fields) {
    super(id,x,y);
    this.isCompileElement = true;
    this.name = name;
    if(str.length() >= 9) {
      this.str = str;
    }
  }
  
  void setup(Field[][] fields) {
    if(str != "") {
      decodeString(str, fields);
    }
     changeSize(l,fields);
  }
  
  void decodeString(String str, Field[][] fields) {
    l = Integer.parseInt(str.subSequence(0,3).toString());
    int fx = Integer.parseInt(str.subSequence(3,6).toString());
    int fy = Integer.parseInt(str.subSequence(6,9).toString());
    name = str.substring(9);
    
    if(fx != 999 && fy != 999) {
      if(fields[fx][fy].id == 84) {
        funcRet = (FunctionRet)fields[fx][fy];
      }
      else {println("ERROR: referenced return isn't of id 84");}
    }
  }

  String saveStr() {
    int fx = 999;
    int fy = 999;
    if(funcRet != null) {
      fx = funcRet.x;
      fy = funcRet.y;
    }
    return makeString(l)+makeString(fx)+makeString(fy)+name;
  }
  
  void drawIcon(int x, int y, int s){
    strokeWeight(1.1);
    fill(255); stroke(0,128,0);
    rect(x,y+s*0.25,(l+2)*s,s*0.5);
    textAlign(CENTER); textSize(s*0.33*(int(largeWriting)*0.75+1));
    fill(0,128,0);
    text(name, x+s*((l+2.0)/2), y+s*0.666);
    
    if(funcRet != null) {
      stroke(0,128,0);
      line(x+s*0.5,y+s*0.5,x+(funcRet.x-this.x)*s+s*0.5,y+(funcRet.y-this.y)*s+s*0.5);
    }
    
    lineFormatting(false);
    for(int i = 1; i < l+1; i++) {
      line(i*s+x+s*0.5,y+s*0.75+1,i*s+x+s*0.5,y+s*1.5);
    }
  }
  
  void changeSize(int newl, Field[][] fields) {
    if(newl < 1) {return;}
    //deleting old fields
    fields[x+1+l][y] = new Field(0,x+1+l,y-1);
    for(int i = newl; i < l; i++) {
      fields[x+1+i][y] = new Field(0,x+1+i,y);
      fields[x+1+i][y+1] = new Field(0,x+1+i,y+1);
    }
    
    //adding new fields
    l = newl;
    for(int i = 0; i < newl; i++) {
      fields[x+1+i][y] = new Field(82,x+1+i,y);
      addLine(x+1+i,y+1,fields,true);
    }
    
    fields[x+1+l][y] = new FunctionRef(83,x+1+l,y,x,y); //to referenc this function
  }
  
  @Override
  void pressed() {
    println("renameing function");
    container.textEditor.startEditing(this,"rename function to");
  }
  
  @Override
  void changeText(String text) {
    this.name = text;
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
      FieldLine f = (FieldLine)fields[x+1+i][y+1];
      element.defines.add( f.getCompilerLocation(fields) );
    }
  }
  
  @Override
  void prepareWrite(Element e) {
    compileConnectors = e.defines;
  }
  
  @Override
  void writeCode(Code code, Element e) {
     code.addComment("function: " + name);
     code.addLine();
  }
}

class FunctionRef /*Reference*/ extends Field {
  int ox; //point where function lives
  int oy;
  FunctionRef(int id, int x, int y, int ox, int oy) {
    super(id,x,y);
    this.ox = ox;
    this.oy = oy;
  }
  
  @Override
  void moved() {
    ox = movedX(ox,oy);
    oy = movedY(ox,oy);
    super.moved();
  }
}
