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
  
  boolean enableStroke = false;
  float strokeWeight = 1.0; // 1.0
  color strokeColor;
  color negativeStrokeColor;
  
  boolean enableNegativeSpaceColor = false;
  float negativeArcPadding = 0.01 * PI;
  
  boolean enablePartialOutline = true;
  boolean drawDistalOutline = true;
  boolean bisectDistalOutline = true;
  boolean drawOuterArc = false;
  boolean drawProximalBoundaryLine = false;

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
      
      stroke(this.strokeColor); // stroke(arcStrokeColor);
      noFill(); // fill(arcFillColor);
      
//      println("arcWidth =", arcWidth);
//      println("arcScale =", arcScale);
//      println("radius =", radius);
//      println("arcRadius =", arcRadius);
//      println("angleStart =", angleStart);
//      println("angleEnd =", angleEnd);
//      println("arcLength =", arcLength);
      
//      angleEnd = (depth / 3.0) * PI;
      
      // NOTE: This is the original drawing method used. Parameterize for "final" generator?
      // arcWrap(0, 0, arcRadius, arcRadius, angleStart, angleEnd); // normaly arc should work
      
      // Manually draw the arc geometry
      if (enableStroke) {
        stroke(color(0, 0, 0));
        strokeWeight(this.strokeWeight); // 1.0
      } else {
        noStroke();
      }
      fill(color(240, 100, 100));
//      float x1 = (arcRadius - (arcWidth / 2)) * cos(angleStart);
//      float y1 = (arcRadius - (arcWidth / 2)) * sin(angleStart);
//      float x2 = (arcRadius + (arcWidth / 2)) * cos(angleStart);
//      float y2 = (arcRadius + (arcWidth / 2)) * sin(angleStart);
//      arc(0, 0, arcRadius - (arcWidth / 2), arcRadius - (arcWidth / 2), angleStart, angleEnd); // draw inner arc segment
//      line(x1, y1, x2, y2); // line(x1, y1, x2, y2);
//      float x3 = (arcRadius - (arcWidth / 2)) * cos(angleEnd);
//      float y3 = (arcRadius - (arcWidth / 2)) * sin(angleEnd);
//      float x4 = (arcRadius + (arcWidth / 2)) * cos(angleEnd);
//      float y4 = (arcRadius + (arcWidth / 2)) * sin(angleEnd);
//      line(x3, y3, x4, y4); // line(x1, y1, x2, y2);
//      arc(0, 0, arcRadius + (arcWidth / 2), arcRadius + (arcWidth / 2), angleStart, angleEnd); // draw outer arc segment
      
//      smooth();
//      fill(206,76,52);
      float angleArcStep = PI / 180 * 10;

      float degreesInCircle = 360;
      float beginAngleInDegrees = (angleStart / TWO_PI) * degreesInCircle;
      float endAngleInDegrees = (angleEnd / TWO_PI) * degreesInCircle;
      float radiansPerDegree = TWO_PI / degreesInCircle;
      int angleArcStepInDegrees = int((angleArcStep / TWO_PI) * degreesInCircle);
      
      // Draw the layer's inner arc
      h.beginShape();
      for(int i = int(beginAngleInDegrees); i < int(endAngleInDegrees); i += angleArcStepInDegrees) {
        float angleInRadians = i * radiansPerDegree;
        float xx = (arcRadius - (arcWidth / 2)) * cos(angleInRadians);
        float yy = (arcRadius - (arcWidth / 2)) * sin(angleInRadians);
        h.vertex(xx, yy);
//        line(x1, y1, x2, y2);
      }
//      h.endShape();
      
      // Draw arc boundary line connecting inner arc to outer arc
      // TODO: Optionally, draw a "rounded corner" rather than a "sharp corner". Repeat for other layer bounding line.
      float xx1, yy1;
      float xx2, yy2;
      xx1 = (arcRadius - (arcWidth / 2)) * cos(angleEnd);
      yy1 = (arcRadius - (arcWidth / 2)) * sin(angleEnd);
      xx2 = (arcRadius + (arcWidth / 2)) * cos(angleEnd);
      yy2 = (arcRadius + (arcWidth / 2)) * sin(angleEnd);
      h.line(xx1, yy1, xx2, yy2);
      
      // Draw the layer's outer arc
