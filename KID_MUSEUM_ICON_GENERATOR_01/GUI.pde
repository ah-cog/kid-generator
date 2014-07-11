void setupGUI() {
  color activeColor = color(0,130,164);
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorLabel(color(50));
  controlP5.setColorValue(color(255));

  ControlGroup ctrl = controlP5.addGroup("menu",15,25,35);
  ctrl.setColorLabel(color(255));
  ctrl.close();

  sliders = new Slider[10];
  ranges = new Range[10];
  toggles = new Toggle[10];

  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  int ri = 0;
  int ti = 0;
  int posY = 0;

  sliders[si++] = controlP5.addSlider("layerOneAngle",0,TWO_PI,left,top+posY+0,len,15);
  sliders[si++] = controlP5.addSlider("layerOneLength",0,TWO_PI,left,top+posY+20,len,15);
  sliders[si++] = controlP5.addSlider("layerTwoAngle",0,TWO_PI,left,top+posY+40,len,15);
  sliders[si++] = controlP5.addSlider("layerTwoLength",0,TWO_PI,left,top+posY+60,len,15);
  sliders[si++] = controlP5.addSlider("layerThreeAngle",0,TWO_PI,left,top+posY+80,len,15);
  sliders[si++] = controlP5.addSlider("layerThreeLength",0,TWO_PI,left,top+posY+100,len,15);
  sliders[si++] = controlP5.addSlider("layerOffset",0,TWO_PI,left,top+posY+120,len,15);
  posY += 50;

//  toggles[ti] = controlP5.addToggle("showBackground",showBackground,left+0,top+posY,15,15);
//  toggles[ti++].setLabel("show background");


  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].captionLabel().toUpperCase(true);
    sliders[i].captionLabel().style().padding(4,3,3,3);
    sliders[i].captionLabel().style().marginTop = -4;
    sliders[i].captionLabel().style().marginLeft = 0;
    sliders[i].captionLabel().style().marginRight = -14;
    sliders[i].captionLabel().setColorBackground(0x99ffffff);
  }

  for (int i = 0; i < ri; i++) {
    ranges[i].setGroup(ctrl);
    ranges[i].setId(i);
    ranges[i].captionLabel().toUpperCase(true);
    ranges[i].captionLabel().style().padding(4,3,3,3);
    ranges[i].captionLabel().style().marginTop = -4;
    ranges[i].captionLabel().setColorBackground(0x99ffffff);
  }
  for (int i = 0; i < ti; i++) {
    toggles[i].setGroup(ctrl);
    toggles[i].setColorLabel(color(50));
    toggles[i].captionLabel().style().padding(4,3,3,3);
    toggles[i].captionLabel().style().marginTop = -20;
    toggles[i].captionLabel().style().marginLeft = 18;
    toggles[i].captionLabel().style().marginRight = 5;
    toggles[i].captionLabel().setColorBackground(0x99ffffff);
  }
}

void drawGUI(){
  controlP5.show(); 
  controlP5.draw();
}


// called on every change of the gui
void controlEvent(ControlEvent theControlEvent) {
  //println("got a control event from controller with id "+theControlEvent.controller().id());
//  if(theControlEvent.controller().name().equals("file hue range")) {
//    float[] f = theControlEvent.controller().arrayValue();
//    hueStart = f[0];
//    hueEnd = f[1];
//  }
//  if(theControlEvent.controller().name().equals("file saturation range")) {
//    float[] f = theControlEvent.controller().arrayValue();
//    saturationStart = f[0];
//    saturationEnd = f[1];
//  }
//  if(theControlEvent.controller().name().equals("file brightness range")) {
//    float[] f = theControlEvent.controller().arrayValue();
//    brightnessStart = f[0];
//    brightnessEnd = f[1];
//  }
//  if(theControlEvent.controller().name().equals("folder brightness range")) {
//    float[] f = theControlEvent.controller().arrayValue();
//    folderBrightnessStart = f[0];
//    folderBrightnessEnd = f[1];
//  }
//  if(theControlEvent.controller().name().equals("folder stroke brightness range")) {
//    float[] f = theControlEvent.controller().arrayValue();
//    folderStrokeBrightnessStart = f[0];
//    folderStrokeBrightnessEnd = f[1];
//  }
//  if(theControlEvent.controller().name().equals("stroke weight range")) {
//    float[] f = theControlEvent.controller().arrayValue();
//    strokeWeightStart = f[0];
//    strokeWeightEnd = f[1];
//  }

  initialize = true;
}

















