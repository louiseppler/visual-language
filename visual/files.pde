import java.util.Arrays; //to sort arrays

class FileManager {
  boolean isActive = false;
  String[] cmds = {"New","Save local","Save to data folder","Load form data folder","Cancel"};
  String[] msgs = {"Will override local file!","(s)","","Will override local file!",""};
  
  int s = 50;
  int i = 0; //menubutton pressed
  
  void setup() {
    println("setting up files manager");
    isActive = true;
  }
  
  void draw() {
    if(!isActive) {return;}
    fill(255,196);
    strokeWeight(1);
    rect(0,0,width,height);
   
   
    for(int i = 0; i < cmds.length; i++) {
      fill(196);    stroke(128);
      rect(width*0.25,s*(i+4),width*0.5,s);
      fill(128); textSize(s*0.5);
      text(cmds[i], width*0.5, s*(i+4.5)); 
      textSize(s*0.25);
      text(msgs[i], width*0.5, s*(i+4.875));
    }
  }
  
  void mousePressed() {
     i = mouseY/s-4;
     //if(mouseX < width*0.25 || mouseX > width*0.75) {isActive = false;}
     //if(i >= 4) {isActive = false;}
     //if(i < 0) {isActive = false;}
     
     if(i == 0) {loadData(".empty.txt");}
     if(i == 1) {saveData(".data.txt");}
     if(i == 2) {new FileManagerEditing("Save data to file ; Will override old file!",i); isActive = false;} //save
     if(i == 3) {new FileManagerEditing("Load data form file",i); isActive = false;} //load
     
     isActive = false;
  }
  
  void keyPressed() {
    if(key == 's' || key == 'S') {
      saveData(".data.txt");
      isActive = false;
    }
    if(key == 'n' || key == 'N') {
      loadData(".empty.txt");
      isActive = false;
    }
    
  }
}

class FileManagerEditing extends Field { //extends field to be able to use texteditor
  int i;
  
  FileManagerEditing(String msg, int i) {
    super(0,0,0);
    container.textEditor.startEditing(this, msg);
    this.i = i;
  }
  
  @Override
  void changeText(String text) {
    if(text == "") {println("File name not valid (empty)");}
    
    if(i == 2) {
      saveData("../data/"+text);
    }
    if(i == 3) {
      loadData("../data/"+text);
    }
  }

  
}



//class PickFile {
//  boolean isActive = false;
//  String[] files;
  
//  int y = 0;
//  int s = 50;
  
//  void setup() {
//    println("setting up files manager");
//    isActive = true;
//    files = loadStrings("data/_index.txt");
//    Arrays.sort(files);
//  }
  
//  void draw() {
//    if(!isActive) {return;}
//    background(255);
//    fill(0);
//    textSize(s*0.5);
//    textAlign(CENTER);
//    for(int i = 0; i < files.length; i++) {
//      text(files[i], width/2,y+s*i+s);
//    }
//  }
  
//  void mousePressed() {
//    int i = (mouseY-y)/s;
//    if(i > 0 && i < files.length) {
//      println(files[i]);
//    }
//  }
  
//  void scroll(int d) {
//    if(!isActive) {return;}
//    y += d;
//    if(y < -s*files.length+width-s) {y = -s*files.length+width-s;}
//    if(y > 0) {y = 0;}    
//  }
//}
