import java.util.*;

boolean drawDebugNumbers = false;
boolean largeWriting = false; 
//set this true to enlarge names

Container container = new Container();

//gets called once at startup from Processing
void setup() {
  size(800, 800);
  surface.setResizable(true);

  loadData(".data.txt");
}

//gets called 60 times a second form Processing
void draw() {
  container.mouse.draw();
  container.textEditor.draw();
  container.files.draw();
}

//from Processing
void mouseMoved(){ 
  if(container.textEditor.editing == false && container.files.isActive == false) {
    container.mouse.mouseMoved();
   }
}

//form Processing
void mouseDragged() {
  if(container.textEditor.editing == false && container.files.isActive == false) {
    container.mouse.mouseMoved();
  }
}

//from Processing
void mousePressed() {
  if(container.textEditor.editing) {
  }
  else if(container.files.isActive) {
  }
  else {
    container.mouse.mousePressed();
    container.mousePressed();
  }
  
}

//from Processing, for scrolling
void mouseWheel(MouseEvent event) {
  container.mouse.mouseWheel(event);
}

//form Processing
void mouseReleased() {
  if(container.textEditor.editing) {
    container.textEditor.mouseReleased();
  }
  else if(container.files.isActive) {
    container.files.mousePressed();
  }
  else {
    container.mouseReleased();
    container.mouse.mouseReleased();
  }
}

//from Processing
void keyPressed() {
  if (key == ESC) {
    key = 0; //prohibits closing program
  }
  if(container.textEditor.editing) {
    container.textEditor.keyPressed();
    return;
  }
  if(container.files.isActive) {
    container.files.keyPressed();
    return;
  }

  if(key == 's' || key == 'S') { //save
    //saveData();
    container.files.setup();
  }
  if(keyCode == ENTER) {
    if(container.didCompile) {
      container.didCompile = false;
      container.compile = null;
    }
    else {
     saveData(".data.txt");
     container.compile = new Compiler();
     container.compile.start(container.fields);
    }
  }
  if(key == 'd') {
    drawDebugNumbers = !drawDebugNumbers;
  }
  if(key == 'c') { //center
    container.mouse.recenter();
  }
  if(key == '1') {
    container.mouse.changeSize(width/16);
  }
  if(key == '2') {
    container.mouse.changeSize(width/24);
  }
  if(key == '3') {
    container.mouse.changeSize(width/32);
  }
  if(key == '4') {
    container.mouse.changeSize(width/48);
  }
  if(keyCode == BACKSPACE) {
    if(container.menu.current == -1) {
      container.deleteFields();
    }
    container.menu.current = -1;
  }
}

void drawLine(float x1, float y1, float x2, float y2) { //TODO refactor
  lineFormatting(false);
  line(container.mouse.locationX + x1*container.mouse.fieldSize, container.mouse.locationY + y1*container.mouse.fieldSize,
       container.mouse.locationX + x2*container.mouse.fieldSize, container.mouse.locationY + y2*container.mouse.fieldSize);
}

/* OVERVIEW OF IDs
  0 - nothing

  1 exit
  2 fork?
  3 read
  4 print
  
  7 Comments
  
  8 Define number
  9 Line intersection
  10 line
  
  11 +1
  12 -1
  13 +
  14 -
  15 *
  16 divide
  17 divide + rest
  
  31 >
  32 >=
  33 <
  34 <=
  35 ==
  36 !=
  37 == 0
  38 != 0  

  81 Define Function
  82 
  83
  
  84 Return
  85
  86
  
  87 Call
  88
  89
*/
