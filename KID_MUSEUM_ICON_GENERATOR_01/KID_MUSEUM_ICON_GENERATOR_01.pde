// KID_MUSEUM_ICON_GENERATOR.pde
// RadialLayerItem.pde, GUI.pde, SunburstItem.pde
//
// This sketch was a collaborative effort by
// Michael Gubbels and Michael Smith-Welch for KID Museum.
// 
// Copyright 2014 Michael Gubbels, Michael Smith-Welch
//
// http://www.kid-museum.org/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// CREDITS
// Credits from KID Museum:
// Parts of this code were adapted from the M_5_5_01_TOOL.pde sketch associated with
// Generative Gestaltung, ISBN: 978-3-87439-759-9, First Edition by Hartmut Bohnacker, 
// Benedikt Gross, Julia Laub, and Claudius Lazzeroni. The website for the book is 
// located at http://www.generative-gestaltung.de.
//
// Credits from previous contributors:
// Part of the FileSystemItem class is based on code from Visualizing Data, First Edition 
// by Ben Fry. Copyright 2008 Ben Fry, 9780596514556.
//
// calcEqualAreaRadius function was done by Prof. Franklin Hernandez-Castro

/**
 * KEYS
 * r                          : re-generate
 * m                          : toogle, menu open/close
 * s                          : save png
 * p                          : save pdf
 */

import processing.pdf.*;
import controlP5.*;
import java.util.Calendar;
import java.util.Date;
import java.io.File;
import org.gicentre.handy.*;
import gifAnimation.*;

HandyRenderer h;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;
Range[] ranges;
Toggle[] toggles;


// ------ animated gif ------
GifMaker gifExport;


// ------ interaction vars ------

boolean savePDF = false;

PFont font;

// ------ program logic ------
ArrayList<SunburstItem> sunburstItems;
ArrayList<RadialLayerItem> radialLayerItems;
Calendar now = Calendar.getInstance();
int depthMax;

boolean initialize = true;
boolean recordFrames = false;
int layerCount = 3;

color arcStrokeColor;
color arcFillColor;

float sceneScale = 0.50;
float sceneRotation = 0.00;

float layerThickness = 88; // random(50, 120); // TODO: Make this a parameter in the generator!
float layerOneAngle = 1.42; // 1.59; // 1.84;
float layerOneLength = 5.57;
float layerOneTransparency = 70;
float layerOneFillGap = 0.5;

float layerTwoAngle = 3.07;
float layerTwoLength = 3.07;
float layerTwoTransparency = 255;
float layerTwoFillGap = 0.5;

float layerThreeAngle = 1.42; // 1.84;
float layerThreeLength = 4.48; // 5.13;
float layerThreeTransparency = 255;
float layerThreeFillGap = 0.5;

float layerOffset = 0.0; // 0.2 * PI; // 0.0; // 0.2 * PI;

boolean enableSketchiness = true;
float roughness = 1.0; // e.g., 1.0
float fillGap = 7.0; // e.g., 0.5
int arcSegmentFrequency = 2; // e.g., 5, 10
boolean enableOutline = true;
float strokeWeight = 1.0; // e.g., 1.0

int cLayerCount = 2;
float xOffset = -30;
float yOffset = 0;

boolean enableYvesKleinArm = false;

boolean saveGif = false;
boolean savingGif = false;

void setup() {
//  size(displayWidth, displayHeight);
  size(800, 800); // size(800, 800, OPENGL);
  // hint(DISABLE_DEPTH_TEST);
  
  smooth();
  
  h = new HandyRenderer(this);
//  h = HandyPresets.createWaterAndInk(this);
//  h = HandyPresets.createPencil(this);
//  h = HandyPresets.createColouredPencil(this);
//  h = HandyPresets.createMarker(this);
  h.setOverrideFillColour(true);
  h.setOverrideStrokeColour(true);
  
  sunburstItems = new ArrayList<SunburstItem>();
  radialLayerItems = new ArrayList<RadialLayerItem>();
  
  setupInterface();

  frame.setTitle("KID Museum Icon Generator 1");
}

long randomSeed = 1234;

