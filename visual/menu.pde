class Menu {
  int h = 40;
  int[] items = {3,4,8,11,12,13,14,15,16,17,31,32,33,34,35,36,81,84,87,7};
  int current = 0;
  
  Menu() {}
  
  void draw() {
    fill(196);
    noStroke();
    rect(0,height-h,width,height);
    drawIcons();
  }
  
  void drawIcons() {
    for(int i = 0; i < items.length; i++) {
      if(current == items[i]) {
        fill(128);
        noStroke();
        rect(i*h,height-h,h,h);
      }
      
      draw_id(i*h,height-h,h,items[i],true);
    }
    
    fill(196);noStroke();
    if(current == -1) {fill(128);}
    rect(width-h,height-h,h,h);
    strokeWeight(2);
    stroke(128);
    if(current == -1) {stroke(196);}
    delete(width-h,height-h,h);
  }
  
  void resetCurrent() {
    current = 0;
  }
  
  void pressed() {
    if(mouseX > width-h) {
      current = -1;
      return;
    }
    int i = floor(mouseX/float(h));
    if(0 <= i && i < items.length) {
      current = items[i];
    }
  }
}

class Submenu {
  
  Submenu() {}
  
   void hover(int x, int y, int s, Field field) {
     if(field.id == 4 || field.id == 3 || field.id == 7) {
       draw(x,y,s, field.str);
     }
   }
   
   void draw(int x, int y, float s, String txt) {
     textAlign(LEFT);
     textSize(s*0.5);
     float l = textWidth(txt);
     if(l < s*1.5) {l = s*0.5;}
     l += s;
     fill(196); noStroke();
     rect(x+s*1.5,y-s*0.25,l,s*1.5);
     triangle(x+s,y+s*0.5, x+s*1.5,y+s*0.25, x+s*1.5,y+s*0.75);
     fill(128);
     text(txt, x+s*2, y+s*0.5);
     stroke(128); strokeWeight(2);
     line(x+s*2,y+s*0.75,x+l+s,y+s*0.75);
     
   }
}
