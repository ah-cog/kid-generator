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

HandyRenderer h;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;
Range[] ranges;
Toggle[] toggles;


// ------ interaction vars ------
float backgroundBrightness = 100;

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

float sceneRotation = 0;

float layerOneAngle = 1.59; // 1.84;
float layerOneLength = 5.57;
float layerTwoAngle = 3.07;
float layerTwoLength = 3.07;
float layerThreeAngle = 1.84;
float layerThreeLength = 4.48; // 5.13;
float layerOffset = 0.0; // 0.2 * PI; // 0.0; // 0.2 * PI;

boolean enableSketchiness = true;
float roughness = 1.0; // e.g., 1.0
float fillGap = 0.5; // e.g., 0.5
int arcSegmentFrequency = 5; // e.g., 5, 10
boolean enableOutline = false;
float strokeWeight = 1.0; // e.g., 1.0

boolean showBackground = false;

void setup() { 
  size(800, 800); // size(800, 800, OPENGL);
  // hint(DISABLE_DEPTH_TEST);
  
  smooth();
  
  h = new HandyRenderer(this);
//  h = HandyPresets.createWaterAndInk(this);
//  h = HandyPresets.createPencil(this);
//  h = HandyPresets.createColouredPencil(this);
//  h = HandyPresets.createMarker(this);
  
  sunburstItems = new ArrayList<SunburstItem>();
  radialLayerItems = new ArrayList<RadialLayerItem>();
  
  setupInterface(); 
  colorMode(HSB, 360, 100, 100);

  frame.setTitle("KID Museum Icon Generator 1");
}

long randomSeed = 1234;

void draw() {
  
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
    generateIcon(layerCount);
    // initialize = false;
    
    arcStrokeColor = color(240, 100, 50); // color(360, 100, 100); // color(random(0, 360), 100, 100);
    arcFillColor = color(random(0, 360), 100, 100);
    
    // Initialize random number generator seed
    randomSeed = int(random(0, 2147483647));
    
    h.setHachurePerturbationAngle(15);
    h.setRoughness(roughness);
    h.setFillGap(fillGap); // 0.5
    h.setIsAlternating(true);
    h.setFillWeight(0.1); // 0.1
  }
  
  h.setSeed(randomSeed); // Set seed for Handy renderer

  pushMatrix();
  colorMode(HSB, 360, 100, 100, 100);
  background(0, 0, backgroundBrightness);
  noFill();
  ellipseMode(RADIUS);
  strokeCap(SQUARE);
  textAlign(LEFT, TOP);
  smooth();

  // Adjust our view onto the generated visuals
  translate(width / 2, height / 2); //  translate(width / 2, height / 2, -200);
  rotate(sceneRotation);
  scale(0.8);

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
  
  popMatrix();

  if (savePDF) {
    savePDF = false;
    endRecord();
    println("saving to pdf – done");
  }
  
  if (initialize) {
    if (recordFrames == true) {
      saveFrame("data/output/"+timestamp()+"_##.png");
    }
    initialize = false;
  }

  drawGUI();
}

void generateIcon (int layerCount) {
  
  sunburstItems.clear();
  
  color positiveColor = color(245, 100, 100); // color(random(190, 290), random(10, 100), random(50, 100));
  color negativeSpaceColor = color(0, 0, 100);
  float arcWidth = 101; // random(50, 120); // TODO: Make this a parameter in the generator!
  
  float actualLayerOneAngle = layerOneAngle;
  float actualLayerTwoAngle = layerTwoAngle;

  for (int i = 0; i < layerCount; i++) {
    if (i == 0) {
      RadialLayerItem radialForm = new RadialLayerItem(null);
      radialForm.setColor(positiveColor);
      radialForm.setNegativeColor(negativeSpaceColor);
      radialForm.setArcWidth(arcWidth);
      radialForm.angle = random(layerOneAngle - layerOffset * PI, layerOneAngle + layerOffset * PI);
      radialForm.distance = random(layerOneLength - layerOffset * PI, layerOneLength + layerOffset * PI);
      actualLayerOneAngle = radialForm.angle; // TODO: hack! make this better!
      radialLayerItems.add(radialForm);
      sunburstItems.add(radialForm.generateSunburstItem());
//      sunburstItems.add(radialForm.generateNegativeSunburstItem());

      println("draw 1");
    } else {
      RadialLayerItem radialForm = new RadialLayerItem(radialLayerItems.get(i - 1));
      // sunburstItem.setColor(this.strokeColor);
      radialForm.setColor(positiveColor);
      radialForm.setNegativeColor(negativeSpaceColor);
      radialForm.setArcWidth(arcWidth);
      if (i == 1) {
        radialForm.angle = random(layerTwoAngle - layerOffset * PI, layerTwoAngle + layerOffset * PI);
        actualLayerTwoAngle = radialForm.angle; // TODO: hack! make this better!
        radialForm.distance = random(layerTwoLength - layerOffset * PI, layerTwoLength + layerOffset * PI);
      } else if (i == 2) {
        radialForm.angle = random(layerThreeAngle - layerOffset * PI, layerThreeAngle + layerOffset * PI);
        radialForm.distance = random(layerThreeLength - layerOffset * PI, layerThreeLength + layerOffset * PI);
      }
      radialLayerItems.add(radialForm);
      sunburstItems.add(radialForm.generateSunburstItem());
//      sunburstItems.add(radialForm.generateNegativeSunburstItem());
      println("draw 2");
    }
  }
  
  // Add "second arm" arc segment
  RadialLayerItem secondaryRadialForm = new RadialLayerItem(null);
  secondaryRadialForm.layerNumber = -1;
  // radialForm.setNegativeColor(color(360, 100, 100, 100)); //radialForm.setNegativeColor(negativeSpaceColor);
  secondaryRadialForm.setArcWidth(arcWidth); // secondaryRadialForm.setArcWidth(0.5 * arcWidth);
  // secondaryRadialForm.angle = random(layerOneAngle - /*layerOffset*/ 0.15 * PI, layerOneAngle + /*layerOffset*/ 0.15 * PI);
  secondaryRadialForm.angle = random(layerOneAngle - layerOffset * PI, layerOneAngle - layerOffset * PI) - 0.005 * PI;
  // secondaryRadialForm.distance = random(0.5 * QUARTER_PI, QUARTER_PI);
//  actualLayerTwoAngle
  secondaryRadialForm.distance = random(0, (actualLayerTwoAngle - actualLayerOneAngle) + layerOffset * PI); // actualLayerTwoAngle + layerOffset * PI);
  radialLayerItems.add(secondaryRadialForm);
  SunburstItem sunburstItem2 = secondaryRadialForm.generateSunburstItem();
  sunburstItem2.radius = 150; // random(100, 200); // 150; // calcAreaRadius(depth, depthMax);
  sunburstItems.add(sunburstItem2);

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




