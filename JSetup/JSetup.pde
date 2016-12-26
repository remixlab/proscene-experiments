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

// Mouse ids
public static final int LEFT_ID = MotionShortcut.registerID(37, 2, "LEFT"), CENTER_ID = MotionShortcut
      .registerID(3, 2, "CENTER"), RIGHT_ID = MotionShortcut.registerID(39, 2, "RIGHT"), WHEEL_ID = MotionShortcut
      .registerID(8, 1, "WHEEL"), NO_BUTTON = MotionShortcut
      .registerID(BogusEvent.NO_ID, 2, "NO_BUTTON"), LEFT_CLICK_ID = ClickShortcut
      .registerID(LEFT_ID, "LEFT"), RIGHT_CLICK_ID = ClickShortcut
      .registerID(RIGHT_ID, "RIGHT"), CENTER_CLICK_ID = ClickShortcut.registerID(CENTER_ID, "CENTER");
      
//key ids
public static final int LEFT_KEY = KeyboardShortcut.registerID(PApplet.LEFT, "LEFT_ARROW"), 
                        RIGHT_KEY = KeyboardShortcut.registerID(PApplet.RIGHT, "RIGHT_ARROW"),
                        UP_KEY = KeyboardShortcut.registerID(PApplet.UP, "UP_ARROW"),
                        DOWN_KEY = KeyboardShortcut.registerID(PApplet.DOWN, "DOWN_ARROW");

void setup() {
  size(640, 360, renderer);    
  scene = new CustomScene(this); 
  gFrame = new CustomGrabberFrame(scene);
  gFrame.setPickingPrecision(GenericFrame.PickingPrecision.ADAPTIVE);
  gFrame.setGrabsInputThreshold(scene.radius()/4);
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