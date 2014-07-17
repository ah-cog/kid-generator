class RadialLayerItem {

  int layerNumber = 1;
  
  RadialLayerItem parent;
  RadialLayerItem child;
  
  float xOffset, yOffset;
  float angle = 0.0;
  float distance = 0.0;
  float arcScale = 1.0;
  
  color fillColor;
  color strokeColor;
  color negativeStrokeColor;
  
  float arcWidth;
  
  void setColor(color strokeColor) {
    this.strokeColor = strokeColor;
    this.fillColor = strokeColor;
  }
  
  void setNegativeColor(color negativeStrokeColor) {
    this.negativeStrokeColor = negativeStrokeColor;
  }
  
  void setArcWidth(float arcWidth) {
    this.arcWidth = arcWidth;
  }
  
  void setOffset(float xOffset, float yOffset) {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
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
    
    this.strokeColor = color(255, 255, 255); // color(360, 100, 100);
    this.negativeStrokeColor = color(0, 0, 100);
    
    this.xOffset = 0;
    this.yOffset = 0;
  }
  
  // Breadth First
  SunburstItem generateSunburstItem() {
    SunburstItem sunburstItem = new SunburstItem(this.layerNumber, this.angle, this.distance);
    sunburstItem.setOffset(this.xOffset, this.yOffset);
    println(this.xOffset);
    sunburstItem.setColor(this.strokeColor);
    sunburstItem.setNegativeColor(this.negativeStrokeColor);
    sunburstItem.setArcWidth(this.arcWidth);
    return sunburstItem;
  }

}


