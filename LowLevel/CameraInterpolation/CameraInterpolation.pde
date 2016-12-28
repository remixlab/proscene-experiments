/**
 * Camera Interpolation.
 * by Jean Pierre Charalambos.
 *
 * This example (together with Frame Interpolation) illustrates the
 * KeyFrameInterpolator functionality.
 *
 * KeyFrameInterpolator smoothly interpolate its attached Camera Frames over time
 * on a path defined by Frames. The interpolation can be started/stopped/reset,
 * played in loop, played at a different speed, etc...
 *
 * In this example, a Camera path is defined by four InteractiveFrames
 * which are attached to the first Camera path (the Camera holds five such paths).
 * The Frames can be moved with the mouse, making the path editable. The Camera
 * interpolating path is played with the shortcut '1'.
 *
 * Press CONTROL + '1' to add (more) key frames to the Camera path.
 *
 * Press ALT + '1' to delete the Camera path.
 *
 * The displayed texts are interactive. Click on them to see what happens.
 *
 * The Camera holds 3 KeyFrameInterpolators, binded to [1..3] keys. Pressing
 * CONTROL + [1..3] adds key frames to the specific path. Pressing ALT + [1..3]
 * deletes the specific path. Press 'r' to display all the key frame camera paths
 * (if any). The displayed paths are editable.
 *
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;

Scene scene;
Button2D toggleButton;
ArrayList<Button2D> buttons;
PFont buttonFont;

void setup() {
  size(800, 800, P3D);
  scene = new Scene(this);
  unregisterMethod("dispose", scene);
  //create a camera path and add some key frames:
  //key frames can be added at runtime with keys [j..n]
  scene.loadConfig();
  buttonFont = loadFont("FreeSans-16.vlw");
  toggleButton = new Button2D(new PVector(10, 7), buttonFont, "");
  toggleButton.iFrame.setClickBinding(LEFT, 1, "action");
  toggleButton.iFrame.setFrontShape("frontShape");
  buttons = new ArrayList<Button2D>();
  for (int i=0; i<3; ++i)
    buttons.add(new ClickButton(new PVector(10, toggleButton.height*(i+1) + 7*(i+2)), buttonFont, String.valueOf(i+1), i+1));
}

void draw() {
  background(0);
  fill(204, 102, 0, 150);
  scene.drawTorusSolenoid();
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