//      h.beginShape();
      for(int i = int(endAngleInDegrees); i >= int(beginAngleInDegrees); i -= angleArcStepInDegrees) {
        float angleInRadians = i * radiansPerDegree;
        float xx = (arcRadius + (arcWidth / 2)) * cos(angleInRadians);
        float yy = (arcRadius + (arcWidth / 2)) * sin(angleInRadians);
        h.vertex(xx, yy);
//        line(x1, y1, x2, y2);
      }
      
      xx1 = (arcRadius - (arcWidth / 2)) * cos(angleStart);
      yy1 = (arcRadius - (arcWidth / 2)) * sin(angleStart);
      xx2 = (arcRadius + (arcWidth / 2)) * cos(angleStart);
      yy2 = (arcRadius + (arcWidth / 2)) * sin(angleStart);
      h.line(xx1, yy1, xx2, yy2);
      
      h.endShape();
      
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
        // NOTE: This is the original drawing method used. Parameterize for "final" generator?
        // arcWrap(0, 0, arcRadius, arcRadius, newStartAngle - this.negativeArcPadding, newEndAngle + this.negativeArcPadding); // normaly arc should work
        
        // Fill in the "negative circle" at the center
        fill(this.negativeStrokeColor);
        ellipse(0, 0, arcWidth, arcWidth);
        noFill();
      }
    } else {
      // Draw the "second arm" arc segment
      
//      println("arcWidth =", arcWidth);
//      println("arcScale =", arcScale);

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
      
//      println("radius =", radius);
//      println("arcRadius =", arcRadius);
      
      //stroke(this.negativeStrokeColor); // stroke(arcStrokeColor);
      if (enableStroke) {
        stroke(color(0, 0, 0));
        if (enablePartialOutline) {
          noStroke();
        } else {
          strokeWeight(1.0);
        }
      } else {
        noStroke();
      }
      fill(color(0, 0, 100)); // fill(color(240, 100, 100));
      
//      println("angleStart =", angleStart);
//      println("angleEnd =", angleEnd);
//      println("arcLength =", arcLength);
      
//      angleEnd = (depth / 3.0) * PI;
      
      //arcWrap(0, 0, arcRadius, arcRadius, angleStart, angleEnd); // normaly arc should work
      
      float angleArcStep = PI / 180 * 5;

      float degreesInCircle = 360;
      float beginAngleInDegrees = (angleStart / TWO_PI) * degreesInCircle;
      float endAngleInDegrees = (angleEnd / TWO_PI) * degreesInCircle;
      float radiansPerDegree = TWO_PI / degreesInCircle;
      int angleArcStepInDegrees = int((angleArcStep / TWO_PI) * degreesInCircle);
      
      // Draw the layer's inner arc
      h.beginShape();
      for(int i = int(beginAngleInDegrees); i < int(endAngleInDegrees); i += angleArcStepInDegrees) {
        float angleInRadians = i * radiansPerDegree;
        float xx = (arcRadius - (arcWidth / 2)) * cos(angleInRadians);
        float yy = (arcRadius - (arcWidth / 2)) * sin(angleInRadians);
        h.vertex(xx, yy);
//        line(x1, y1, x2, y2);
      }
//      h.endShape();
      
      // Draw arc boundary line connecting inner arc to outer arc
      // TODO: Optionally, draw a "rounded corner" rather than a "sharp corner". Repeat for other layer bounding line.
      float xx1, yy1;
      float xx2, yy2;
      xx1 = (arcRadius - (arcWidth / 2)) * cos(angleEnd);
      yy1 = (arcRadius - (arcWidth / 2)) * sin(angleEnd);
      xx2 = (arcRadius + (arcWidth / 2)) * cos(angleEnd);
      yy2 = (arcRadius + (arcWidth / 2)) * sin(angleEnd);
      h.line(xx1, yy1, xx2, yy2);
      
      // Draw the layer's outer arc
//      h.beginShape();
      for(int i = int(endAngleInDegrees); i >= int(beginAngleInDegrees); i -= angleArcStepInDegrees) {
        float angleInRadians = i * radiansPerDegree;
        float xx = (arcRadius + (arcWidth / 2)) * cos(angleInRadians);
        float yy = (arcRadius + (arcWidth / 2)) * sin(angleInRadians);
        h.vertex(xx, yy);
//        line(x1, y1, x2, y2);
      }
      
      xx1 = (arcRadius - (arcWidth / 2)) * cos(angleStart);
      yy1 = (arcRadius - (arcWidth / 2)) * sin(angleStart);
      xx2 = (arcRadius + (arcWidth / 2)) * cos(angleStart);
      yy2 = (arcRadius + (arcWidth / 2)) * sin(angleStart);
      h.line(xx1, yy1, xx2, yy2);
      
      h.endShape();
      
      
      if (enablePartialOutline) {
//        float angleArcStep = PI / 180 * 5;
//  
//        float degreesInCircle = 360;
//        float beginAngleInDegrees = (angleStart / TWO_PI) * degreesInCircle;
//        float endAngleInDegrees = (angleEnd / TWO_PI) * degreesInCircle;
//        float radiansPerDegree = TWO_PI / degreesInCircle;
//        int angleArcStepInDegrees = int((angleArcStep / TWO_PI) * degreesInCircle);

//        stroke(color(0, 0, 0));
//        strokeWeight(1.0);
        noFill();
        
        // Draw the layer's inner arc
        h.beginShape();
        for(int i = int(beginAngleInDegrees); i < int(endAngleInDegrees); i += angleArcStepInDegrees) {
          float angleInRadians = i * radiansPerDegree;
          float xx = (arcRadius - (arcWidth / 2)) * cos(angleInRadians);
          float yy = (arcRadius - (arcWidth / 2)) * sin(angleInRadians);
          h.vertex(xx, yy);
  //        line(x1, y1, x2, y2);
        }
  //      h.endShape();
        
        // Draw arc boundary line connecting inner arc to outer arc
        // TODO: Optionally, draw a "rounded corner" rather than a "sharp corner". Repeat for other layer bounding line.
//        float xx1, yy1;
//        float xx2, yy2;
        xx1 = (arcRadius - (arcWidth / 2)) * cos(angleEnd);
        yy1 = (arcRadius - (arcWidth / 2)) * sin(angleEnd);
        if (bisectDistalOutline) {
          xx2 = (arcRadius) * cos(angleEnd);
          yy2 = (arcRadius) * sin(angleEnd);
        } else {
          xx2 = (arcRadius + (arcWidth / 2)) * cos(angleEnd);
          yy2 = (arcRadius + (arcWidth / 2)) * sin(angleEnd);
        }
        h.line(xx1, yy1, xx2, yy2);
        
        // Draw the layer's outer arc
        if (drawOuterArc) {
          for(int i = int(endAngleInDegrees); i >= int(beginAngleInDegrees); i -= angleArcStepInDegrees) {
            float angleInRadians = i * radiansPerDegree;
            float xx = (arcRadius + (arcWidth / 2)) * cos(angleInRadians);
            float yy = (arcRadius + (arcWidth / 2)) * sin(angleInRadians);
            h.vertex(xx, yy);
          }
        }
        
        if (drawProximalBoundaryLine) {
          xx1 = (arcRadius - (arcWidth / 2)) * cos(angleStart);
          yy1 = (arcRadius - (arcWidth / 2)) * sin(angleStart);
          xx2 = (arcRadius + (arcWidth / 2)) * cos(angleStart);
          yy2 = (arcRadius + (arcWidth / 2)) * sin(angleStart);
          h.line(xx1, yy1, xx2, yy2);
        }
        
        h.endShape();
      }
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
