/**
 * JSetup
 *
 * This example shows how to set up an interactive (mouse and keyboard) Processing scene
 * using the "proscene.js" framework targetting p5.js.
 *
 * The proscene.js library is obtained by applying the gwt transpiler
 * (http://www.gwtproject.org/) to all the proscene framework packages
 * (https://github.com/remixlab/proscene), but the remixlab.bias.ext.*. and the
 * remixlab.proscene.*. packages which are not compatible with the transpiler.
 *
 * For matrix handling please refer to the TargetMatrixHelper class. In particular the
 * TargetMatrixHalper.bind() function shows the p5.js functionality needed by the
 * proscene.js port.
 *
 * 'i' -> shifts default grabber
 * 's' -> interpolates to fit scene
 * 'a' -> adds KeyFrame to path 1
 * 'r' -> removes path 1
 * '1' -> plays path 1
 * 'left' & 'right' arrows -> rotates z
 */

import processing.opengl.*;

import remixlab.proscene.*;
import remixlab.bias.core.*;
import remixlab.bias.event.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;

CustomScene scene;
CustomGrabberFrame gFrame;
//String renderer = JAVA2D;
//String renderer = P2D;
String renderer = P3D;

void setup() {
  size(640, 360, renderer);    
  scene = new CustomScene(this); 
  gFrame = new CustomGrabberFrame(scene);
  gFrame.setGrabsInputThreshold(scene.radius()/4, true);
  gFrame.translate(50, 50);
}

void drawGeom() {
  if(scene.is2D())
    rect(0, 0, 30, 30, 7);
  else
    box(30);
}

void draw() {
  background(0);
  fill(204, 102, 0, 150);
  drawGeom();

  // Save the current model view matrix
  pushMatrix();
  // Multiply matrix to get in the frame coordinate system.
  // applyMatrix(Scene.toPMatrix(iFrame.matrix())); //is possible but inefficient
  gFrame.applyTransformation();//very efficient
  // Draw an axis using the Scene static function
  scene.drawAxes(20);

  // Draw a second torus
  if (scene.motionAgent().defaultGrabber() == gFrame) {
    fill(0, 255, 255);
    drawGeom();
  } else if (gFrame.grabsInput()) {
    fill(255, 0, 0);
    drawGeom();
  } else {
    fill(0, 0, 255, 150);
    drawGeom();
  }  
  popMatrix();
}

void keyPressed() {
  if ( key == 'i')
    scene.motionAgent().shiftDefaultGrabber(scene.eyeFrame(), gFrame);
}