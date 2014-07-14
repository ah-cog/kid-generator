class SunburstItem {

  // relations
  int depth;
  
  // arc and lines drawing vars
  float angleStart, angleCenter, angleEnd;
  float extension;
  float radius; 
  float x,y;
  float arcLength;
  float arcWidth = 80;
  
  boolean enableBackground = false;
  color backgroundColor;
  float backgroundSize = 900;
  
  color strokeColor;
  color negativeStrokeColor;
  
  boolean enableNegativeSpaceColor = false;
  float negativeArcPadding = 0.01 * PI;

  // ------ constructor ------
  SunburstItem (int theDepth, float theAngle, float theExtension) {

    this.depth = theDepth;

    // sunburst angles and extension
    this.angleStart = theAngle;
    this.extension = theExtension;
    this.angleCenter = theAngle + theExtension/2;
    this.angleEnd = theAngle + theExtension;
    
    this.backgroundColor = color(random(0, 360), 100, 100, 100);
    
    this.strokeColor = color(360, 100, 100);
    this.negativeStrokeColor = color(180, 100, 100);
  }
  
  void setColor(color strokeColor) {
    this.strokeColor = strokeColor;
  }
  
  void setNegativeColor(color negativeStrokeColor) {
    this.negativeStrokeColor = negativeStrokeColor;
  }
  
  void setArcWidth(float arcWidth) {
    this.arcWidth = arcWidth;
  }

  // ------ draw functions ------
  void draw() {
    
    float arcScale = 1.0;
    
    float arcRadius;
//    float arcWidth = 100;
    
    if (this.depth > 0 ) {
      
      println("arcWidth =", arcWidth);
      println("arcScale =", arcScale);

      strokeWeight(arcWidth * arcScale); // strokeWeight(depthWeight * theFileScale); 
      // arcRadius = radius + depthWeight*theFileScale / 2;
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
      
      stroke(this.strokeColor); // stroke(arcStrokeColor);
      noFill(); // fill(arcFillColor);
      
      println("angleStart =", angleStart);
      println("angleEnd =", angleEnd);
      println("arcLength =", arcLength);
      
//      angleEnd = (depth / 3.0) * PI;
      
      //arc(0,0, arcRadius,arcRadius, angleStart, angleEnd);
      arcWrap(0, 0, arcRadius, arcRadius, angleStart, angleEnd); // normaly arc should work
      
      // Draw background
      if (this.enableBackground) {
        pushMatrix();
        noStroke();
        fill(this.backgroundColor);
        rect(-1 * (this.backgroundSize / 2), -1 * (this.backgroundSize / 2), this.backgroundSize, this.backgroundSize);
        popMatrix();
      }
      
      if (this.enableNegativeSpaceColor) {
        stroke(this.negativeStrokeColor); // stroke(arcStrokeColor);
        float newEndAngle = angleStart;
        float newStartAngle = angleEnd % PI;
//        while (newStartAngle > newEndAngle) {
//          newStartAngle = newStartAngle % PI;
//        }
        arcWrap(0, 0, arcRadius, arcRadius, newStartAngle - this.negativeArcPadding, newEndAngle + this.negativeArcPadding); // normaly arc should work
        
        // Fill in the "negative circle" at the center
        fill(this.negativeStrokeColor);
        ellipse(0, 0, arcWidth, arcWidth);
        noFill();
      }
    } else {
      // Draw the "second arm" arc segment
      
      println("arcWidth =", arcWidth);
      println("arcScale =", arcScale);

      strokeWeight(arcWidth * arcScale); // strokeWeight(depthWeight * theFileScale); 
      // arcRadius = radius + depthWeight*theFileScale / 2;
      //radius = armArcSegmentRadius; // 150; // calcAreaRadius(depth, depthMax);
      x  = cos(angleCenter) * radius;
      y  = sin(angleCenter) * radius;
      float startX  = cos(angleStart) * radius;
      float startY  = sin(angleStart) * radius;  
      float endX  = cos(angleEnd) * radius;
      float endY  = sin(angleEnd) * radius; 
      arcLength = dist(startX, startY, endX, endY);
      arcRadius = radius + arcWidth; // *theFileScale/2;
      
      println("radius =", radius);
      println("arcRadius =", arcRadius);
      
      //stroke(this.negativeStrokeColor); // stroke(arcStrokeColor);
      stroke(color(0, 0, 100));
      noFill(); // fill(arcFillColor);
      
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
      strokeWeight(arcLength);
      pushMatrix();
      rotate(angleCenter);
      translate(radius,0);
      line(0,0, (theW-radius)*2,0);
      popMatrix();
    }
  }
}




























