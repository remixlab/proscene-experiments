/**
 * Application Control.
 * by Jean Pierre Charalambos.
 * 
 * This demo controls the shape and color of the scene torus and box using two interactive
 * frame instances, one displaying an ellipse and the other a rect.
 *
 * The behavior of an interactive frame may be customized eihter through external registration
 * of some key and mouse handler methods (such as with the ellipse frame) or through inheritance
 * (such as with the rect frame).
 * 
 * Click and drag the ellipse or the rect with the left mouse to control the torus and box
 * color and shape.
 * Press ' ' (the spacebar) to toggle the application canvas aid.
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.bias.event.*;
import remixlab.proscene.*;

int w = 1110;
int h = 510;
int oW = w/3;
int oH = h/3;
int oX = w - oW;
int oY = h - oH;
PGraphics canvas, ctrlCanvas;
Scene scene, ctrlScene;
public PShape eShape;
InteractiveFrame e;
InteractiveRect r;
boolean showControl  = true;

float radiusX = 40, radiusY = 40;
int colour = color(255, 0, 0);

void settings() {
  size(w, h, P2D);
}

void setup() {  
  rectMode(CENTER);

  canvas = createGraphics(w, h, P3D);
  scene = new Scene(this, canvas);

  ctrlCanvas = createGraphics(oW, oH, P2D);
  ctrlScene = new Scene(this, ctrlCanvas, oX, oY);

  e = new InteractiveFrame(ctrlScene);
  updateEllipse(e);
  e.setMotionBinding(this, MouseAgent.WHEEL_ID, "changeShape");
  e.setMotionBinding(this, LEFT, "changeShape");
  e.setClickBinding(this, LEFT, 1, "changeColor");
  e.setKeyBinding(this, 'x', "colorBlue");
  e.setKeyBinding(this, 'y', "colorRed");
  //ctrlScene.keyAgent().setDefaultGrabber(e);

  r = new InteractiveRect(ctrlScene);
  r.setMotionBinding(MouseAgent.WHEEL_ID, "changeShape");
  r.setMotionBinding(LEFT, "changeShape");
  r.setClickBinding(LEFT, 1, "changeColor");
  r.setKeyBinding('u', "colorBlue");
  r.setKeyBinding('v', "colorRed");
  ctrlScene.keyAgent().setDefaultGrabber(r);
}

void changeShape(InteractiveFrame frame, DOF1Event event) {
  radiusX += event.dx()*5;
  updateEllipse(frame);
}

void changeShape(InteractiveFrame frame, DOF2Event event) {
  radiusX += event.dx();
  radiusY += event.dy();
  updateEllipse(frame);
}

void changeColor(InteractiveFrame frame) {
  colour = color(color(random(0, 255), random(0, 255), random(0, 255), 125));
  updateEllipse(frame);
}

void colorBlue(InteractiveFrame frame) {
  colour = color(0, 0, 255);
  updateEllipse(frame);
}

void colorRed(InteractiveFrame frame) {
  colour = color(255, 0, 0);
  updateEllipse(frame);
}

void updateEllipse(InteractiveFrame frame) {
  PShape ps = createShape(ELLIPSE, -60, 0, 2 * radiusX, 2 * radiusY);
  frame.setShape(ps);
  ps.setFill(color(colour));
}

void draw() {
  scene.beginDraw();
  canvas.background(255);
  canvas.fill(colour);
  canvas.pushMatrix();
  canvas.translate(-80, 0, 0);
  scene.drawTorusSolenoid((int) map(PI * radiusX * radiusY, 20, oW * oH, 2, 50), 100, radiusY/2, radiusX/2);
  canvas.popMatrix();
  canvas.pushMatrix();
  canvas.translate(80, 0, 0);
  canvas.fill(r.colour);
  canvas.box(r.halfWidth, r.halfHeight, (r.halfWidth + r.halfHeight) / 2);
  canvas.popMatrix();
  scene.endDraw();
  scene.display();
  if (showControl) {
    ctrlScene.beginDraw();
    ctrlCanvas.background(125, 125, 125, 125);
    ctrlScene.drawFrames();
    ctrlScene.endDraw();
    ctrlScene.display();
  }
}

void keyPressed() {
  if (key == ' ')
    showControl = !showControl;
}
