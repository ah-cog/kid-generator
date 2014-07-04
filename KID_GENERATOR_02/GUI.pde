// M_4_4_01_TOOL.pde
// GUI.pde, TileSaver.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

void setupGUI(){
  color activeColor = color(0,130,164);
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorLabel(color(50));
  controlP5.setColorValue(color(255));

  ControlGroup ctrl = controlP5.addGroup("menu",15,25,35);
  ctrl.activateEvent(true);
  ctrl.setColorLabel(color(255));
  ctrl.close();



  sliders = new Slider[30];
  ranges = new Range[30];
  toggles = new Toggle[30];
  bangs = new Bang[30];

  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  int ri = 0;
  int ti = 0;
  int bi = 0;
  int posY = 0;

  bangs[bi] = controlP5.addBang("reset",left,top+posY,30,15);
  bangs[bi++].setLabel("Reset"); 
  bangs[bi] = controlP5.addBang("set1",left+75 ,top+posY,30,15);
  bangs[bi++].setLabel("Set 1"); 
  bangs[bi] = controlP5.addBang("set2",left+140,top+posY,30,15);
  bangs[bi++].setLabel("Set 2"); 
  bangs[bi] = controlP5.addBang("set3",left+205,top+posY,30,15);
  bangs[bi++].setLabel("Set 3"); 
  bangs[bi] = controlP5.addBang("set4",left+270,top+posY,30,15);
  bangs[bi++].setLabel("Set 4"); 
  posY += 30;
  
  sliders[si++] = controlP5.addSlider("xCount",0,maxCount,left,top+posY,len,15);
  sliders[si++] = controlP5.addSlider("yCount",0,maxCount,left,top+posY+20,len,15);
  sliders[si++] = controlP5.addSlider("zCount",0,maxCount,left,top+posY+40,len,15);
  posY += 70;

  sliders[si++] = controlP5.addSlider("gridStepX",1,50,left,top+posY,len,15);
  sliders[si++] = controlP5.addSlider("gridStepY",1,50,left,top+posY+20,len,15);
  sliders[si++] = controlP5.addSlider("gridStepZ",1,50,left,top+posY+40,len,15);
  posY += 70;

  sliders[si++] = controlP5.addSlider("attractorRadius",1,1000,left,top+posY,len,15);
  sliders[si++] = controlP5.addSlider("attractorStrength",0,10,left,top+posY+20,len,15);
  sliders[si++] = controlP5.addSlider("attractorRamp",0.1,3,left,top+posY+40,len,15);
  sliders[si++] = controlP5.addSlider("nodeDamping",0,1,left,top+posY+60,len,15);
  posY += 90;

  toggles[ti] = controlP5.addToggle("invertBackground",invertBackground,left+0,top+posY,15,15);
  toggles[ti++].setLabel("InvertBackground");
  sliders[si++] = controlP5.addSlider("lineWeight",0.2,20,left,top+posY+20,len,15);
  sliders[si++] = controlP5.addSlider("lineAlpha",0,100,left,top+posY+40,len,15);
  toggles[ti] = controlP5.addToggle("drawX",drawX,left+0,top+posY+60,15,15);
  toggles[ti++].setLabel("Draw X"); 
  toggles[ti] = controlP5.addToggle("drawY",drawY,left+100,top+posY+60,15,15);
  toggles[ti++].setLabel("Draw Y"); 
  toggles[ti] = controlP5.addToggle("drawZ",drawZ,left+200,top+posY+60,15,15);
  toggles[ti++].setLabel("Draw Z"); 
  toggles[ti] = controlP5.addToggle("lockX",lockX,left+0,top+posY+80,15,15);
  toggles[ti++].setLabel("Lock X"); 
  toggles[ti] = controlP5.addToggle("lockY",lockY,left+100,top+posY+80,15,15);
  toggles[ti++].setLabel("Lock Y"); 
  toggles[ti] = controlP5.addToggle("lockZ",lockZ,left+200,top+posY+80,15,15);
  toggles[ti++].setLabel("Lock Z"); 
  posY += 110;

  toggles[ti] = controlP5.addToggle("drawLines",drawLines,left+0,top+posY,15,15);
  toggles[ti++].setLabel("Draw Lines");
  toggles[ti] = controlP5.addToggle("drawCurves",drawCurves,left+0,top+posY+20,15,15);
  toggles[ti++].setLabel("Draw Curves"); 
  posY += 50;
  
  // Letters
  toggles[ti] = controlP5.addToggle("solidBackground",solidBackground,left+0,top+posY,15,15);
  toggles[ti++].setLabel("solidBackground");
  sliders[si++] = controlP5.addSlider("letterAttractorRadius",0,100,left,top+posY+20,len,15); // MG added
  sliders[si++] = controlP5.addSlider("letterAttractorStrength",-300,300,left,top+posY+40,len,15); // MG added
  sliders[si++] = controlP5.addSlider("letterAttractorRamp",0.0,1.0,left,top+posY+60,len,15); // MG added
  sliders[si++] = controlP5.addSlider("letterSegmentLength",0.0,100.0,left,top+posY+80,len,15); // MG added
  sliders[si++] = controlP5.addSlider("letterStrokeWeight",0.0,100.0,left,top+posY+100,len,15); // MG added
  toggles[ti] = controlP5.addToggle("deformLetter",deformLetter,left+0,top+posY+120,15,15);
  toggles[ti++].setLabel("DeformLetter");
  toggles[ti] = controlP5.addToggle("moveLetter",moveLetter,left+0,top+posY+140,15,15);
  toggles[ti++].setLabel("MoveLetter");
  toggles[ti] = controlP5.addToggle("iterateLetter",iterateLetter,left+0,top+posY+160,15,15);
  toggles[ti++].setLabel("IterateLetter");
  toggles[ti] = controlP5.addToggle("drawLetterGeometry",drawLetterGeometry,left+0,top+posY+180,15,15);
  toggles[ti++].setLabel("DrawLetterGeometry");
  toggles[ti] = controlP5.addToggle("thickenGrid",thickenGrid,left+0,top+posY+200,15,15);
  toggles[ti++].setLabel("ThickenGrid");


  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].captionLabel().toUpperCase(true);
    sliders[i].captionLabel().style().padding(4,3,3,3);
    sliders[i].captionLabel().style().marginTop = -4;
    sliders[i].captionLabel().style().marginLeft = 0;
    sliders[i].captionLabel().style().marginRight = -14;
    sliders[i].captionLabel().setColorBackground(0x99ffffff);
  }
  for (int i = 0; i < ri; i++) {
    ranges[i].setGroup(ctrl);
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
  for (int i = 0; i < bi; i++) {
    bangs[i].setGroup(ctrl);
    bangs[i].setColorLabel(color(50));
    bangs[i].captionLabel().style().padding(4,3,3,3);
    bangs[i].captionLabel().style().marginTop = -20;
    bangs[i].captionLabel().style().marginLeft = 33;
    bangs[i].captionLabel().style().marginRight = 5;
    bangs[i].captionLabel().setColorBackground(0x99ffffff);
  }

}



