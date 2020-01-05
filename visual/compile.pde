class Compiler {
  Field[][] fields;
  int connectorsCount = 0; //represents the count of data lines(/registers)
  List<Element> elements = new ArrayList<Element> ();   //represents an operation/print/read etc 
  List<List<Integer>> segments = new ArrayList<List<Integer>>(); //each function gets its own segemnts; segments have no liens connectring eachother
  
  void start(Field[][] fields) {
    println("Compiling...");
    this.fields = fields;
    getComponents();
    setComponents();
    makeSegments();
    sortComponents();
    //todo? optimise order of componets to save register space
    mergeConnectors();
    writeCode();
    
    container.didCompile = true;
  }
  
  void getComponents() {
    println("  getting elements");

     for(int y = 0; y < fields.length; y++) {
       for(int x = 0; x < fields.length; x++) {

       //if(fields[x][y].id == 87) {
       // //println(fields[x][y].id +"  "+fields[x][y].isCompileElement);

       //}
        if(fields[x][y].isCompileElement) {
          //println(fields[x][y].id);
          elements.add(new Element(fields[x][y],elements.size(),fields[x][y].id));
        }
        
        //reference line count
        if(fields[x][y].id == 10) {
          FieldLine f = (FieldLine)fields[x][y];
          if(f.isOrigin) {
            connectorsCount++;
            f.compilerLocation = connectorsCount;
          }
        }
      }
    }
  }
  
  void setComponents() {
    println("  setting elements");
    println("    elements:");
    for(int i = 0; i < elements.size(); i++) {
      (elements.get(i)).set(fields);
    }
  }
  
  void makeSegments() {
    boolean[] done = new boolean[elements.size()];
    
    for(int i = 0; i < elements.size(); i++) {
      boolean[] seg = new boolean[connectorsCount+1];
      boolean didFirst = false;
      //print("   ----");
      //printBooleanArray(done);
      for(int j = 0; j < elements.size(); j++) {
        if(done[j]) { continue; }
        Element e = elements.get(j);
        //printBooleanArray(seg);
        
        if(!didFirst) {
          //print("#"+j + " ");
          didFirst = true;
          addAll(e,seg,i);
          done[j] = true;
        }
        else {
          boolean go = false;
          for(int k = 0; k < e.connectors.size(); k++) {
            if(seg[e.connectors.get(k)]) {go = true;}
            //if(go) {break;}
          }
          for(int k = 0; k < e.defines.size(); k++) {
            if(seg[e.defines.get(k)]) {go = true;}
            //if(go) {break;}
          }
          if(go) {
            //print(j + " ");
            done[j] = true;
            addAll(e,seg,i);
            
            j = 0;
          }
        }
                  //println();

      }
      List<Integer> list = new ArrayList<Integer>();
      for(int j = 0; j < seg.length; j++) {
        if(seg[j]) {
          list.add(j);
        }
      }
      if(list.size() != 0) {
        segments.add(list);
        //println();
      }
    }
    
    //println(segments);    
  }
  
  void printBooleanArray(boolean[] b) {
    print("[");
    for(int i = 0; i < b.length; i++) {
      if(b[i]) {
        print(i + " ");
      }
      //print(b[i] + ", ");
    }
    println("]");
  }
  
  void addAll(Element e, boolean[] seg, int segNumber) {
    e.segment = segNumber;
    for(int k = 0; k < e.connectors.size(); k++) {
      seg[e.connectors.get(k)] = true;
    }
    for(int k = 0; k < e.defines.size(); k++) {
      seg[e.defines.get(k)] = true;
    }
  }
  
  void sortComponents() {
    //sort by segments
    Collections.sort(elements, new Comparator<Element>() {
        @Override public int compare(Element e1, Element e2) {
            return e1.segment - e2.segment; // Ascending
        }
    });
    
    println("sorted by segments");
    printComponents();
    
    //avoiding use of connector before it's defined
    int[] defined = new int[connectorsCount+1];
    int[] firstUse = new int[connectorsCount+1];
    //int[] lastUsed = new int[connectorsCount+1];
    setDefined(defined,firstUse);

    int k = 0;
    int max = connectorsCount*2;
    
    for(int i = 0; i <= connectorsCount; i++) {
      if(k > max) {println("ERROR: possible cycle");return;}
      if(firstUse[i] != -1 && defined[i] > firstUse[i]) {
        k++;
        moveComponents(firstUse[i],defined[i],defined,firstUse);
        setDefined(defined,firstUse);
        i = -1;
      }
    } 
    
    println("sorted");
    printComponents();
  }
  
  void setDefined(int[] defined, int[] firstUse) {
    for(int i = 0; i < firstUse.length; i++) { firstUse[i] = -1;}
    
    for(int i = elements.size()-1; i >= 0 ; i--) {
      for(Integer j : (elements.get(i)).defines) {
        defined[j] = i;
      }
      for(Integer j : (elements.get(i)).connectors) {
        firstUse[j] = i;
      }
    }
  }
  
  void moveComponents(int a, int b, int[] defined, int[] firstUse) {//from a to b
    Element element = elements.get(a);
    elements.remove(a);
    elements.add(b,element);
  }
  
  void mergeConnectors() { //merge data lines to minimise amount of registers used
                           //as soon as a dataline isn't used anymore, replace with new one
    println("  Starting merge");
    int[] defined = new int[connectorsCount+1];
    int[] lastUse = new int[connectorsCount+1];
    
    for(int i = 0; i < lastUse.length; i++) {
      lastUse[i] = -1;
    }
    
    for(int i = 0; i < elements.size(); i++) {
      for(Integer j : (elements.get(i)).defines) {
        defined[j] = i;
      }
      for(Integer j : (elements.get(i)).connectors) {
        lastUse[j] = i;
      }
    }   

    boolean[] occupied = new boolean[connectorsCount+1];
    int[] translate = new int[connectorsCount+1]; //saves the new connector after mege

    for(int i = 0; i < elements.size(); i++) {
      Element e = elements.get(i);
      //tranlate all connectrs to new register/line
      for(int j = 0; j < e.connectors.size(); j++) {
        int n = translate[e.connectors.get(j)];
        e.connectors.set(j,n);
      }
      
      //ceck if register is no longer needed
      for(int j = 0; j <= connectorsCount; j++) {
        if(lastUse[j] == i) {
          occupied[translate[j]] = false;
        }
      }
      
      //set registers that are still inuse
      for(int j = 0; j <= connectorsCount; j++) {
        if(occupied[j]) {
          e.inuse.add(j);
        }
      } 
      
      //move newly defined connectors to lowest register/line possible
      for(int k = 0; k < e.defines.size(); k++) {
        int define = e.defines.get(k);
        if(lastUse[define] == -1) {
          e.defines.set(k,-1);
          break;
        }
        for(int j = 0; j <= connectorsCount; j++) {
          if(!occupied[j]) {
            occupied[j] = true;
            translate[define] = j;
            e.defines.set(k,j);
            j = connectorsCount; //stops this loop
          }
        } 
      }
    }
  
    println("done");
    for(int i = 0; i < elements.size(); i++) {
      (elements.get(i)).print();
    }
  }
  
  void writeCode() {
    println("makeing code");
    //preapare
    for(Element e : elements) {
      e.field.compileSegment = e.segment;
      e.field.prepareWrite(e);
    }   
    
    Code code = new Code();
    //entry point
    int seg = 0;
    int entry = 0;
    for(Element e : elements) {
      if(seg != e.segment) {
        seg = e.segment;
        if(e.id != 81) {
          entry = e.segment;
        }
      }
    }
    
    if(entry != 0) {
      code.addText("call segment" + entry + "\n\n");
      code.text += "segment0:\n";
    }
    
    //making the actual code 
    for(Element e : elements) {
      e.writeCode(code);
    }
    code.addText("call exit");
    code.compile();
  }
  
  void printComponents() {
    for(int i = 0; i < elements.size(); i++) {
      (elements.get(i)).print();
    }
  }
}


class Element {
  Field field;
  int i;
  int id;
  int segment;
  List<Integer> connectors = new ArrayList<Integer> (); //registers needed for element
  List<Integer> defines = new ArrayList<Integer> (); //new defined registers by element
  
  //stores registers that will be needed later on (and are not defined in this element); is used to preserve registers on stack  
  List<Integer> inuse = new ArrayList<Integer> (); 
  
  Element(Field field, int i, int id) {
    this.field = field;
    this.i = i;
    this.id = id;
  }
  
  void set(Field[][] fields) {
    field.compileSetComponets(this, fields);
    print();
  }
  
  void print() {
    if(id < 10) { //extra space for alignment
      println("    "+id + "   | "+segment+" | "+connectors + " -> " + defines);
    }
    else {
      println("    "+id + "  | "+segment+" | "+connectors + " -> " + defines);
    }
  }
  
  void writeCode(Code code) {
    if(code.segment != segment) {
      code.startSegment();
    }
    field.writeCode(code,this);
  } 
}
