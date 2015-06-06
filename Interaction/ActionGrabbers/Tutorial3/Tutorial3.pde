/**
 * Application Control.
 * by Jean Pierre Charalambos.
 * 
 * This demo controls the shape and color of the scene torus using and a custom mouse agent.
 * 
 * Click and drag the ellipse with the left mouse to control the torus color and shape.
 * Press ' ' (the spacebar) to toggle the application canvas aid.
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.bias.core.*;
import remixlab.bias.event.*;
import remixlab.bias.event.shortcut.*;
import remixlab.bias.branch.*;
import remixlab.dandelion.geom.*;
import remixlab.dandelion.agent.*;
import remixlab.proscene.*;

public enum GlobalAction {
  CHANGE_COLOR, 
  CHANGE_SHAPE, 
  CHANGE_SHAPE_COLOR, 
  RED, 
  BLUE
}

public enum KeyAction implements Action<GlobalAction> {
  RED(GlobalAction.RED), 
  BLUE(GlobalAction.BLUE);

  @Override
  public GlobalAction referenceAction() {
    return act;
  }

  @Override
  public String description() {
    return "A simple click action";
  }

  GlobalAction  act;

  KeyAction(GlobalAction a) {
    act = a;
  }
}

public enum ClickAction implements Action<GlobalAction> {
  CHANGE_COLOR(GlobalAction.CHANGE_COLOR);

  @Override
  public GlobalAction referenceAction() {
    return act;
  }

  @Override
  public String description() {
    return "A simple click action";
  }

  GlobalAction  act;

  ClickAction(GlobalAction a) {
    act = a;
  }
}

public enum MotionAction implements Action<GlobalAction> {
  CHANGE_SHAPE(GlobalAction.CHANGE_SHAPE);

  @Override
  public GlobalAction referenceAction() {
    return act;
  }

  @Override
  public String description() {
    return "A simple motion action";
  }

  GlobalAction  act;

  MotionAction(GlobalAction a) {
    act = a; //<>//
  }
}

public class CustomKeyboardBranch extends KeyboardBranch<GlobalAction, KeyAction> {
  public CustomKeyboardBranch(KeyboardAgent keyAgent, String n) {
    super(keyAgent, n);
    setBinding('b', KeyAction.BLUE); //<>//
    setBinding('r', KeyAction.RED);
  }
}

public class CustomMouseBranch extends MotionBranch<GlobalAction, MotionAction, ClickAction> {
  public CustomMouseBranch(MouseAgent parent, String n) {
    super(parent, n);
    setClickBinding(LEFT, 1, ClickAction.CHANGE_COLOR);
    setMotionBinding(MouseAgent.RIGHT_ID, MotionAction.CHANGE_SHAPE);
    //clickProfile().setBinding(new ClickShortcut(LEFT, 1), ClickAction.CHANGE_COLOR);
    //motionProfile().setBinding(new MotionShortcut(RIGHT), MotionAction.CHANGE_SHAPE);
  }
}

// Final tutorial would make much more sense when having lots of actions and multiple agents
public class ActionGrabberEllipse extends InteractiveGrabberObject<GlobalAction> {
  PGraphics pg;
  public float radiusX, radiusY;
  public PVector center;
  public color colour;

  public ActionGrabberEllipse(PGraphics p) {
    pg = p;
    setColor();
    setPosition();
  }

  public ActionGrabberEllipse(PGraphics p, PVector c, float r) {
    pg = p;
    radiusX = r;
    radiusY = r;
    center = c;    
    setColor();
  }

  public void setColor() {
    setColor(color(random(0, 255), random(0, 255), random(0, 255), 125));
  }

  public void setColor(color myC) {
    colour = myC;
  }

  public void setPosition(float x, float y) {
    setPositionAndRadii(new PVector(x, y), radiusX, radiusY);
  }

  public void setPositionAndRadii(PVector p, float rx, float ry) {
    center = p;
    radiusX = rx;
    radiusY = ry;
  }

  public void setPosition() {
    float maxRadius = 50;
    float low = maxRadius;
    float highX = w - maxRadius;
    float highY = h - maxRadius;
    float r = random(20, maxRadius);
    setPositionAndRadii(new PVector(random(low, highX), random(low, highY)), r, r);
  }

  public void draw() {
    draw(colour);
  }

  public void draw(int c) {
    pg.pushStyle();
    pg.stroke(c);
    pg.fill(c);
    pg.ellipse(center.x, center.y, 2*radiusX, 2*radiusY);
    pg.popStyle();
  }

  @Override
  public boolean checkIfGrabsInput(DOF2Event event) {
    Vec vec = ctrlScene.eye().unprojectedCoordinatesOf(new Vec(event.x(), event.y()));
    float x = vec.x();
    float y = vec.y();    
    return(pow((x - center.x), 2)/pow(radiusX, 2) + pow((y - center.y), 2)/pow(radiusY, 2) <= 1);
  }
  
  @Override
  public void performInteraction(DOF2Event event) {
    switch(referenceAction()) {
    case CHANGE_SHAPE:
      radiusX += event.dx();
      radiusY += event.dy();
      break;
    default:
      println("Action not implemented");
      break;
    }
  }
  
  @Override
  public void performInteraction(DOF1Event event) {
    switch(referenceAction()) {
    case CHANGE_SHAPE:
      radiusX += event.dx()*5;
      break;
    default:
      println("Action not implemented");
      break;
    }
  }

  @Override
  public void performInteraction(ClickEvent event) {
    switch (referenceAction()) {
    case CHANGE_COLOR:
      colour = color(color(random(0, 255), random(0, 255), random(0, 255), 125));
      break;
    default:
      println("Action not implemented");
      break;
    }
  }

  @Override
  public void performInteraction(KeyboardEvent event) {
    switch (referenceAction()) {
    case RED:
      colour = color(255, 0, 0);
      break;
    case BLUE:
      colour = color(0, 0, 255);
      break;
    default:
      println("Action not implemented");
      break;
    }
  }
}

int                w        = 200;
int                h        = 120;
int                oX      = 640 - w;
int                oY      = 360 - h;
PGraphics          ctrlCanvas;
Scene              ctrlScene;
CustomMouseBranch  mouseBranch;
CustomKeyboardBranch keyBranch;
public PShape      eShape;
ActionGrabberEllipse      e;
PGraphics          canvas;
Scene              scene;
boolean            showAid  = true;

public void setup() {
  size(640, 360, P2D);

  canvas = createGraphics(640, 360, P3D);  
  scene = new Scene(this, canvas);

  ctrlCanvas = createGraphics(w, h, P2D);
  ctrlScene = new Scene(this, ctrlCanvas, oX, oY);
  mouseBranch = new CustomMouseBranch(ctrlScene.mouseAgent(), "my_mouse");
  mouseBranch.clickProfile().setBinding(new ClickShortcut(RIGHT, 1), ClickAction.CHANGE_COLOR);
  //mouseBranch.profile().setBinding(new MotionShortcut(MouseAgent.WHEEL_ID), MotionAction.CHANGE_SHAPE);
  mouseBranch.setMotionBinding(MouseAgent.WHEEL_ID, MotionAction.CHANGE_SHAPE);
  
  keyBranch = new CustomKeyboardBranch(ctrlScene.keyboardAgent(), "my_keyboard");
  ctrlScene.setAxesVisualHint(false);
  ctrlScene.setGridVisualHint(false);

  e = new ActionGrabberEllipse(ctrlCanvas, new PVector(0, 0), 30);
  ctrlScene.mouseAgent().addGrabber(e, mouseBranch);
  ctrlScene.keyboardAgent().addGrabber(e, keyBranch);
  ctrlScene.keyboardAgent().setDefaultGrabber(e);  
}

public void draw() {
  handleAgents();
  canvas.beginDraw();
  scene.beginDraw();
  canvas.background(255);
  canvas.fill(e.colour);
  scene.drawTorusSolenoid((int) map(PI * e.radiusX * e.radiusY, 20, w * h, 2, 50), 100, e.radiusY, e.radiusX);
  scene.endDraw();
  canvas.endDraw();
  image(canvas, scene.originCorner().x(), scene.originCorner().y());

  if (showAid) {
    ctrlCanvas.beginDraw();
    ctrlScene.beginDraw();
    ctrlCanvas.background(125, 125, 125, 125);
 
    if ( ctrlScene.mouseAgent().isInputGrabber(e) )
      e.draw(color(red(e.colour), green(e.colour), blue(e.colour)));
    else
      e.draw();
    
    ctrlScene.endDraw();
    ctrlCanvas.endDraw();
    image(ctrlCanvas, ctrlScene.originCorner().x(), ctrlScene.originCorner().y());
  }
}

void handleAgents() {
  scene.enableMotionAgent();
  ctrlScene.disableMotionAgent();
  scene.enableKeyboardAgent();
  ctrlScene.disableKeyboardAgent();
  if ((oX < mouseX) && (oY < mouseY) && showAid) {
    scene.disableMotionAgent();
    ctrlScene.enableMotionAgent();
    scene.disableKeyboardAgent();
    ctrlScene.enableKeyboardAgent();
  }
}

public void keyPressed() {
  if (key == ' ')
    showAid = !showAid;
  if (key == 'x' ) {
    if (  ctrlScene.grabsInput(ctrlScene.keyboardAgent()) )
      println("scene is input grabber");
    if ( e.grabsInput(ctrlScene.keyboardAgent()) )
      println("ellipse is input grabber");
  }
}