/**
 * Depth.
 * 
 * This example isolates the depth shader from the DOF example.
 * 
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;

PShader depthShader;
PGraphics depthPGraphics;
Scene depthScene;

public void setup() {
  size(800, 400, P2D);
  depthShader = loadShader("colorfrag.glsl");
  depthPGraphics = createGraphics(width, height, OPENGL);
  depthPGraphics.smooth(8);
  depthPGraphics.shader(depthShader);
  depthScene = new Scene(this, depthPGraphics);
  depthScene.setRadius(1000);
  depthScene.showAll();
  frameRate(1000);
}

public void draw() {
  background(0);
  drawGeometry(depthScene, false);
  depthShader.set("maxDepth", depthScene.radius()*2);
  image(depthScene.pg(), depthScene.originCorner().x(), depthScene.originCorner().y());
  println(frameRate);
}

private void drawGeometry(Scene scene, boolean lights) {
  PGraphics pg = scene.pg();
  pg.beginDraw();
  scene.beginDraw();
  pg.background(0);
  pg.fill(150);
  pg.noStroke();
  if (lights)
    pg.lights();
  pg.pushMatrix();
  for (int i = 0; i < 20; i++) {
    pg.translate(10, 10, 100);
    pg.sphere(50);
  }
  pg.popMatrix();
  scene.endDraw();
  pg.endDraw();
}
