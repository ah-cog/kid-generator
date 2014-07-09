/* 
 Processing (http://www.processing.org, v.1.0.1) Java program for 
 Approximating a circular arc with a cubic Bezier curve.
 Reasonably accurate for angles up to a quarter-circle or so.
 The solution is taken from this PDF by Richard DeVeneza:
 http://www.tinaja.com/glib/bezcirc2.pdf
 linked from this excellent site by Don Lancaster:
 http://www.tinaja.com/cubic01.asp
 Note: written for clarity; not optimized!
 */
 
void setup(){
  size(800, 800, OPENGL);
//  hint(DISABLE_DEPTH_TEST);

  r0 = new float[3];
  r1 = new float[3];
  r2 = new float[3];
  
  thetas = new float[3];
  startAngles = new float[3];
}
 
//--------------------------
// Global variables: 
// The true coordinates of the Bezier control points:
float px0,py0;
float px1,py1;
float px2,py2;
float px3,py3;
float startRadius = 10; // radius of the circular arc
float px00,py00;
float px01,py01;
float px02,py02;
float px03,py03;
float arcWidth = 100;
//float radius0 = radius + arcWidth;
float cx = 0; // center point of the circular arc
float cy = 0;

boolean reset = true;

float[] r0, r1, r2;
float[] thetas, startAngles;

color background, foreground;

float backgroundLength = 600;
float backgroundOffsetZ = -200;

boolean drawOutlines = false;
float outlineColor;
float outlineWeight = 1.0;

//class Layer {
//  float x;
//  float y;
//  float z;
//  
//  float roll;
//  float pitch;
//  float yaw;
//  
//  color fillColor;
//  color outlineColor;
//};
 
//--------------------------
void draw(){
  background(255);
  
  smooth();
  
  if (reset) {
    for (int i = 0; i < 3; i++) { r0[i] = random(-1.1*HALF_PI, 1.1*HALF_PI); }
    for (int i = 0; i < 3; i++) { r1[i] = random(-1.1*HALF_PI, 1.1*HALF_PI); }
    for (int i = 0; i < 3; i++) { r2[i] = random(-1.1*HALF_PI, 1.1*HALF_PI); }
    
    for (int i = 0; i < 3; i++) { startAngles[i] = random(-PI, PI); }
    for (int i = 0; i < 3; i++) { thetas[i] = random(PI / 4, 1.5 * PI); }
    
    background = color(random(0, 255), random(0, 255), random(0, 255), random(0, 255));
    foreground = color(random(0, 255), random(0, 255), random(0, 255), random(0, 255));
    outlineColor = color(random(0, 255), random(0, 255), random(0, 255));
    
    reset = false;
  }
  
  translate(width / 2 , height / 2, -50);
  
  pushMatrix();
  translate(0, 0, backgroundOffsetZ);
  fill(background); // color(255, 95, 34)
  noStroke();
  beginShape();
  vertex(-(backgroundLength / 2), -(backgroundLength / 2));
  vertex((backgroundLength / 2), -(backgroundLength / 2));
  vertex((backgroundLength / 2), (backgroundLength / 2));
  vertex(-(backgroundLength / 2), (backgroundLength / 2));
  endShape(CLOSE);
  popMatrix();
  
//  rotate(mouseX, mouseY, 0, 0);
 
  drawLayer(0, startRadius, thetas[0], startAngles[0],   r0[0], r0[2], 0, 150);
  drawLayer(1, startRadius + arcWidth - 20, thetas[1], startAngles[1],   r1[0], r1[2], 0, 120);
  drawLayer(2, startRadius + 2 * arcWidth - 40, thetas[2], startAngles[2],   r2[0], r2[2], 0, 70);
 
}