void draw() {
  
  if (saveGif) {
    saveGif = false;
    savingGif = true;
    gifExport = new GifMaker(this, "data/output/gif/" + timestamp() + ".gif");
    gifExport.setRepeat(0); // make it an "endless" animation
//    gifExport.setTransparent(0,0,0);    // black is transparent
  }
  
  // Set up the sketchy effect
  if (enableSketchiness) {
    h.setIsHandy(true);
  } else {
    h.setIsHandy(false);
  }
  
  if (savePDF) {
    println("\n"+"saving to pdf – starting");
    beginRecord(PDF, "data/output/" + timestamp() + ".pdf");
  }
  
  if (recordFrames == true) {
    initialize = true;
  }
  
  if (initialize) {
    // TODO: Clear the list!
    sunburstItems.clear();
//    generateIcon(layerCount, -400, 0);
    generateIcon(layerCount, 0, 0);
    // initialize = false;
    
//    arcStrokeColor = color(240, 100, 50); // color(360, 100, 100); // color(random(0, 360), 100, 100);
//    arcFillColor = color(random(0, 360), 100, 100);
    
    // Initialize random number generator seed
    randomSeed = int(random(0, 2147483647));
    
    h.setHachurePerturbationAngle(random(15, 100));
    h.setRoughness(roughness);
//    h.setFillGap(fillGap); // 0.5
    h.setIsAlternating(true);
    h.setFillWeight(0.2); // 0.1
  }
  
  h.setSeed(randomSeed); // Set seed for Handy renderer

  pushMatrix();
//  colorMode(HSB, 360, 100, 100, 100);
  background(255, 255, 255);
  noFill();
  ellipseMode(RADIUS);
  strokeCap(SQUARE);
  textAlign(LEFT, TOP);
  smooth();

  // Adjust our view onto the generated visuals
  translate(width / 2, height / 2); //  translate(width / 2, height / 2, -200);
  rotate(sceneRotation);
  scale(sceneScale);
  
  /*
  // Draw the background circle;
  h.setStrokeColour(color(4, 73, random(100, 251), layerTwoTransparency));
  h.setFillColour(color(4, 73, random(100, 251), layerTwoTransparency));
  h.setBackgroundColour(color(4, 73, random(100, 251), layerTwoTransparency));
  h.setHachurePerturbationAngle(random(15, 100));
  h.setRoughness(roughness);
    h.setFillGap(fillGap); // 0.5
  h.setIsAlternating(true);
  h.ellipse(0, 0, 600, 600);
  */

  // ------ draw the viz items ------
  for (int i = 0 ; i < sunburstItems.size(); i++) {
    sunburstItems.get(i).arcSegmentFrequency = this.arcSegmentFrequency;
    sunburstItems.get(i).strokeWeight = this.strokeWeight;
    sunburstItems.get(i).enableStroke = this.enableOutline;
    sunburstItems.get(i).draw();
  }
  
  // EXPERIMENT: Concentric white circles
//  noFill();
//  stroke(color(0, 0, 100));
//  int step = 10;
//  for (int i = 0; i < 100; i++) {
//    ellipse(0, 0, 100 + step * i, 100 + step * i);
//  }

//h.setHachurePerturbationAngle(random(15, 100));
//    h.setRoughness(roughness);
//    h.setFillGap(fillGap); // 0.5
//    h.setIsAlternating(true);
//    h.setFillWeight(0.2); // 0.1
//  h.setBackgroundColour(color(0));
//  h.setFillColour(color(206,0,0,255));
//  h.setStrokeColour(color(0));
//  h.ellipse(0,0,this.layerCount * this.layerThickness, this.layerCount * this.layerThickness);
  
  popMatrix();

  if (savePDF) {
    savePDF = false;
    endRecord();
    println("saving to pdf – done");
  }
  
  // Save frame to animated gif
  if (savingGif) {
    gifExport.setDelay(1);
    gifExport.addFrame();
  }
  
  if (initialize) {
    if (recordFrames == true) {
      saveFrame("data/output/"+timestamp()+"_##.png");
    }
    initialize = false;
  }

  drawGUI();
}

