class RadialLayerItem {

  int layerNumber = 3;
  
  RadialLayerItem parent;
  RadialLayerItem child;
  
  float angle = 0.0;
  float distance = 0.0;
  float arcScale = 1.0;

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
      this.angle = random(0.5 * PI, 0.7 * PI); // 0.6 * PI
      this.distance = random(TWO_PI - 0.3 * PI, TWO_PI - 0.1 * PI); // TWO_PI - 0.2 * PI
    } else if (this.layerNumber == 2) {
      this.angle = random(0.8 * PI, 1.0 * PI); // 0.9 * PI
      this.distance = random(TWO_PI - 0.9 * PI, TWO_PI - 0.7 * PI); // TWO_PI - 0.8 * PI
    } else if (this.layerNumber == 3) {
      this.angle = random(0.8 * HALF_PI, 1.0 * HALF_PI); // 0.9 * HALF_PI
      this.distance = random(0.8 * TWO_PI, 0.6 * TWO_PI); // 0.7 * TWO_PI
    }
  }
  
  // Breadth First
  SunburstItem generateSunburstItem() {
    return (new SunburstItem(this.layerNumber, this.angle, this.distance));
  }

}