void drawLayer(int layer, float radius, float theta, float startAngle, float rotateX, float rotateY, float rotateZ, float thickness) {
  
  // Establish arc parameters.
  // (Note: assert theta != TWO_PI)
//  float theta = radians(mouseX/3.0); // spread of the arc.
//  float startAngle = radians(mouseY/8.0); // as in arc()
  float endAngle = startAngle + theta;    // as in arc()
 
  // Compute raw Bezier coordinates.
  float x0 = cos(theta/2.0);
  float y0 = sin(theta/2.0);
  float x3 = x0;
  float y3 = 0-y0;
  float x1 = (4.0-x0)/3.0;
  float y1 = ((1.0-x0)*(3.0-x0))/(3.0*y0); // y0 != 0...
  float x2 = x1;
  float y2 = 0-y1;
 
  // Compute rotationally-offset Bezier coordinates, using:
  // x' = cos(angle) * x - sin(angle) * y;
  // y' = sin(angle) * x + cos(angle) * y;
  float bezAng = startAngle + theta/2.0;
  float cBezAng = cos(bezAng);
  float sBezAng = sin(bezAng);
  float rx0 = cBezAng * x0 - sBezAng * y0;
  float ry0 = sBezAng * x0 + cBezAng * y0;
  float rx1 = cBezAng * x1 - sBezAng * y1;
  float ry1 = sBezAng * x1 + cBezAng * y1;
  float rx2 = cBezAng * x2 - sBezAng * y2;
  float ry2 = sBezAng * x2 + cBezAng * y2;
  float rx3 = cBezAng * x3 - sBezAng * y3;
  float ry3 = sBezAng * x3 + cBezAng * y3;
 
  // Compute scaled and translated Bezier coordinates.
  px0 = cx + radius*rx0;
  py0 = cy + radius*ry0;
  px1 = cx + radius*rx1;
  py1 = cy + radius*ry1;
  px2 = cx + radius*rx2;
  py2 = cy + radius*ry2;
  px3 = cx + radius*rx3;
  py3 = cy + radius*ry3;
  
  float radius0 = radius + arcWidth;
  px00 = cx + radius0*rx0;
  py00 = cy + radius0*ry0;
  px01 = cx + radius0*rx1;
  py01 = cy + radius0*ry1;
  px02 = cx + radius0*rx2;
  py02 = cy + radius0*ry2;
  px03 = cx + radius0*rx3;
  py03 = cy + radius0*ry3;
 
 
  // Draw the Bezier control points.
//  stroke(0,0,0, 64);
//  fill  (0,0,0, 64);
//  ellipse(px0,py0, 8,8);
//  ellipse(px1,py1, 8,8);
//  ellipse(px2,py2, 8,8);
//  ellipse(px3,py3, 8,8);
//  line (cx,cy,   px0,py0);
//  line (px0,py0, px1,py1);
//  line (px1,py1, px2,py2);
//  line (px2,py2, px3,py3);
//  line (px3,py3,   cx,cy);
 
  //--------------------------
  // BLUE IS THE "TRUE" CIRULAR ARC:
  noFill();
  if (drawOutlines) {
    stroke(outlineColor);
    strokeWeight(outlineWeight);
  } else {
    noStroke();
  }
//  arc(cx, cy, radius*2, radius*2, startAngle, endAngle);
 
  //--------------------------
  // RED IS THE BEZIER APPROXIMATION OF THE CIRCULAR ARC:
  //fill(color(0, 255, 0)); // noFill();
  
  pushMatrix();
  
  rotateX(rotateX);
  rotateY(rotateY);
  rotateZ(rotateZ);
  
  // Draw front inner arc
  fill(foreground);
  beginShape();
  
  // Outer line
  vertex(px00, py00);
  bezierVertex(px01, py01, px02, py02, px03, py03);
  vertex(px03, py03);
  
  // Inner line
  vertex(px3, py3);
  bezierVertex(px2, py2, px1, py1, px0, py0);
  vertex(px0, py0);
  
  vertex(px00, py00);
  
  endShape(CLOSE);
  
  
  
  
  // Draw front outer arc
  fill(foreground);
  beginShape();
  
  // bezier(px00,py00, px01,py01, px02,py02, px03,py03); // draw outer line
  vertex(px00, py00, thickness);
  bezierVertex(px01, py01, thickness, px02, py02, thickness, px03, py03, thickness);
  vertex(px03, py03, thickness);
  
  vertex(px3, py3, thickness);
  bezierVertex(px2, py2, thickness, px1, py1, thickness, px0, py0, thickness);
  vertex(px0, py0, thickness);
  
  vertex(px00, py00, thickness);
  
  endShape(CLOSE);
  
  
  
  // Draw surface of inner curver
  fill(foreground);
  beginShape();

  vertex(px0, py0, 0);
  bezierVertex(px1, py1, 0, px2, py2, 0, px3, py3, 0);
  vertex(px3, py3, 0);

  vertex(px3, py3, thickness);
  bezierVertex(px2, py2, thickness, px1, py1, thickness, px0, py0, thickness);
  vertex(px0, py0, thickness);
  
  vertex(px0, py0, 0);
  
  endShape(CLOSE);
  
  
  
  
  // Draw surface of outer curver
  fill(foreground);
  beginShape();

  vertex(px03, py03, 0);
  bezierVertex(px02, py02, 0, px01, py01, 0, px00, py00, 0);
  vertex(px00, py00, 0);
  
  vertex(px00, py00, thickness);
  bezierVertex(px01, py01, thickness, px02, py02, thickness, px03, py03, thickness);
  vertex(px03, py03, thickness);
  
  vertex(px03, py03, 0);
  
  endShape(CLOSE);
  
  
  
  
  // Close one side of the 3D arc
  fill(foreground);
  beginShape();

  vertex(px0, py0, 0); // Front
  vertex(px00, py00, 0);
  
  vertex(px00, py00, thickness);
  vertex(px0, py0, thickness); // Back
  
    endShape(CLOSE);
  
  
  
  
  // Close the other side of the 3D arc
  fill(foreground);
  beginShape();

  vertex(px3, py3, 0); // Front
  vertex(px03, py03, 0);
  
  vertex(px03, py03, thickness);
  vertex(px3, py3, thickness); // Back
  
    endShape(CLOSE);
  
  
  
  
  
  popMatrix();
  
  noFill();
}

void keyReleased() {
  if (key == 'r' || key == 'R') {
    reset = true;
  }
}
