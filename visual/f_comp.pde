class FieldComparator extends Field {
  final String[] names = {">","≥","<","≤","=","≠","=0","≠0"};
  int compileLocation1; //stores array index
  int compileLocation2;
  
  FieldComparator(int id, int x, int y, Field[][] fields) {
    super(id,x,y);
  }
  
  void setup(Field[][] fields) {
    addLine(x,y-1,fields,false);
    addLine(x+1,y-1,fields,false);  
    
    //if(fields[x+1][y].id != 87) {
    //  FunctionCall f = new FunctionCall(87, x+1, y, 0, "", fields);
    //  fields[x+1][y] = f;
    //}
    if(fields[x+1][y].id == 87) {
      FunctionCall f = (FunctionCall)fields[x+1][y];
      f.funcComp = this;
    }
    else if(fields[x+1][y].id == 84) {
      FunctionRet f = (FunctionRet)fields[x+1][y];
      f.funcComp = this;
    }
  }
  
  String saveStr() {
    return "";
  }
  
  void drawIcon(int x, int y, int s) {
    lineFormatting(false);
    line(x+s*1.0,y-s*0.0,x+s*0.5,y-s*0.5);
    line(x+s*1.0,y-s*0.0,x+s*1.5,y-s*0.5);
    fill(255); stroke(255,128,0);
    quad(x,y,x+s,y+s*0.75,x+2*s,y,x+s,y-s*0.75);
    fill(255,128,0);
    textSize(s*0.666); textAlign(CENTER);
    text(names[id-31], x+s,y+s*0.1666);
    draw_id(x/*+s*/,y,s,id,false);
  }
  
  void drawLineLocal(int x, int y) {
    String[] parts = str.split(" ");
    if(parts.length >= 2) {
      int x2 = int(parts[0]);
      int y2 = int(parts[1]);
      
      drawLine(this.x+0.5, this.y+0.5,x2+0.5,y2+0.5); 
      //lineFormatting(false);
      //line(x+fieldSize*0.5,y+fieldSize*0.5,x+(x2+0.5-x)*fieldSize,locationY+(y2+0.5)*fieldSize);
    }
  }
  
  void delete(Field[][] fields) {
    fields[x][y-1] = new Field(0,x,y-1);
    fields[x+1][y-1] = new Field(0,x+1,y-1);
  }
  
  void compileSetComponetsLoc(Element element, Field[][] fields) {
    int n1 = ((FieldLine)fields[x][y-1]).getCompilerLocation(fields);
    int n2 = ((FieldLine)fields[x+1][y-1]).getCompilerLocation(fields);
    
    boolean b1 = true;
    boolean b2 = true;
    
    for(int i = 0; i < element.connectors.size(); i++) {
      int n = element.connectors.get(i);
      if(n == n1) {b1 = false; compileLocation1 = i;}
      if(n == n2) {b2 = false; compileLocation2 = i;}
    }
    //avoid adding duplicated connector
    if(b1) {element.connectors.add(n1); compileLocation1 = element.connectors.size()-1;}
    if(b2) {element.connectors.add(n2); compileLocation2 = element.connectors.size()-1;}
  }
  
  void writeCodeLoc(Code code, Element e) {
    int n1 = e.connectors.get(compileLocation1);
    int n2 = e.connectors.get(compileLocation2);
    code.addText("cmp" + "  " + code.registers[n1] + ", " + code.registers[n2]);
  }
  
  String getConditionCmd() {
    String[] cmds = {"jg  ","jge ","jl  ","jle ","je  ","jne "};
    return cmds[id-31]; 
  }
  
  String getReverseConditionCmd() {
    String[] cmds = {"jle ","jl  ","jge ","jg  ","jne ","je  "};
    return cmds[id-31]; 
  }
  
}