void drawGUI(){
  controlP5.show();
  controlP5.draw();
}



void controlEvent(ControlEvent theControlEvent) {
  guiEvent = true;

  GUI = controlP5.group("menu").isOpen();

  if(theControlEvent.isController()) {
    if(theControlEvent.controller().name().equals("gridStepX")) {
      if (oldGridStepX != 0) {
        scaleGrid(gridStepX/oldGridStepX, 1, 1);
      }
      oldGridStepX = gridStepX;
    }
    if(theControlEvent.controller().name().equals("gridStepY")) {
      if (oldGridStepY != 0) {
        scaleGrid(1, gridStepY/oldGridStepY, 1);
      }
      oldGridStepY = gridStepY;
    }
    if(theControlEvent.controller().name().equals("gridStepZ")) {
      if (oldGridStepZ != 0) {
        scaleGrid(1, 1, gridStepZ/oldGridStepZ);
      }
      oldGridStepZ = gridStepZ;
    }
  }

}


void drawX() {
  guiEvent = true;
  drawX = !drawX;
}
void drawY() {
  guiEvent = true;
  drawY = !drawY;
}
void drawZ() {
  guiEvent = true;
  drawZ = !drawZ;
}


void lockX() {
  guiEvent = true;
  lockX = !lockX;
}
void lockY() {
  guiEvent = true;
  lockY = !lockY;
}
void lockZ() {
  guiEvent = true;
  lockZ = !lockZ;
}


