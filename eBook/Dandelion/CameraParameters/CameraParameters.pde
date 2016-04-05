/**
 * Camera Prameters.
 * by Camilo Rodriguez and Jean Pierre Charalambos.
 * 
 * La idea es ilustrar los parametros de dandelion (en las clases: Eye, Camera y Window)
 * que contralan el volumen de vista: sceneRadius(), sceneCenter() y los siguientes que
 * son solo de la camera: type(), zClippingCoefficient() y zNearCoefficient()
 * 
 * En este ejemplo se ilustran el sceneRadius() y el camera.type(). La tarea es completar
 * (o crear otro sketch) para ilustrar el resto de parametros de manera interactiva. Es
 * decir, empleando iFrames en la scene de control (como se hace aca con el circulo rojo
 * de la ctrlScene). Recomendación: empezar con el sceneCenter sobre este ejemplo y
 * adaptar este ejemplo para el caso 2d.
 * 
 * Press 'e' at the mainScene to change the camera type
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;
import remixlab.bias.event.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;
import remixlab.dandelion.constraint.*;

Scene mainScene, v1Scene, v2Scene, v3Scene, ctrlScene;
PGraphics mainCanvas, v1Canvas, v2Canvas, v3Canvas, ctrlCanvas;
EyeConstraint v1Constraint, v2Constraint, v3Constraint;
InteractiveFrame e;
float radius = 200;
int w = 400, h=400;

void setup() {
  //size(3*w, 3*h, P2D);
  // use 3*w for width and 3*h for height:
  size(1200, 1200, P2D);

  mainCanvas = createGraphics(2*w, 2*h, P3D);
  mainScene = new Scene(this, mainCanvas);
  mainScene.setRadius(radius);
  mainScene.showAll();
  
  v1Canvas = createGraphics(w, h, P3D);
  v1Scene = new Scene(this, v1Canvas, 0, 2*h);
  v1Scene.camera().setType(Camera.Type.ORTHOGRAPHIC);
  v1Scene.setRadius(2*radius);
  v1Scene.camera().setPosition(400,0,0);
  v1Scene.camera().lookAt(0,0,0);
  v1Scene.showAll();
  v1Constraint = new EyeConstraint(v1Scene.camera());
  v1Constraint.setTranslationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(0.0f, 0.0f, 1.0f));
  v1Constraint.setRotationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(0.0f, 0.0f, 1.0f));
  v1Scene.camera().frame().setConstraint(v1Constraint);
  
  v2Canvas = createGraphics(w, h, P3D);
  v2Scene = new Scene(this, v2Canvas, w, 2*h);
  v2Scene.camera().setType(Camera.Type.ORTHOGRAPHIC);
  v2Scene.setRadius(2*radius);
  v2Scene.camera().setPosition(0,400,0);
  v2Scene.camera().lookAt(0,0,0);
  v2Scene.showAll();
  v2Constraint = new EyeConstraint(v2Scene.camera());
  v2Constraint.setTranslationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(0.0f, 0.0f, 1.0f));
  v2Constraint.setRotationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(0.0f, 0.0f, 1.0f));
  v2Scene.camera().frame().setConstraint(v2Constraint);
  
  v3Canvas = createGraphics(w, h, P3D);
  v3Scene = new Scene(this, v3Canvas, 2*w, 2*h);
  v3Scene.camera().setType(Camera.Type.ORTHOGRAPHIC);
  v3Scene.setRadius(2*radius);
  v3Scene.camera().setPosition(0,0,400);
  v3Scene.camera().lookAt(0,0,0);
  v3Scene.showAll();
  v3Constraint = new EyeConstraint(v3Scene.camera());
  v3Constraint.setTranslationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(0.0f, 0.0f, 1.0f));
  v3Constraint.setRotationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(0.0f, 0.0f, 1.0f));
  v3Scene.camera().frame().setConstraint(v3Constraint);
  
  ctrlCanvas = createGraphics(w, 2*h, P2D);
  ctrlScene = new Scene(this, ctrlCanvas, 2*w, 0);
  ctrlScene.setRadius(3*radius);
  ctrlScene.showAll();
 
  e = new InteractiveFrame(ctrlScene, this, "drawCircle");
  e.removeBindings();
  e.setMotionBinding(this, MouseAgent.WHEEL_ID, "changeRadius");
}

public void mainDrawing(Scene s) {
  PGraphics p = s.pg();
  p.background(0);
  p.noStroke();
  p.fill(0, 255, 0);
  p.box(200);
}

void auxDrawing(Scene s) {
  mainDrawing(s);    
  s.pg().pushStyle();
  s.pg().stroke(255, 255, 0);
  s.pg().fill(255, 255, 0, 160);
  s.drawEye(mainScene.camera());
  s.pg().noStroke();
  s.pg().fill(255, 0, 0, 160);
  s.pg().sphere(mainScene.camera().sceneRadius());
  s.pg().popStyle();
}

void drawView(Scene scn) {
  PGraphics cnvs = scn.pg();
  cnvs.beginDraw();
  scn.beginDraw();
  auxDrawing(scn);
  scn.endDraw();
  cnvs.endDraw();
  image(cnvs, scn.originCorner().x(), scn.originCorner().y());
}

void draw() {
  handleMouse();
  mainCanvas.beginDraw();
  mainScene.beginDraw();
  mainDrawing(mainScene);
  mainScene.endDraw();
  mainCanvas.endDraw();
  image(mainCanvas, 0, 0);
  
  drawView(v1Scene);
  drawView(v2Scene);
  drawView(v3Scene);
  
  ctrlCanvas.beginDraw();
  ctrlScene.beginDraw();
  ctrlCanvas.background(125, 125, 125, 125);
  ctrlCanvas.fill(150, 0, 0);
  ctrlScene.drawFrames();
  ctrlScene.endDraw();
  ctrlCanvas.endDraw();
  image(ctrlCanvas, ctrlScene.originCorner().x(), ctrlScene.originCorner().y());
}

public void drawCircle(PGraphics pg) {
  pg.ellipse(0, 0, 2 * radius, 2 * radius);
}

public void changeRadius(InteractiveFrame frame, DOF1Event event) {
  frame.scale(event);
  mainScene.setRadius(radius * frame.scaling());
  mainScene.showAll();
}

void handleMouse() {
  if (0 <= mouseX && mouseX < 2*w && 0 <= mouseY && mouseY < 2*h) {
    updateAgents(mainScene);
    return;
  }
  if (0 <= mouseX && mouseX < w && 2*h <= mouseY && mouseY < 3*h) {
    updateAgents(v1Scene);
    return;
  }
  if (w <= mouseX && mouseX < 2*w && 2*h <= mouseY && mouseY < 3*h) {
    updateAgents(v2Scene);
    return;
  }
  if (2*w <= mouseX && mouseX < 3*w && 2*h <= mouseY && mouseY < 3*h) {
    updateAgents(v3Scene);
    return;
  }
  if (2*w <= mouseX && mouseX < 3*w && 0 <= mouseY && mouseY < 2*h) {
    updateAgents(ctrlScene);
    return;
  }
}

void updateAgents(Scene scn) {
  scn.enableMotionAgent();
  scn.enableKeyboardAgent();
  if(scn != mainScene) {
    mainScene.disableMotionAgent();
    mainScene.disableKeyboardAgent();
  }
  if(scn != v1Scene) {
    v1Scene.disableMotionAgent();
    v1Scene.disableKeyboardAgent();
  }
  if(scn != v2Scene) {
    v2Scene.disableMotionAgent();
    v2Scene.disableKeyboardAgent();
  }
  if(scn != v3Scene) {
    v3Scene.disableMotionAgent();
    v3Scene.disableKeyboardAgent();
  }
  if(scn != ctrlScene) {
    ctrlScene.disableMotionAgent();
    ctrlScene.disableKeyboardAgent();
  }
}
