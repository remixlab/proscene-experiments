import remixlab.proscene.*;

PShader depthPShader, dofPShader;
PGraphics depthPGraphics, srcPGraphics, dofPGraphics;
Scene depthScene, srcScene;
boolean depth;

public void setup() {
  size(800, 400, P2D);

  srcPGraphics = createGraphics(width, height, P3D);
  srcScene = new Scene(this, srcPGraphics);
  srcScene.setRadius(1000);
  srcScene.showAll();

  depthPShader = loadShader("colorfrag.glsl");
  depthPGraphics = createGraphics(width, height, P3D);
  depthPGraphics.smooth(8);
  depthPGraphics.shader(depthPShader);
  depthScene = new Scene(this, depthPGraphics);
  depthScene.setRadius(1000);
  depthScene.showAll();
  depthScene.setCamera(srcScene.camera());
  depthScene.disableMouseAgent();
  depthScene.disableKeyboardAgent();
  depthPShader.set("maxDepth", depthScene.radius()*2);

  dofPShader = loadShader("dof.glsl");  
  dofPGraphics = createGraphics(width, height, P3D);
  dofPGraphics.shader(dofPShader);
  dofPShader.set("aspect", width / (float) height);
  dofPShader.set("maxBlur", 0.015);  
  dofPShader.set("aperture", 0.02);

  frameRate(1000);
}

public void draw() {
  background(0);
  drawGeometry(srcScene, true);
  drawGeometry(depthScene, false);

  if (depth) {    
    image(depthScene.pg(), 0, 0);
  } else {   
    dofPGraphics.beginDraw();
    dofPShader.set("focus", map(mouseX, 0, width, -0.5f, 1.5f));    
    dofPShader.set("tDepth", depthPGraphics);
    dofPGraphics.image(srcPGraphics, 0, 0);
    dofPGraphics.endDraw();    
    image(dofPGraphics, 0, 0);
  }
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

void keyPressed() {
  depth = !depth;
}

