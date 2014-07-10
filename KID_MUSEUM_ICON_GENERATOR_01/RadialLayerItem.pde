class RadialLayerItem {
  RadialLayerItem[] children;
  int childCount = 1;
  int layerCount = 3;

  // ------ constructor ------
  RadialLayerItem(int layerCount) {
    
    this.layerCount = layerCount;

    if (this.layerCount > 0) {

        children = new RadialLayerItem[layerCount];
//        for (int i = 0 ; i < layerCount; i++) {
          // skip the . and .. directory entries on Unix systems
//          if (contents[i].equals(".") || contents[i].equals("..") || contents[i].substring(0,1).equals(".")) {
//            continue;
//          }
//          File childFile = new File(file, contents[i]);
          // skip any file that appears to be a symbolic link
//          try {
//            String absPath = childFile.getAbsolutePath();
//            String canPath = childFile.getCanonicalPath();
//            if (!absPath.equals(canPath)) continue;
//          } 
//          catch (IOException e) { 
//          }
//          FileSystemItem child = new FileSystemItem(childFile);
          RadialLayerItem child = new RadialLayerItem(this.layerCount - 1);
          children[0] = child; // children[childCount] = child;
//          childCount++;

//          folderMinFilesize = min(child.getFileSize(),folderMinFilesize);
//          folderMaxFilesize = max(child.getFileSize(),folderMaxFilesize); 
//        }
        // remember the biggest and smallest filesite on each depth
//        for (int i = 0 ; i < childCount; i++) {
//          children[i].folderMinFilesize = folderMinFilesize;
//          children[i].folderMaxFilesize = folderMaxFilesize;        
//        }

//      }
    }
  }


  // ------ get file size function ------
  // how many MEGABYTE has my FileSystemItem
//  float getFileSize() {
//    float MEGABYTE = 1048576;
//    return getFileSize(this) / MEGABYTE;
//  }

//  long getFileSize(FileSystemItem hdItem) {
//    try {
//      if (hdItem.file.isFile()) return hdItem.file.length();
//      FileSystemItem[] hdItems = hdItem.children;
//      long totalSize = 0;
//      if (hdItems != null) {
//        for (int i = 0; i < hdItems.length; i++)
//          totalSize += getFileSize(hdItems[i]);
//      }
//      return totalSize;
//    }
//    catch (NullPointerException e) {
//      return 0; 
//    }
//  }


//  // ------ compare last file modification with current date function ------
//  int getNotModifiedSince(File theFile) {
//    // get the date in milliseconds
//    // current file
//    Calendar theLater = Calendar.getInstance();
//    theLater.setTime(new Date(theFile.lastModified()));
//    long milis1 = theLater.getTimeInMillis();
//    // now, global var
//    long milis2 = now.getTimeInMillis();
//    // calculate difference in milliseconds
//    long diff = milis2 - milis1;
//    // calculate difference in days
//    long diffDays = diff / (24 * 60 * 60 * 1000);
//    return (int) diffDays;
//  }


//  // ------ print and debug functions ------
//  // Depth First Search
//  void printDepthFirst() {
//    println("printDepthFirst");
//    // global fileCounter
//    fileCounter = 0;
//    printDepthFirst(0,-1);
//    println(fileCounter+" files");
//  }
//  void printDepthFirst(int depth, int indexToParent) {
//    // print four spaces for each level of depth + debug println
//    for (int i = 0; i < depth; i++) print("    ");  
//    println(fileCounter+" "+indexToParent+"<-->"+fileCounter+" ("+depth+") "+file.getName());
//
//    indexToParent = fileCounter;
//    fileCounter++;
//
//    // now handle the children, if any
//    for (int i = 0; i < childCount; i++) {
//      children[i].printDepthFirst(depth+1,indexToParent);
//    }
//  }



  // Breadth First Search
//  void printBreadthFirst() {
//    println("printBreadthFirst");
//
//    // queues for pushing and saving all elements in "breadth first search" style
//    ArrayList items = new ArrayList();  
//    ArrayList depths = new ArrayList(); 
//    ArrayList indicesParent = new ArrayList(); 
//
//    // add first elements and startingpoint
//    items.add(this);
//    depths.add(0);
//    indicesParent.add(-1);
//
//    // tmp vars for running in while loop
//    int index = 0;
//    int itemCount = 1;
//
//    while (itemCount > index) {
//      FileSystemItem item = (FileSystemItem) items.get(index);
//      int depth = (Integer) depths.get(index); 
//      int indexToParent = (Integer) indicesParent.get(index);
//
//      // print four spaces for each level of depth + debug println
//      for (int i = 0; i < depth; i++) print("    ");
//      println(index+" "+indexToParent+"<-->"+index+" ("+depth+") "+item.file.getName());
//
//      // is current node a directory?
//      // yes -> push all children to the end of the items
//      if (item.file.isDirectory()) {      
//        for (int i = 0; i < item.childCount; i++) {
//          items.add(item.children[i]);  
//          depths.add(depth+1);
//          indicesParent.add(index);    
//        }
//        itemCount += item.childCount;
//      }
//      index++;
//    }
//    println(index+" files");
//  }
  
  
  // Breadth First
  SunburstItem[] createSunburstItems() {
    print("createRadialSunburstItems -> ");

//    float megabytes = this.getFileSize();
//    float anglePerMegabyte = TWO_PI/megabytes;

    // temp array for pushing and saving all elements in "breadth first search" style
    ArrayList items = new ArrayList();  
    ArrayList depths = new ArrayList(); 
    ArrayList indicesParent = new ArrayList(); 
    ArrayList sunburstItems = new ArrayList();
    ArrayList angles = new ArrayList(); 

    // add first elements and startingpoint
    items.add(this);
    depths.add(0);
    indicesParent.add(-1);
    angles.add(0.0);

    // tmp vars for running in while loop
    int index = 0;
    float angleOffset = 0, oldAngle = 0;

    while (items.size() > index) {
      RadialLayerItem item = (RadialLayerItem) items.get(index);
      int depth = (Integer) depths.get(index); // tricky: type cast with (int) doesn't work
      int indexToParent = (Integer) indicesParent.get(index);
      float angle = (Float) angles.get(index);

      //if there is an angle change (= entering a new directory) reset angleOffset 
      if (oldAngle != angle) angleOffset = 0.0;

      // is current node a directory?
      // yes -> push all children to the end of the items
      // if (item.file.isDirectory()) {
      if (item.layerCount > 0) {      
        for (int ii = 0; ii < item.childCount; ii++) {
          items.add(item.children[ii]);
          depths.add(depth+1);
          indicesParent.add(index);
          angles.add(angle+angleOffset);    
        }
      }

//      sunburstItems.add(new SunburstItem(index, indexToParent, item.childCount, depth, 
//      item.getFileSize(), getNotModifiedSince(item.file), 
//      item.file, (angle+angleOffset)%TWO_PI, item.getFileSize()*anglePerMegabyte, 
//      item.folderMinFilesize, item.folderMaxFilesize));

      float originAngle = 0; // random(0, TWO_PI);
      float length2 = PI; // random(0, TWO_PI);
      
      if (index == 0) {
        originAngle = 0;
        length2 = PI;
      } else if (index == 0) {
        originAngle = 0;
        length2 = HALF_PI;
      } else if (index == 0) {
        originAngle = 0;
        length2 = QUARTER_PI;
      }
      print("index = "); println(index);
      print("originAngle = "); println(originAngle);
      print("length2 = "); println(length2);
      sunburstItems.add(new SunburstItem(index, indexToParent, item.childCount, depth, originAngle, length2));

//      angleOffset += item.getFileSize() * anglePerMegabyte;
      index++;
      oldAngle = angle;
    }

    println(index+" SunburstItems");
    // convert the arraylist to a normal array
    return (SunburstItem[]) sunburstItems.toArray(new SunburstItem[sunburstItems.size()]);
  }


}


