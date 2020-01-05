class Container {
  Field[][] fields;
  Menu menu = new Menu();
  Submenu submenu = new Submenu();
  Mouse mouse = new Mouse();
  TextEditor textEditor = new TextEditor();
  Compiler compile;
  FileManager files = new FileManager();
  int n;
  
  boolean didCompile = false;
  
  Container() {}

  void draw() {
    drawFileds();
    submenu();
    menu.draw();
    
  }
  
  void mousePressed() {
    int x = mouse.fieldAtX;
    int y = mouse.fieldAtY;
     if(mousePressed && mouseY < height-container.menu.h && textEditor.editing == false) {
      if (0 <= x && y < n && 0 <= x && y < n) {
        if(menu.current != 0) {
          didCompile = false;
          if(menu.current == -1) {
            //Delete item
            deleteField(x,y);
          }
          else {
            println("Adding new item");
            //at new item
            if(fields[x][y].id == 0) {
              addField(x,y,menu.current, "");
              fields[x][y].setup(fields);
            }
          }
        }
        else {
          //no menu item selected
          fieldPressed(x,y);
        }
      }
    }
    menu.resetCurrent();
    if(mousePressed && mouseY > height-container.menu.h){
      menu.pressed();
    }
  }

  
  void fieldPressed(int x, int y) {
    if(fields[x][y].id == 87) {
      //changeCallFunction(x,y);
    }
  }
 
  void deleteField(int x, int y) {
    println("Deleting item");
    fields[x][y].delete(fields);
    fields[x][y] = new Field(0,x,y);
    
  }
  
  void addField(int x, int y, int id, String str) {
    
    if(1 <= id && id <= 6) {
      fields[x][y] = new FieldOperator(id,x,y,str); 
    }
    else if(id == 7) {
      fields[x][y] = new FieldComment(x,y,str);
    }
    else if(id == 8) {
      fields[x][y] = new DefNumber(x,y,str);
    }
    else if(id == 10) {
      fields[x][y] = new FieldLine(str,x,y);
    }
    
    else if(11 <= id && id <= 19) {
      fields[x][y] = new FieldOperator(id,x,y,str); 
    }

    else if(30 < id && id <= 38) {
      fields[x][y] = new FieldComparator(id,x,y, fields);
    } 
    else if(id == 81) {
      
      FunctionDef f = new FunctionDef(id, "function "+Integer.toHexString(x)+Integer.toHexString(y),x,y,str, fields);
      fields[x][y] = f;
      //functions.add(f);
      //functions.get(functions.size()-1).changeSize(3,fields);
    }
    else if(id == 84) {
      FunctionRet f = new FunctionRet(id,x,y,str);
      fields[x][y] = f;
    }
    else if(id == 87) {
      FunctionCall f = new FunctionCall(id,x,y,0,str, fields);
      fields[x][y] = f;
    }
    
    else if(fields[x][y] == null) {
      fields[x][y] = new Field(0,x,y);
    }
  }
  
  void setup() {
    for (int x = 0; x < mouse.n; x++) {
      for (int y = 0; y < mouse.n; y++) {
         fields[x][y].setup(fields);
      }
    }
  }

  void submenu() {
    if (0 <= mouse.fieldAtX && mouse.fieldAtX < mouse.n && 0 <= mouse.fieldAtY && mouse.fieldAtY < mouse.n) {
      submenu.hover(mouse.x(), mouse.y(),mouse.fieldSize, fields[mouse.fieldAtX][mouse.fieldAtY]);
    }
  }

  void drawFileds() {
    background(0);
    for (int x = 0; x < n; x++) {
      for (int y = 0; y < n; y++) {
        fields[x][y].drawField(mouse.x(x), mouse.y(y), mouse.fieldSize, mouse.selected(x,y));
      }
    }
    for (int x = 0; x < n; x++) {
      for (int y = 0; y < n; y++) {
        //rect((x-0)*fieldSize+locationX,(y-0)*fieldSize+locationY,fieldSize,fieldSize);
        fields[x][y].drawIcon(mouse.x(x), mouse.y(y), mouse.fieldSize);
      }
    }
    for (int x = 0; x < n; x++) {
      for (int y = 0; y < n; y++) {
        textSize(10);
        textAlign(LEFT); fill(128);
        if(fields[x][y].id != 0 && drawDebugNumbers) {
          text(str(fields[x][y].id), mouse.x(x),mouse.y(y)+10);
        }
      }
    }
    if(drawDebugNumbers) {
      //draws coordinates for selected field
      text(mouse.fieldAtX + " - " + mouse.fieldAtY, mouse.x(mouse.fieldAtX),mouse.y(mouse.fieldAtY+1));
    }
    
    if(didCompile) {
      fill(128);
      fill(196); stroke(128);
      int s = 50;
      strokeWeight(1);
      rect(width/2-s*2, s*0.5, s*4, s);
      fill(128);
      textSize(s*0.6666);
      textAlign(CENTER);
      text("Compiled!", width/2,s*1.25);
      for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
          fields[x][y].drawCompile(fields, mouse.x(x), mouse.y(y), mouse.fieldSize);
        }
      }
    }
   
  }
  
  void mouseReleased() {
    int x1 = mouse.fieldOldX;
    int y1 = mouse.fieldOldY;
    int x2 = mouse.fieldAtX;
    int y2 = mouse.fieldAtY;
    println(x1 + " " + x2);
    if ((0 <= x2 && x2 < n && 0 <= y2 && y2 < n) == false) { return; }
    if(x1 == x2 && y1 == y2) {
      println("field is: "+ fields[x1][y1].id);
      fields[x1][y1].pressed();

      //if(fields[x1][x1].id == 87) {
      //  refreshCall(x1,y1,x2,y2);
      //} //TODO
      
      return; //no movement
    }
    
    if(mouse.multipleSecelt) {
      moveFields(x1,y1,x2,y2);
      return;
    }
    
    println(x1 + "->" + x2);
  
    int id = fields[x1][y1].id;
    if(id == 83) {
      dragFunction(x1,y1,x2,y2);
    }
    else if(id == 86) {
      dragRetun(x1,y1,x2,y2);
    }
    else if(id == 10) {
      setLines(x1,y1,x2,y2);
    }
    else if(id == 87) {
      referenceFunctino(x1,y1,x2,y2);
    }
    else if(id == 84) {
      referenceReturn(x1,y1,x2,y2);
    }
    else if(id == 8) {
      DefNumber f = (DefNumber)fields[x1][y1];
      f.draged(x2,y2);
    }
  }
  //TODO move into field classes
  void dragFunction(int x1, int y1, int x2, int y2) {
    FunctionRef fr = (FunctionRef)fields[x1][y1];
    FunctionDef fd = (FunctionDef)fields[fr.ox][fr.oy];
    fd.changeSize(x2-fd.x-1,fields);
  }
  
  void refreshCall(int x1, int y1, int x2, int y2) {
    if(x1 == x2 && y1 == y2) {
      FunctionCall f = (FunctionCall)fields[x1][y1];
      f.changedSize(fields);
    }
  } 
  
  void referenceReturn(int x1, int y1, int x2, int y2) {
    if(fields[x2][y2].id != 81) {return;}
    
    FunctionDef fd = (FunctionDef)fields[x2][y2];
    FunctionRet fr = (FunctionRet)fields[x1][y1];
    
    fd.funcRet = fr;
  }
  
  void referenceFunctino(int x1, int y1, int x2, int y2) {
    if(fields[x2][y2].id != 81) {return;}
    
    FunctionCall f = (FunctionCall)fields[x1][y1];
    f.changeFunction((FunctionDef) fields[x2][y2], fields);
  }
  
  void dragRetun(int x1, int y1, int x2, int y2) {
    FunctionRef fr = (FunctionRef)fields[x1][y1];
    FunctionRet fret = (FunctionRet)fields[fr.ox][fr.oy];
    fret.changeSize(x2-fret.x-1,fields);
  }
  
  void setLines(int x1, int y1, int x2, int y2) {
    if(fields[x2][y2].id != 10) { return; }
    FieldLine f1 = (FieldLine)fields[x1][y1];
    FieldLine f2 = (FieldLine)fields[x2][y2];
    
    if(f1.isOrigin == false && f2.isOrigin) {
      f1.ox = x2;
      f1.oy = y2;
      f1.noOrigin = false;
    }
    else if(f1.isOrigin && f2.isOrigin == false) {
      f2.ox = x1;
      f2.oy = y1;
      f2.noOrigin = false;
    }
    
  }
  
  void moveFields(int x1, int y1, int x2, int y2) {
    println("Moveing fields");
    int mdx = x2-x1; //move delta x
    int mdy = y2-y1;
    int x3 = mouse.x3; 
    int x4 = mouse.x4;
    int y3 = mouse.y3; 
    int y4 = mouse.y4;
    //if(dy < 0 || dy < 0) {println("Failed, dx||dy < 0");return;}
    if(x4 + mdx >= mouse.n || y4 + mdy >= mouse.n) {println("out of bounds"); return;}
    
    
    mouse.multipleSecelt = false;
    Field[][] fieldsCopy = new Field[x4-x3][y4-y3];
    
    for(int x = 0; x < x4-x3; x++) {
      for(int y = 0; y < y4-y3; y++) {
        fieldsCopy[x][y] = fields[x3+x][y3+y];
        fields[x3+x][y3+y] = new Field(0,x3+x,y3+y);
      }
    }
    
    for(int x = 0; x < x4-x3; x++) {
     for(int y = 0; y < y4-y3; y++) {
        fields[x3+mdx+x][y3+mdy+y] = fieldsCopy[x][y];
        
      }
    }
   
    
    for(int x = 0; x < fields.length; x++) {
      for(int y = 0; y < fields.length; y++) {
        fields[x][y].moved();
      }
    }
  }
  
  void deleteFields() {
    if(mouse.multipleSecelt) {
      for(int x = mouse.x3; x < mouse.x4; x++) {
        for(int y = mouse.y3; y < mouse.y4; y++) {
          fields[x][y] = new Field(0,x,y);
        }
      }
    }
  }

}
