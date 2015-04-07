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
import remixlab.bias.branch.*;
import remixlab.bias.branch.profile.*;
import remixlab.dandelion.agent.KeyboardAgent;
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
    act = a;
  }
}

public class CustomKeyboardBranch extends KeyboardBranch<GlobalAction, KeyboardProfile<KeyAction>> {
  public CustomKeyboardBranch(KeyboardAgent parent, String n) {
    super(new KeyboardProfile<KeyAction>(), parent, n);
    keyboardProfile().setBinding('b', KeyAction.BLUE);
    keyboardProfile().setBinding('r', KeyAction.RED);
  }
}

public class CustomMouseBranch extends MotionBranch<GlobalAction, MotionProfile<MotionAction>, ClickProfile<ClickAction>> {
  public CustomMouseBranch(MouseAgent parent, String n) {
    super(new MotionProfile<MotionAction>(), 
    new ClickProfile<ClickAction>(), parent, n);
    clickProfile().setBinding(LEFT, 1, ClickAction.CHANGE_COLOR);
    motionProfile().setBinding(parent.buttonModifiersFix(RIGHT), RIGHT, MotionAction.CHANGE_SHAPE);
  }
}

// Final tutorial would make much more sense when having lots of actions and multiple agents
public class ModelEllipse extends InteractiveModelObject<GlobalAction> {
  float  radiusX  = 30, radiusY = 30;
  int    colour  = color(255, 0, 0);

  public ModelEllipse(Scene scn) {
    super(scn);      
    update();
  }
  
  @Override
  public void performInteraction(DOF1Event event) {
    switch(referenceAction()) {
    case CHANGE_SHAPE:
      radiusX += event.x()*5;
      update();
      break;
    default:
      println("Action not implemented");
      break;
    }
  }

  @Override
  public void performInteraction(DOF2Event event) {
    switch(referenceAction()) {
    case CHANGE_SHAPE:
      radiusX += event.dx();
      radiusY += event.dy();
      update();
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
      update();
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
      update();
      break;
    case BLUE:
      colour = color(0, 0, 255);
      update();
      break;
    default:
      println("Action not implemented");
      break;
    }
  }

  void update() {
    setShape(createShape(ELLIPSE, -radiusX, -radiusY, 2 * radiusX, 2 * radiusY));
    shape().setFill(color(colour));
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
ModelEllipse      e;
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
  mouseBranch.clickProfile().setBinding(ctrlScene.mouseAgent().buttonModifiersFix(RIGHT), RIGHT, 1, ClickAction.CHANGE_COLOR);
  mouseBranch.profile().setBinding(MouseAgent.WHEEL_ID, MotionAction.CHANGE_SHAPE);
  
  keyBranch = new CustomKeyboardBranch(ctrlScene.keyboardAgent(), "my_keyboard");
  ctrlScene.setAxesVisualHint(false);
  ctrlScene.setGridVisualHint(false);

  e = new ModelEllipse(ctrlScene);
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
    ctrlScene.drawModels();
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
