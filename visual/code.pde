class Code {
  String[] registers = {"r8","r9","rdx","rsi","rax","rdi"};
  int constantCount = 0; //for defining texts
  String msgs = "";
  String text = "";
  int segment;
  boolean needsRet = false;
  int conditionCount = 0;
  
  List<Integer> standartForm =  new ArrayList<Integer>(Arrays.asList(0,1,2,3,4,5));
  
  void addText(String txt) {
    text += "   " + txt + "\n";
  }
  
  void addLine() {
    text += "\n";
  }
  
  int addData(String data) {
    msgs += "msg"+str(constantCount)+"        db      '"+data+"',0h\n";
    constantCount ++;
    return constantCount-1;
  }
  
  void printText(String str) {
    int i = addData(str);
    addText("mov  rax, msg" + str(i));
    addText("call sprintLF");
  }
  
  void startSegment() {
    //if(needsRet) {
    //  addText("ret");
    //  needsRet = false;
    //}
    addText("call exit");
    segment++;
    text += "segment"+str(segment)+":\n";
  }
  
  void jmpNextSegment() {
    addText("jmp segment" + str(segment+1));
  }
  
  void addExit() {
    startSegment();
    addText("call exit");
  }
  
  void addComment(String str) {
    addText(";" + str);
  }
  
  void compile() {
    println("  writing code to file");
    List<String> lines = new ArrayList<String>();
    
    String[] lines1 = loadStrings("code1");
    String[] lines2 = loadStrings("code2");
    String[] lines3 = loadStrings("code3");
    
    for(int i = 0; i < lines1.length; i++) {
      lines.add(lines1[i]);
    }
    lines.add(msgs);
    for(int i = 0; i < lines2.length; i++) {
      lines.add(lines2[i]);
    }
    lines.add(text);
    for(int i = 0; i < lines3.length; i++) {
      lines.add(lines3[i]);
    }
    
    String[] liness = new String[lines.size()];
    for(int i = 0; i < liness.length; i++) {
      liness[i] = lines.get(i);
    }
    
    saveStrings("../target/main.s",liness);
  }
}