void drawLines() {
  if (!guiEvent) {
    guiEvent = true;
    drawLines = !drawLines;
    drawCurves = !drawLines;
    Toggle t = (Toggle) controlP5.controller("drawCurves");
    t.setState(drawCurves);
  }
}

void drawCurves() {
  if (!guiEvent) {
    guiEvent = true;
    drawCurves = !drawCurves;
    drawLines = !drawCurves;
    Toggle t = (Toggle) controlP5.controller("drawLines");
    t.setState(drawLines);
  }
}




void invertBackground() {
  guiEvent = true;
  invertBackground = !invertBackground;
  updateColors(invertBackground);
}



void updateColors(boolean stat) {
  ControllerGroup ctrl = controlP5.getGroup("menu");

  for (int i = 0; i < sliders.length; i++) {
    if (sliders[i] == null) break;
    if (stat == false) {
      sliders[i].setColorLabel(color(50));
      sliders[i].captionLabel().setColorBackground(0x99ffffff);
    } 
    else {
      sliders[i].setColorLabel(color(200));
      sliders[i].captionLabel().setColorBackground(0x99000000);
    }
  }
  for (int i = 0; i < ranges.length; i++) {
    if (ranges[i] == null) break;
    if (stat == false) {
      ranges[i].setColorLabel(color(50));
      ranges[i].captionLabel().setColorBackground(0x99ffffff);
    } 
    else {
      ranges[i].setColorLabel(color(200));
      ranges[i].captionLabel().setColorBackground(0x99000000);
    }
  }
  for (int i = 0; i < toggles.length; i++) {
    if (toggles[i] == null) break;
    if (stat == false) {
      toggles[i].setColorLabel(color(50));
      toggles[i].captionLabel().setColorBackground(0x99ffffff);
    } 
    else {
      toggles[i].setColorLabel(color(200));
      toggles[i].captionLabel().setColorBackground(0x99000000);
    }
  }
  for (int i = 0; i < bangs.length; i++) {
    if (bangs[i] == null) break;
    if (stat == false) {
      bangs[i].setColorLabel(color(50));
      bangs[i].captionLabel().setColorBackground(0x99ffffff);
    } 
    else {
      bangs[i].setColorLabel(color(200));
      bangs[i].captionLabel().setColorBackground(0x99000000);
    }
  }
}

void iterateLetter() {
  guiEvent = true;
  iterateLetter = !iterateLetter;
//  updateColors(invertBackground);
}

void deformLetter() {
  guiEvent = true;
  deformLetter = !deformLetter;
//  updateColors(invertBackground);
}

void moveLetter() {
  guiEvent = true;
  moveLetter = !moveLetter;
//  updateColors(invertBackground);
}

void drawLetterGeometry() {
  guiEvent = true;
  drawLetterGeometry = !drawLetterGeometry;
//  updateColors(invertBackground);
}

void thickenGrid() {
  guiEvent = true;
  thickenGrid = !thickenGrid;
//  updateColors(invertBackground);
}

void solidBackground() {
  guiEvent = true;
  solidBackground = !solidBackground;
//  updateColors(invertBackground);
}






