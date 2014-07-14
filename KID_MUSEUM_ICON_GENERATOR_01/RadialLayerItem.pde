class RadialLayerItem {

  int layerNumber = 1;
  
  RadialLayerItem parent;
  RadialLayerItem child;
  
  float angle = 0.0;
  float distance = 0.0;
  float arcScale = 1.0;
  
  color strokeColor;
  color negativeStrokeColor;
  
  float arcWidth;
  
  void setColor(color strokeColor) {
    this.strokeColor = strokeColor;
  }
  
  void setNegativeColor(color negativeStrokeColor) {
    this.negativeStrokeColor = negativeStrokeColor;
  }
  
  void setArcWidth(float arcWidth) {
    this.arcWidth = arcWidth;
  }

  // ------ constructor ------
  RadialLayerItem(RadialLayerItem parent) {
    
    // Determine the current layer of the element
    if (parent != null) {
      this.layerNumber = parent.layerNumber + 1;
      this.parent = parent;
      this.parent.child = this;
    } else {
      this.layerNumber = 1;
    }
    
    // There is no child, so set to "null", which we use to indicate "no child".
    this.child = null;
    
    // Parameterize the layer element
    if (this.layerNumber == 1) {
      this.angle = random(0.4 * PI, 0.8 * PI); // 0.6 * PI
      this.distance = random(TWO_PI - 0.4 * PI, TWO_PI - 0.1 * PI); // TWO_PI - 0.2 * PI
    } else if (this.layerNumber == 2) {
      this.angle = random(0.7 * PI, 1.1 * PI); // 0.9 * PI
      this.distance = random(TWO_PI - 1.1 * PI, TWO_PI - 0.5 * PI); // TWO_PI - 0.8 * PI
    } else if (this.layerNumber == 3) {
      this.angle = random(0.7 * HALF_PI, 1.1 * HALF_PI); // 0.9 * HALF_PI
      this.distance = random(0.5 * TWO_PI, 0.99 * TWO_PI); // 0.7 * TWO_PI
    }
    
    this.strokeColor = color(360, 100, 100);
    this.negativeStrokeColor = color(180, 100, 100);
  }
  
  // Breadth First
  SunburstItem generateSunburstItem() {
    SunburstItem sunburstItem = new SunburstItem(this.layerNumber, this.angle, this.distance);
    sunburstItem.setColor(this.strokeColor);
    sunburstItem.setNegativeColor(this.negativeStrokeColor);
    sunburstItem.setArcWidth(this.arcWidth);
    return sunburstItem;
  }

}