void generateIcon (int layerCount, float xShift, float yShift) {
  
//  sunburstItems.clear();
  
//  color positiveColor = color(245, 100, 100); // color(random(190, 290), random(10, 100), random(50, 100));
//  color negativeSpaceColor = color(0, 0, 100);
//  float arcWidth = 101; // random(50, 120); // TODO: Make this a parameter in the generator!
//  
//  float actualLayerOneAngle = layerOneAngle;
//  float actualLayerTwoAngle = layerTwoAngle;

  float actualLayerOneAngle = layerOneAngle;
  float actualLayerTwoAngle = layerTwoAngle;
  
  
  
  // Add "circle background"
  if (false) {
    h.setFillGap(layerTwoFillGap);
    RadialLayerItem circleForm = new RadialLayerItem(null);
  //  if (this.enableYvesKleinArm) {
      circleForm.setColor(color(4, 73, random(100,251), layerOneTransparency));
  //  } else {
  //    circleForm.setColor(color(60, 0, 199));
  //  }
    // radialForm.setNegativeColor(color(360, 100, 100, 100)); //radialForm.setNegativeColor(negativeSpaceColor);
    circleForm.layerNumber = -2;
    circleForm.setArcWidth(600);
    circleForm.angle = 0;
    circleForm.distance = TWO_PI;
    radialLayerItems.add(circleForm);
    SunburstItem sunburstItem3 = circleForm.generateSunburstItem();
    sunburstItem3.radius = 800;
    sunburstItem3.setColor(color(4, 73, random(100,251), layerOneTransparency));
    sunburstItems.add(sunburstItem3);
  }

  for (int depth = 0; depth < this.cLayerCount; depth++) {
    
    float xOffsetForArc = (this.cLayerCount - depth - 1) * xOffset; // random(-depth * 20, depth * 20);
    float yOffsetForArc = (this.cLayerCount - depth - 1) * yOffset; // float yOffset = random(-depth * 20, depth * 20);
    
    float layerTransparency = 0.0;
    if (depth == 0) {
      layerTransparency = layerOneTransparency;
      h.setFillGap(layerOneFillGap);
    } else if (depth == 1) {
      layerTransparency = layerTwoTransparency;
      h.setFillGap(layerTwoFillGap);
    } else if (depth == 2) {
      layerTransparency = layerThreeTransparency;
      h.setFillGap(layerThreeFillGap);
    }
    
//    color positiveColor = color(4, random(100,251), 72, layerTransparency); // color(random(190, 290), random(10, 100), random(50, 100));
//    if (depth == 1) {
//      positiveColor = color(245, 100, 100, 33 * depth);
//    }
    color positiveColor = color(4, 73, random(100,251), layerTransparency); // color(random(190, 290), random(10, 100), random(50, 100));
    if (depth == 1) {
      positiveColor = color(random(233,255), random(69,165), random(0,128), layerTransparency);
    }
    color negativeSpaceColor = color(255, 255, 255);
    
    for (int i = 0; i < layerCount; i++) {
      if (i == 0) {
        RadialLayerItem radialForm = new RadialLayerItem(null);
        radialForm.setOffset(xOffsetForArc + xShift, yOffsetForArc + yShift);
        radialForm.setColor(positiveColor);
        radialForm.setNegativeColor(negativeSpaceColor);
        radialForm.setArcWidth(layerThickness);
        radialForm.angle = random(layerOneAngle - layerOffset * PI, layerOneAngle + layerOffset * PI);
        radialForm.distance = random(layerOneLength - layerOffset * PI, layerOneLength + layerOffset * PI);
        actualLayerOneAngle = radialForm.angle; // TODO: hack! make this better!
        radialLayerItems.add(radialForm);
        sunburstItems.add(radialForm.generateSunburstItem());
  //      sunburstItems.add(radialForm.generateNegativeSunburstItem());
      } else {
        RadialLayerItem radialForm = new RadialLayerItem(radialLayerItems.get(i - 1));
        // sunburstItem.setColor(this.strokeColor);
        radialForm.setColor(positiveColor);
        radialForm.setNegativeColor(negativeSpaceColor);
        radialForm.setArcWidth(layerThickness);
        if (i == 1) {
        radialForm.setOffset(xOffsetForArc + xShift, yOffsetForArc + yShift);
          radialForm.angle = random(layerTwoAngle - layerOffset * PI, layerTwoAngle + layerOffset * PI);
          actualLayerTwoAngle = radialForm.angle; // TODO: hack! make this better!
          radialForm.distance = random(layerTwoLength - layerOffset * PI, layerTwoLength + layerOffset * PI);
        } else if (i == 2) {
        radialForm.setOffset(xOffsetForArc + xShift, yOffsetForArc + yShift);
          radialForm.angle = random(layerThreeAngle - layerOffset * PI, layerThreeAngle + layerOffset * PI);
          radialForm.distance = random(layerThreeLength - layerOffset * PI, layerThreeLength + layerOffset * PI);
        }
        radialLayerItems.add(radialForm);
        sunburstItems.add(radialForm.generateSunburstItem());
  //      sunburstItems.add(radialForm.generateNegativeSunburstItem());
      }
    }
  }
  
  // Add "second arm" arc segment
  if (true) {
    RadialLayerItem secondaryRadialForm = new RadialLayerItem(null);
    if (this.enableYvesKleinArm) {
      secondaryRadialForm.setColor(color(60, 0, 199));
    } else {
      secondaryRadialForm.setColor(color(60, 0, 199));
    }
    // radialForm.setNegativeColor(color(360, 100, 100, 100)); //radialForm.setNegativeColor(negativeSpaceColor);
    secondaryRadialForm.layerNumber = -1;
    secondaryRadialForm.setArcWidth(layerThickness);
    secondaryRadialForm.angle = random(layerOneAngle - layerOffset * PI, layerOneAngle - layerOffset * PI) - 0.005 * PI;
    secondaryRadialForm.distance = random(0, (actualLayerTwoAngle - actualLayerOneAngle) + layerOffset * PI); // actualLayerTwoAngle + layerOffset * PI);
    radialLayerItems.add(secondaryRadialForm);
    SunburstItem sunburstItem2 = secondaryRadialForm.generateSunburstItem();
    sunburstItem2.radius = 150;
    sunburstItem2.setColor(color(255, 255, 255));
    sunburstItems.add(sunburstItem2);
  }
  
//  // Add "third arm" arc segment
//  RadialLayerItem tertiaryRadialForm = new RadialLayerItem(null);
//  if (this.enableYvesKleinArm) {
//    tertiaryRadialForm.setColor(color(60, 0, 199));
//  } else {
//    tertiaryRadialForm.setColor(color(255, 255, 255));
//  }
//  tertiaryRadialForm.layerNumber = -1;
//  // radialForm.setNegativeColor(color(360, 100, 100, 100)); //radialForm.setNegativeColor(negativeSpaceColor);
//  tertiaryRadialForm.setArcWidth(arcWidth); // secondaryRadialForm.setArcWidth(0.5 * arcWidth);
//  // secondaryRadialForm.angle = random(layerOneAngle - /*layerOffset*/ 0.15 * PI, layerOneAngle + /*layerOffset*/ 0.15 * PI);
//  tertiaryRadialForm.angle = random(layerTwoAngle + layerTwoLength - layerOffset * PI, layerOneAngle - layerOffset * PI) - 0.005 * PI;
//  // secondaryRadialForm.distance = random(0.5 * QUARTER_PI, QUARTER_PI);
//  tertiaryRadialForm.distance = random(layerOneAngle - layerOffset * PI, layerOneAngle - layerOffset * PI) - 0.005 * PI;
//  radialLayerItems.add(tertiaryRadialForm);
//  SunburstItem sunburstItem3 = tertiaryRadialForm.generateSunburstItem();
//  sunburstItem3.radius = 150; // random(100, 200); // 150; // calcAreaRadius(depth, depthMax);
//  //sunburstItem2.setColor(color(4, 73, 251, random(50, 255)));
//  sunburstItems.add(sunburstItem3);

  // mine sunburst -> get min and max values 
  // reset the old values, without the root element
  depthMax = 0;
  for (int i = 1 ; i < sunburstItems.size(); i++) {
    depthMax = max(sunburstItems.get(i).depth, depthMax);
  }
}


