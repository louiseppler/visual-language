class TextEditor {
  boolean editing = false;
  String string = "abc";
  float l = 300;
  String msg = "rename function to";
  int s = 50;
    
  String[] buttons = {"Cancel", "Reload (r)","nothing (n)", "OK (ENTER)"};
    
  Field field;
  
  TextEditor() {}
  
  void draw() {
    if(!editing) {return;}
    
    fill(255,196);
    rect(0,0,width,height);
    strokeWeight(1);
    fill(224); stroke(192);
    
    rect(width*0.5-(l+s)*0.5,height*0.25-s*0.25,l+s,s*2);
    textSize(s*0.5);
    textAlign(CENTER);
    fill(128);
    text(string,width*0.5,s*0.75+height*0.25);
    textSize(s*0.25);
    text(msg,width*0.5,height*0.25+s*0.125);
    
    //line(width*0.5-l*0.5-s*0.5,height*0.25+s*0.25,width*0.5+l*0.5+s*0.5,height*0.25+s*0.25);
    line(width*0.5-l*0.5-s*0.5,height*0.25+s*1.125,width*0.5+l*0.5+s*0.5,height*0.25+s*1.125);

    for(int i = 0; i < buttons.length; i++) {
      float x = width*0.5 - l*0.5 + (l/buttons.length)*(i+0.5);
      text(buttons[i],x,height*0.25+s*1.5);
    }
  }
  
  void startEditing(Field field, String msg) {
    this.msg = msg;
    this.field = field;
    editing = true;
    reload();
  }
  
  void show(String str) {
    editing = true;
    if(str == "") {
      reload();
    }
    else {
      setLength();
    }
  }
  
  void reload() {
    string = getTextFromClipboard();
    if(string == null || string.contains("\n") || string.contains("\t")) {
      string = "error";
    }
    setLength();
  }
  
  void setLength() {
    textSize(s*0.5);
    l = textWidth(string);
    textSize(s*0.25);
    float l2 = textWidth(msg);
    if(l < l2) {l = l2;}
    if(l < 300) {l = 300;}
  }
  
  void mouseReleased() {
    if(height*0.25 < mouseY && mouseY < height*0.25+s*2 && width*0.5-l*0.5-s*0.5 < mouseX && mouseX < width*0.5+l*0.5+s*0.5) {
      int indexX = floor((mouseX-width*0.5+l*0.5)/l*buttons.length);
      if(indexX == 0) {
        editing = false;
      }
      if(indexX == 1) {
        reload();
      }
      if(indexX == 2) {
        string = "";
      }
      if(indexX == 3) {
        doneEditing();
      }
    }
    else {
      editing = false;
    }
  }
  
  void keyPressed() {
    if(key == 'r') {
      reload();
    }
    if(keyCode == ENTER) {
      doneEditing();
    }
    if(key == 'n') {
      string = "";
      doneEditing();
    }
  }
    
   
  void doneEditing() {
    field.changeText(string);
    editing = false;
  }




//code form form https://discourse.processing.org/t/answered-how-to-get-text-from-paste-buffer/1900/3

String getTextFromClipboard (){
  String text = (String) getFromClipboard(DataFlavor.stringFlavor);
  return text;
}

Object getFromClipboard (DataFlavor flavor) {

  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard(); 
  Transferable contents = clipboard.getContents(null);
  Object object = null;

  if (contents != null && contents.isDataFlavorSupported(flavor)) {
    try {
      object = contents.getTransferData(flavor);
      println("Clipboard.getFromClipboard() >> Object transferred from clipboard.");
    }
    catch (UnsupportedFlavorException e1)  {// Unlikely but we must catch it
      println("Clipboard.getFromClipboard() >> Unsupported flavor: " + e1); //~  e1.printStackTrace();
    }
    catch (java.io.IOException e2) {
      println("Clipboard.getFromClipboard() >> Unavailable data: " + e2); //~  e2.printStackTrace();
    }
  }

  return object;
}
}

import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.Toolkit;
