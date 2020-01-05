void saveData(String file) {
  int n = container.n;
  print("Saving data to file: " + file);
  String[] list =  new String[n+2];
  list[0] = "Data V1.1";
  list[1] =  str(n);
  for(int i = 0; i < n; i++) {
    String line = "";
    for(int j = 0; j < n; j++) {
      line += str(container.fields[i][j].id);
      String str = container.fields[i][j].saveStr();
      if(str != "") {
        line += "_" + str;
      }
      line += ";";
    }
    list[i+2] = line;
  }
  //file = "../data/" + file;
  saveStrings(file,list);
}


//numbers sepearted by ";" and "\n"
//str data followd seperated by "_"
void loadData(String file) {
  println("Loading data from file: " + file);
  //file = "../data/" + file;
  String[] lines = loadStrings(file);
  int n = int(lines[1]);
  container.n = n;
  container.mouse.n = n;
  
  
  container.fields = new Field[n][n];
  
  for(int i = 0; i < lines.length-2; i++) {
    String[] parts = split(lines[i+2], ';');
    if(i < n) {
      for(int j = 0; j < parts.length; j++) {
        if(j < n) {
          String[] pparts = split(parts[j],'_');
          int id = int(pparts[0]);
          
          if(pparts.length >= 2) {
            container.addField(i,j,id,pparts[1].toString());
          }
          else {
            container.addField(i,j,id,"");
          }
        }
      }
    }
  }
  
  container.setup();
}
