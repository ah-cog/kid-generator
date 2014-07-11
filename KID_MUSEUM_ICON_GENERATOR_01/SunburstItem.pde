class SunburstItem {
//  File file;

  // relations
  int depth; 
//  int index;
//  int indexToParent;
  int childCount;

  // arc and lines drawing vars
  float angleStart, angleCenter, angleEnd;
  float extension;
  float radius; 
//  float depthWeight; // stroke weight of the arc
  float x,y;
  float arcLength;

  // ------ constructor ------
  SunburstItem (int theDepth, float theAngle, float theExtension) {

    this.depth = theDepth;

    // sunburst angles and extension
    this.angleStart = theAngle;
    this.extension = theExtension;
    this.angleCenter = theAngle + theExtension/2;
    this.angleEnd = theAngle + theExtension;
  }



//  // ------ update function, called only when the input files are changed ------
//  void update(int theMappingMode) {
////    if (indexToParent > -1) {
//      radius = calcAreaRadius(depth,depthMax);
//      depthWeight = calcEqualAreaRadius(depth+1,depthMax) - radius;
//      x  = cos(angleCenter) * radius;
//      y  = sin(angleCenter) * radius;
//
//      // chord
//      float startX  = cos(angleStart) * radius;
//      float startY  = sin(angleStart) * radius;  
//      float endX  = cos(angleEnd) * radius;
//      float endY  = sin(angleEnd) * radius; 
//      arcLength = dist(startX,startY, endX,endY);
//
//      // color mapings
//      float percent = 0;
//      switch(theMappingMode) {
//      case 1: 
//        percent = norm(lastModified, lastModifiedOldest, lastModifiedYoungest);
//        break;
//      case 2: 
//        percent = norm(fileSize, fileSizeMin, fileSizeMax);
//        break;
//      case 3: 
//        percent = norm(fileSize, folderMinFilesize, folderMaxFilesize);
//        break;
//      }
//
//      // colors for files and folders
////      if (isDir) { 
////        float bright = 0;
////        bright = lerp(folderBrightnessStart,folderBrightnessEnd,percent);
////        col = color(0,0,bright);
////        bright = lerp(folderStrokeBrightnessStart,folderStrokeBrightnessEnd,percent);
////        lineCol = color(0,0,bright);
////      }
////      else {
//        color from = color(hueStart, saturationStart, brightnessStart);
//        color to = color(hueEnd, saturationEnd, brightnessEnd);
//        col = lerpColor(from, to, percent);
//        lineCol = col;
////      }
//
//      // calc stroke weight for relations line
//      lineWeight = map(depth,depthMax,1,strokeWeightStart,strokeWeightEnd);
//      if (arcLength < lineWeight) lineWeight = arcLength*0.93;
//
//      // calc bezier controlpoints
//      c1X  = cos(angleCenter) * calcEqualAreaRadius(depth-1, depthMax);
//      c1Y  = sin(angleCenter) * calcEqualAreaRadius(depth-1, depthMax);
//
////      c2X  = cos(sunburst[indexToParent].angleCenter); 
//      c2X *= calcEqualAreaRadius(depth, depthMax);
//
////      c2Y  = sin(sunburst[indexToParent].angleCenter); 
//      c2Y *= calcEqualAreaRadius(depth, depthMax);
////    }
//  }


  // ------ draw functions ------
  void drawArc (float arcScale) {
    
    float arcRadius;
    float arcWidth = 80;
    
    if (depth > 0 ) {
      
      println("arcWidth =", arcWidth);
      println("arcScale =", arcScale);

      strokeWeight(arcWidth * arcScale); // strokeWeight(depthWeight * theFileScale); 
      // arcRadius = radius + depthWeight*theFileScale/2;
      radius = calcAreaRadius(depth, depthMax);
      x  = cos(angleCenter) * radius;
      y  = sin(angleCenter) * radius;
      float startX  = cos(angleStart) * radius;
      float startY  = sin(angleStart) * radius;  
      float endX  = cos(angleEnd) * radius;
      float endY  = sin(angleEnd) * radius; 
      arcLength = dist(startX,startY, endX,endY);
      arcRadius = radius + arcWidth; // *theFileScale/2;
      println("radius =", radius);
      println("arcRadius =", arcRadius);
      
      stroke(arcStrokeColor); 
      fill(arcFillColor);
      
      println("angleStart =", angleStart);
      println("angleEnd =", angleEnd);
      println("arcLength =", arcLength);
      
//      angleEnd = (depth / 3.0) * PI;
      
      //arc(0,0, arcRadius,arcRadius, angleStart, angleEnd);
      arcWrap(0, 0, arcRadius, arcRadius, angleStart, angleEnd); // normaly arc should work
    }
  }

  // fix for arc
  // it seems that the arc functions has a problem with very tiny angles ... 
  // arcWrap is a quick hack to get rid of this problem
  void arcWrap (float theX, float theY, float theW, float theH, float theA1, float theA2) {
    if (arcLength > 2.5) {
      arc(theX,theY, theW,theH, theA1, theA2);
      // TODO: (Possibly) Replace with custom drawing function (e.g., Bezier curve estimation)
    } else {
//      strokeWeight(arcLength);
//      pushMatrix();
//      rotate(angleCenter);
//      translate(radius,0);
//      line(0,0, (theW-radius)*2,0);
//      popMatrix();
    }
  }

//  void drawRect(float theFolderScale, float theFileScale) {
//    float rectWidth;
//    if (depth > 0 ) {
//      if (isDir) rectWidth = radius + depthWeight*theFolderScale/2;  
//      else rectWidth = radius + depthWeight*theFileScale/2;  
//
//      stroke(col);     
//      strokeWeight(arcLength);
//      pushMatrix();
//      rotate(angleCenter);
//      translate(radius,0);
//      line(0,0, (rectWidth-radius)*2,0);
//      popMatrix();
//    }
//  }


  void drawDot() {
    if (depth > 0) {
      float diameter = dotSize;
      if (arcLength < diameter) diameter = arcLength*0.95;
      if (depth == 0) diameter = 3;
      fill(0,0,dotBrightness);
      noStroke();
      ellipse(x,y,diameter,diameter);
      noFill(); 
    }
  }


//  void drawRelationLine() {
//    if (depth > 0) {
//      stroke(lineCol); 
//      strokeWeight(lineWeight);
//      line(x,y, sunburst[indexToParent].x,sunburst[indexToParent].y);
//    }
//  }


//  void drawRelationBezier() {
//    if (depth > 1) {
//      stroke(lineCol); 
//      strokeWeight(lineWeight);
//      bezier(x,y, c1X,c1Y, c2X,c2Y, sunburst[indexToParent].x,sunburst[indexToParent].y);
//    }
//  }

}




























