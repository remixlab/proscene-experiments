/**
 * Projectors
 * by Jean Pierre Charalambos.
 * 
 * This example shows how perspective and orthographic projections work.
 *
 * The book version should do it with the platonic solids see here:
 * https://github.com/jpcarrascal/ProcessingPlatonicSolids.
 *
 * Note that you can interact with everything, even with the eye representation
 * at the auxScene.
 *
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 * Press 'x' and 'y' to change the mini-map eye representation.
 */

import remixlab.dandelion.geom.*;
import remixlab.proscene.*;
import java.util.List;
import java.util.Arrays;

Scene scene, auxScene;
PGraphics canvas, auxCanvas;  
InteractiveFrame frame1, auxFrame1;
InteractiveFrame iFrame;
List<Vec> vertices = Arrays.asList(new Vec(50, -115, 0), new Vec(-70, -50, 0), new Vec(90, -45, 0));

int w = 1200;
int h = 800;
int oW = w/2;
int oH = h/2;
int oX = w - oW;
int oY = h - oH;
boolean showMiniMap  = true;

//Choose one of P3D for a 3D scene, or P2D or JAVA2D for a 2D scene
String renderer = P3D;

void settings() {
  size(w, h, renderer);
}

void setup() {
  canvas = createGraphics(w, h, renderer);
  scene = new Scene(this, canvas);
  frame1 = new InteractiveFrame(scene, this, "frameDrawing");
  frame1.translate(30, 30);

  auxCanvas = createGraphics(oW, oH, renderer);
  auxScene = new Scene(this, auxCanvas, oX, oY);
  auxScene.setVisualHints(0);
  auxScene.setRadius(200);
  auxScene.showAll();

  auxFrame1 = new InteractiveFrame(auxScene);
  auxFrame1.fromFrame(frame1);

  iFrame = new InteractiveFrame(auxScene);
  //to not scale the iFrame on mouse hover uncomment:
  //iFrame.setHighlightingMode(InteractiveFrame.HighlightingMode.NONE);
  iFrame.fromFrame(scene.eyeFrame());
  handleAgents();
}

void draw() {
  handleAgents();
  InteractiveFrame.sync(scene.eyeFrame(), iFrame);
  InteractiveFrame.sync(frame1, auxFrame1);
  canvas.beginDraw();
  scene.beginDraw();
  canvas.background(0);
  scene.drawFrames();
  scene.endDraw();
  canvas.endDraw();
  image(canvas, 0, 0);
  if (showMiniMap) {
    auxCanvas.beginDraw();
    auxScene.beginDraw();
    auxCanvas.background(29, 153, 243);
    auxScene.pg().fill(255, 0, 255, 125);
    auxScene.drawFrames();
    auxScene.drawProjectors(scene.eye(), projectors());
    auxScene.endDraw();
    auxCanvas.endDraw();
    // We retrieve the scene upper left coordinates defined above.
    image(auxCanvas, auxScene.originCorner().x(), auxScene.originCorner().y());
  }
}

void keyPressed() {
  if (key == ' ')
    showMiniMap = !showMiniMap;
  if (key == 'x')
    scene.eyeFrame().setShape("eyeDrawing");
  if (key == 'y')
    //restore the default eye shape found at the iFrame class
    scene.eyeFrame().setShape("drawEye");
}

void frameDrawing(PGraphics pg) {
  pg.fill(random(0, 255), random(0, 255), random(0, 255));
  pg.beginShape(TRIANGLES);
  for(Vec v : vertices)
    pg.vertex(v.x(), v.y());
  pg.endShape();
}

// converts the shape vertices from frame to world 
List<Vec> projectors() {
  List<Vec> worldVertices = new ArrayList<Vec>();
  for(Vec v : vertices)
    worldVertices.add(frame1.inverseCoordinatesOf(v));
  return worldVertices;
}

void eyeDrawing(PGraphics pg) {
  if (auxScene.is3D())
    pg.box(200);
  else {
    pg.pushStyle();
    pg.rectMode(CENTER);
    pg.rect(0, 0, 200, 200);
    pg.popStyle();
  }
}

void handleAgents() {
  scene.enableMotionAgent();
  auxScene.disableMotionAgent();
  scene.enableKeyboardAgent();
  auxScene.disableKeyboardAgent();
  if ((oX < mouseX) && (oY < mouseY) && showMiniMap) {
    scene.disableMotionAgent();
    auxScene.enableMotionAgent();
    scene.disableKeyboardAgent();
    auxScene.enableKeyboardAgent();
  }
}