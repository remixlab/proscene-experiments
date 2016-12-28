/**
 * Dizzy
 * by Jean Pierre Charalambos.
 *
 * This example demonstrates how 2D key frames may be used to perform a Prezi-like
 * presentation.
 *
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;
import remixlab.dandelion.geom.*;

Scene scene;
PImage img;
PFont buttonFont;
Button2D toggleButton;
ArrayList<Button2D> buttons;
InteractiveFrame message1;
InteractiveFrame message2;
InteractiveFrame image;
float h;
int fSize = 16;

public void setup() {
  size(640, 360, P2D);

  img = loadImage("dizzi.jpg");
  scene = new Scene(this);
  scene.setGridVisualHint(false);
  scene.setAxesVisualHint(false);

  message1 = new InteractiveFrame(scene);
  message2 = new InteractiveFrame(scene);
  image = new InteractiveFrame(scene);

  message1.setPosition(33.699852f, -62.68051f);
  message1.setOrientation(new Rot(-1.5603539f));
  message1.setMagnitude(0.8502696f);

  message2.setPosition(49.460827f, 74.67359f);
  message2.setOrientation(new Rot(-1.533576f));
  message2.setMagnitude(0.3391391f);

  image.setPosition(-314.30075f, -165.1348f);
  image.setOrientation(new Rot(-0.0136114275f));
  image.setMagnitude(0.07877492f);

  // create a camera path and add some key frames:
  // key frames can be added at runtime with keys [j..n]
  scene.loadConfig();
  buttonFont = loadFont("FreeSans-16.vlw");
  toggleButton = new Button2D(new PVector(10, 7), buttonFont, "");
  toggleButton.iFrame.setClickBinding(LEFT, 1, "action");
  toggleButton.iFrame.setFrontShape("frontShape");
  buttons = new ArrayList<Button2D>();
  for (int i=0; i<3; ++i)
    buttons.add(new ClickButton(new PVector(10, toggleButton.height*(i+1) + 7*(i+2)), buttonFont, String.valueOf(i+1), i+1));
}

public void draw() {
  background(0);
  fill(204, 102, 0);

  pushMatrix();
  image.applyTransformation();// optimum
  image(img, 0, 0);
  popMatrix();

  pushMatrix();
  message1.applyTransformation();// optimum
  text("I'm useless", 10, 50);
  popMatrix();

  fill(0, 255, 0);

  pushMatrix();
  message2.applyTransformation();// optimum
  text("but I feel dizzy", 10, 50);
  popMatrix();

  scene.drawFrames();
}

void action(InteractiveFrame frame) {
  scene.togglePathsVisualHint();
  //same as:
  //frame.scene().togglePathsVisualHint();
}

void frontShape(PGraphics pg) {
  toggleButton.setText(scene.pathsVisualHint() ? "don't edit camera paths" : "edit camera paths");
  toggleButton.display(pg);
}
