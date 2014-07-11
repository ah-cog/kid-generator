class RadialLayerItem {
//  RadialLayerItem[] children;

  int childCount = 1;
  int layerCount = 3;
  
  RadialLayerItem parent;
  RadialLayerItem child;
  
  float angle = 0.0;
  float distance = 0.0;
  float arcScale = 1.0;
  
  // TODO: color myColor = color(h,s,b);

  // ------ constructor ------
  RadialLayerItem(RadialLayerItem parent) {
    
    // Determine the current layer of the element
    if (parent != null) {
      this.layerCount = parent.layerCount + 1;
      this.parent = parent;
    } else {
      this.layerCount = 1;
    }
    
    // There is no child, so set to "null", which we use to indicate "no child".
    this.child = null;
    
    // Parameterize the layer element
    if (this.layerCount == 1) {
      this.angle = 0.6 * PI;
      this.distance = TWO_PI - 0.2 * PI;
    } else if (this.layerCount == 2) {
      this.angle = 0.9 * PI;
      this.distance = TWO_PI - 0.8 * PI;
    } else if (this.layerCount == 3) {
      this.angle = 0.9 * HALF_PI;
      this.distance = 0.7 * TWO_PI;
    }

//    if (this.layerCount > 0) {
//
//        children = new RadialLayerItem[layerCount];
//        
//        RadialLayerItem child = new RadialLayerItem(this.layerCount - 1);
//        children[0] = child; // children[childCount] = child;
//    }
  }
  
  // Breadth First
  SunburstItem createSunburstItem() {
    print("createRadialSunburstItem -> ");

    // temp array for pushing and saving all elements in "breadth first search" style
//    ArrayList items = new ArrayList();  
//    ArrayList depths = new ArrayList(); 
//    ArrayList indicesParent = new ArrayList(); 
//    ArrayList sunburstItems = new ArrayList();
//    ArrayList angles = new ArrayList(); 
//
//    // add first elements and startingpoint
//    items.add(this);
//    depths.add(0);
//    indicesParent.add(-1);
//    angles.add(0.0);
    
    
    
    //sunburstItems.add(new SunburstItem(this.layerCount, indexToParent, item.childCount, depth, item.angle, item.distance));
//    sunburstItems.add(new SunburstItem(1, this.angle, this.distance));
    return (new SunburstItem(this.layerCount, this.angle, this.distance));
    
    
    
//
//    // tmp vars for running in while loop
//    int index = 0;
//    float angleOffset = 0, oldAngle = 0;
//
//    while (items.size() > index) {
//      RadialLayerItem item = (RadialLayerItem) items.get(index);
//      int depth = (Integer) depths.get(index); // tricky: type cast with (int) doesn't work
//      int indexToParent = (Integer) indicesParent.get(index);
//      float angle = (Float) angles.get(index);
//
//      //if there is an angle change (= entering a new directory) reset angleOffset 
//      if (oldAngle != angle) angleOffset = 0.0;
//
//      // is current node a directory?
//      // yes -> push all children to the end of the items
//      // if (item.file.isDirectory()) {
////      if (item.layerCount > 0) {      
////        for (int ii = 0; ii < item.childCount; ii++) {
////          items.add(item.children[ii]);
////          depths.add(depth+1);
////          indicesParent.add(index);
////          angles.add(angle+angleOffset);    
////        }
////      }
//
//      // Create sunburst diagram element
//      sunburstItems.add(new SunburstItem(index, indexToParent, item.childCount, depth, item.angle, item.distance));
//
////      angleOffset += item.getFileSize() * anglePerMegabyte;
//      index++;
//      oldAngle = angle;
//    }

//    println(index+" SunburstItems");
    // convert the arraylist to a normal array
//    return (SunburstItem[]) sunburstItems.toArray(new SunburstItem[sunburstItems.size()]);
  }
  
//  // Breadth First
//  SunburstItem[] createSunburstItems() {
//    print("createRadialSunburstItems -> ");
//
////    float megabytes = this.getFileSize();
////    float anglePerMegabyte = TWO_PI/megabytes;
//
//    // temp array for pushing and saving all elements in "breadth first search" style
//    ArrayList items = new ArrayList();  
//    ArrayList depths = new ArrayList(); 
//    ArrayList indicesParent = new ArrayList(); 
//    ArrayList sunburstItems = new ArrayList();
//    ArrayList angles = new ArrayList(); 
//
//    // add first elements and startingpoint
//    items.add(this);
//    depths.add(0);
//    indicesParent.add(-1);
//    angles.add(0.0);
//
//    // tmp vars for running in while loop
//    int index = 0;
//    float angleOffset = 0, oldAngle = 0;
//
//    while (items.size() > index) {
//      RadialLayerItem item = (RadialLayerItem) items.get(index);
//      int depth = (Integer) depths.get(index); // tricky: type cast with (int) doesn't work
//      int indexToParent = (Integer) indicesParent.get(index);
//      float angle = (Float) angles.get(index);
//
//      //if there is an angle change (= entering a new directory) reset angleOffset 
//      if (oldAngle != angle) angleOffset = 0.0;
//
//      // is current node a directory?
//      // yes -> push all children to the end of the items
//      // if (item.file.isDirectory()) {
////      if (item.layerCount > 0) {      
////        for (int ii = 0; ii < item.childCount; ii++) {
////          items.add(item.children[ii]);
////          depths.add(depth+1);
////          indicesParent.add(index);
////          angles.add(angle+angleOffset);    
////        }
////      }
//
//      // Create sunburst diagram element
//      sunburstItems.add(new SunburstItem(index, indexToParent, item.childCount, depth, item.angle, item.distance));
//
////      angleOffset += item.getFileSize() * anglePerMegabyte;
//      index++;
//      oldAngle = angle;
//    }
//
//    println(index+" SunburstItems");
//    // convert the arraylist to a normal array
//    return (SunburstItem[]) sunburstItems.toArray(new SunburstItem[sunburstItems.size()]);
//  }


}


