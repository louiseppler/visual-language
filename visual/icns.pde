void drawMenuMore(int x, int y, int s){ 
  ellipse(x+s/2,y+s/2,s/3,s/3);
}

void draw_id(int x, int y, float s, int id, boolean b){//b=true if in menu
  switch(id){
    case 3:
      lineFormatting(b);
      line(x+s*0.5,y+s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      fill(255);stroke(0,0,255);
      rect(x+2,y+s*0.25,s-4,s*0.5);
      fill(0,0,255);
      textAlign(CENTER); textSize(s*0.333);
      text("read", x+s*0.5,y+s*0.666);
      fill(255); stroke(0,0,255);
      break;
    case 4:
      lineFormatting(b);
      line(x+s*0.5,y-s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      fill(255);stroke(0,0,255);
      rect(x+2,y+s*0.25,s-4,s*0.5);
      fill(0,0,255);
      textAlign(CENTER); textSize(s*0.333);
      text("print", x+s*0.5,y+s*0.666);
      fill(255); stroke(0,0,255);
      break;
    case 7:
       stroke(224,224,0); fill(255);
       float ss = s/16;
       //triangle(x+1*ss,y+6*ss, x+3*ss,y+5*ss, x+2*ss,y+3*ss);
       //ellipse(x+4*ss,y+3*ss, 6*ss,4*ss);
       ellipse(x+8*ss,y+5*ss, 2*ss,2*ss);
       rect(x+7*ss,y+8*ss, 2*ss,4*ss);
      //textAlign(CENTER); textSize(s*0.5);
      //fill(244,244,0);
      //text("i", x+s*0.5,y+s*0.666);
      break;
    case 8:
      if(b) {
        fill(255,0,255);
        textAlign(CENTER); textSize(s*0.333);
        text("def", x+s*0.5,y+s*0.666);
      }
      break;
    case 11: //+1
      lineFormatting(b);
      line(x+s*0.5,y-s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      stroke(255,0,0); fill(255);
      ellipse(x+s*0.5,y+s*0.5,s*0.75,s*0.75);
      textAlign(CENTER); textSize(s*0.333);
      fill(255,0,0);
      text("+1", x+s*0.5,y+s*0.666);
      break;
    case 12://-1
      lineFormatting(b);
      line(x+s*0.5,y-s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      stroke(255,0,0); fill(255);
      ellipse(x+s*0.5,y+s*0.5,s*0.75,s*0.75);
      textAlign(CENTER); textSize(s*0.333);
      fill(255,0,0);
      text("-1", x+s*0.5,y+s*0.666);
    break;
    case 13: //+
      fill(255);
      lineFormatting(b);
      line(x-s*0.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*1.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*0.5,y+s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      stroke(255,0,0); fill(255);
      ellipse(x+s*0.5,y+s*0.5,s*0.75,s*0.75);
      textAlign(CENTER); textSize(s*0.333);
      fill(255,0,0);
      text("+", x+s*0.5,y+s*0.666);
    break;
    case 14://-
      fill(255);
      lineFormatting(b);
      line(x-s*0.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*1.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*0.5,y+s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      stroke(255,0,0); fill(255);
      ellipse(x+s*0.5,y+s*0.5,s*0.75,s*0.75);
      textAlign(CENTER); textSize(s*0.333);
      fill(255,0,0);
      text("-", x+s*0.5,y+s*0.666);
      break;
    case 15://*
      fill(255);
      lineFormatting(b);
      line(x-s*0.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*1.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*0.5,y+s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      stroke(255,0,0); fill(255);
      ellipse(x+s*0.5,y+s*0.5,s*0.75,s*0.75);
      textAlign(CENTER); textSize(s*0.333);
      fill(255,0,0);
      text("*", x+s*0.5,y+s*0.666);
      break;
    case 16://divide
      fill(255);
      lineFormatting(b);
      line(x-s*0.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*1.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*0.5,y+s*0.5,x+s*0.5,y+s*1.5);
      normFormatting();
      stroke(255,0,0); fill(255);
      ellipse(x+s*0.5,y+s*0.5,s*0.75,s*0.75);
      textAlign(CENTER); textSize(s*0.333);
      fill(255,0,0);
      text("÷", x+s*0.5,y+s*0.666);
      break;
    case 17://divide + rest
      fill(255);
      lineFormatting(b);
      line(x-s*0.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*1.5,y-s*0.5,x+s*0.5,y+s*0.5);
      line(x+s*0.5,y+s*0.5,x+s*0.5,y+s*1.5);
      line(x+s*0.5,y+s*0.5,x+s*1.5,y+s*1.5);
      normFormatting();
      stroke(255,0,0); fill(255);
      ellipse(x+s*0.5,y+s*0.5,s*0.75,s*0.75);
      textAlign(CENTER); textSize(s*0.333);
      fill(255,0,0);
      text("÷", x+s*0.4,y+s*0.5);
      textSize(s*0.2);
      text("rest",x+s*0.6,y+s*0.7);
      break;
     case 10: //line
       fill(0);
       //ellipse(x+s*0.5,y+s*0.5,s*0.25,s*0.25);
       break;
     case 81:
       fill(255);stroke(0,128,0);
      rect(x+2,y+s*0.25,s-4,s*0.5);
      fill(0,128,0);
      textAlign(CENTER); textSize(s*0.25);
      text("define", x+s*0.5,y+s*0.666);
      fill(255); stroke(0,0,255);
      break;
     case 84:
       if(b) {
      fill(255);stroke(0,128,0);
      rect(x+2,y+s*0.25,s-4,s*0.5);
      fill(0,128,0);
      textAlign(CENTER); textSize(s*0.25);
      text("return", x+s*0.5,y+s*0.666);
      fill(255); stroke(0,0,255);
     } break;
     case 87:
       if(b) {
      fill(255);stroke(0,0,255);
      rect(x+2,y+s*0.25,s-4,s*0.5);
      fill(0,0,255);
      textAlign(CENTER); textSize(s*0.25);
      text("call", x+s*0.5,y+s*0.666);
      fill(255); stroke(0,0,255);
     } break;
     case 82:
       lineFormatting(b);
       line(x+s*0.5,y+s*0.75+1,x+s*0.5,y+s*1.5);
       break;
     case 85:
       lineFormatting(b);
       line(x+s*0.5,y+s*0.25,x+s*0.5,y-s*0.5);
       break;
     case 88:
       lineFormatting(b);
       //line(x+s*0.5,y+s*0.75+1,x+s*0.5,y+s*1.5);
       //line(x+s*0.5,y+s*0.25,x+s*0.5,y-s*0.5);
       break;
     default:
       stroke(0);
       break;

  }
  
  if(30 < id && id <= 38) {
     if(b) {//only in menu
      String[] strs = {">","≥","<","≤","=","≠","=0","≠0"}; //TODO duplicate, refactor
       
       fill(255);
       stroke(255,128,0);
       quad(x,y+s*0.5, x+s*0.5,y+s*0.125, x+s,y+s*0.5, x+s*0.5,y+s*0.875);
       textSize(s*0.333);
       fill(255,128,0);
       textAlign(CENTER);
       text(strs[id-31], x+s*0.5, y+s*0.666);
     }
  }
}

 void lineFormatting(boolean b) {
    stroke(128);
    strokeWeight(2);
    if(b) {noStroke();}
  }

  void normFormatting() {
    strokeWeight(1);
  }
    
  
void delete(float x, float y, float s){
  float ss = s/8;
  line(x+1*ss ,y+4*ss,  x+3*ss ,y+2*ss);
  line(x+3*ss ,y+2*ss,  x+7*ss ,y+2*ss);
  line(x+7*ss ,y+2*ss,  x+7*ss ,y+6*ss);
  line(x+1*ss ,y+4*ss,  x+3*ss ,y+6*ss);
  line(x+3*ss ,y+6*ss,  x+7*ss ,y+6*ss);
  line(x+4*ss ,y+3*ss,  x+6*ss ,y+5*ss);
  line(x+4*ss ,y+5*ss,  x+6*ss ,y+3*ss);
}