// ------ returns radiuses in a linear way ------
float calcAreaRadius(int theDepth, int theDepthMax) {
  return map(theDepth, 0, theDepthMax+1, 0, height/2);
}


// ------ interaction ------
void keyReleased() {
  if (key == CODED) {
    if (keyCode == RIGHT) {
      initialize = true;
    } else if (keyCode == LEFT) {
      // TODO: Recover the previously generated output (i.e., recover the previous parameterization state).
    } 
  }
  
  if (key == 'r' || key == 'R') { recordFrames = !recordFrames; }
  if (key == 's' || key == 'S') { saveFrame("data/output/"+timestamp()+"_##.png"); }
  if (key == 'p' || key == 'P') { savePDF = true; }
  if (key == ' ') {
    if (savingGif) {
      gifExport.finish();                 // write file
      savingGif = false;
      // saveGif = false; // This is redundant, but might be useful as a secondary check!
    } else if (saveGif == false) {
      saveGif = true;
    }
  }

  if (key == 'm' || key == 'M') {
    showGUI = controlP5.group("menu").isOpen();
    showGUI = !showGUI;
  }
  if (showGUI) { controlP5.group("menu").open(); }
  else { controlP5.group("menu").close(); }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
} 

boolean sketchFullScreen() {
  return false;
}



