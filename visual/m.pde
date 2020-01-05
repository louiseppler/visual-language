class Mouse {
  int n = 16;
  int x3, y3, x4, y4; //for selected mode
  
  int locationX = 0;
  int locationY = 0;
  int fieldSize = 50;
  
  int fieldAtX = 0;
  int fieldAtY = 0;
  int fieldOldX = 0;
  int fieldOldY = 0;
  
  int mouseToMoveX = 0;
  int mouseToMoveY = 0;
  
  boolean multipleSecelt = false;
  
  void draw() {
    if(mousePressed && mouseY < height-container.menu.h && container.textEditor.editing == false){
      if (0 <= fieldOldX && fieldOldX < n && 0 <= fieldOldY && fieldOldY < n) {
        if(container.fields[fieldOldX][fieldOldY].id == 0 && mouseButton != RIGHT) {
          if(!multipleSecelt || !(x3 <= fieldOldX && fieldOldX <= x4 && y3 <= fieldOldY && fieldOldY <= y4)) {
            moveFields();
          }
        }
      }
    }
  
    container.draw();
    drawX34();
  }
  
  void mouseMoved(){ 
    //if(!multipleSecelt || (multipleSecelt && mousePressed)) {
      fieldAtX = floor(float(mouseX - locationX)/ width * (float(width)/fieldSize));
      fieldAtY = floor(float(mouseY - locationY)/ height * (float(height)/fieldSize));
    //}
    if(mouseButton == RIGHT) {
      //multipleSecelt = true;
      x3 = fieldOldX; x4 = fieldAtX+1;
      y3 = fieldOldY; y4 = fieldAtY+1;
    } 
  }

  void mousePressed() {
  
    mouseToMoveX = locationX - mouseX;
    mouseToMoveY = locationY - mouseY;
    
    fieldOldX = fieldAtX;
    fieldOldY = fieldAtY;
    
    container.mousePressed();
    
  }
  
  
  void moveFields() {
    locationX = mouseX + mouseToMoveX;
    locationY = mouseY + mouseToMoveY;
  }
  
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
  
    e *= -1; //invert scrolling for mac touchpads
    fieldSize += e;
  
    if(fieldSize < 5){
      fieldSize = 5;
    }
    else{
      locationX -= e * (fieldAtX + 0.5);
      locationY -= e * (fieldAtY + 0.5);
    }
  }
  
  void mouseReleased() {
    if(mouseButton == RIGHT) {
      multipleSecelt = true;
    }
    if((fieldOldX == fieldAtX && fieldOldY == fieldAtY)) {
      multipleSecelt = false;
    }
    
    fieldOldX = fieldAtX;
    fieldOldY = fieldAtY;
  }
  
  void recenter() {
    locationX = 0;
    locationY = 0;
  }
  
  void changeSize(float s) {
    fieldSize = int(s);
  }
  
  int x(int i) {
    return locationX + fieldSize * i;
  }
  
  int y(int i) {
    return locationY + fieldSize * i;
  }
  
   int x() {
    return locationX + fieldSize * fieldAtX;
  }
  
  int y() {
    return locationY + fieldSize * fieldAtY;
  }
    
  boolean selected(int x, int y) {
    //if(multipleSecelt) {
    //  return (x3 <= x && x <= x4 && y3 <= y && y <= y4) || (x == fieldAtX && y == fieldAtY);
    //}
    return (x == fieldAtX && y == fieldAtY) || (mousePressed && x == fieldOldX && y == fieldOldY);
  }
  
  void drawX34() {
    if(!multipleSecelt) {return;}
    noFill();
    stroke(128); strokeWeight(3);
    rect(locationX + x3*fieldSize, locationY + y3*fieldSize, (x4-x3)*fieldSize, (y4-y3)*fieldSize);
  }

}
