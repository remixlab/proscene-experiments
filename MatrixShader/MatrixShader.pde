/**
 * Matrix Shader
 * by Jean Pierre Charalambos.
 *
 * This examples shows how to bypass Processing matrix handling by using
 * Proscene's own matrix stack. Really useful if you plan to use Proscene
 * directly with jogl.
 *
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import proscene.processing.*;
import proscene.input.*;
import proscene.input.event.*;
import proscene.core.*;
import proscene.primitives.*;

Scene scene;
Node iFrame;
PShader prosceneShader;
Matrix pmv;
PMatrix3D pmatrix = new PMatrix3D( );

void setup() {
  size(640, 360, P3D);
  prosceneShader = loadShader("FrameFrag.glsl", "FrameVert_pmv.glsl");
  scene = new Scene(this);
  scene.setMatrixHandler(new MatrixHandler(scene));

  Node eye = new InteractiveNode(scene);

  scene.setEye(eye);
  scene.setFieldOfView((float) Math.PI / 3);
  scene.setDefaultNode(eye);
  scene.fitBall();

  iFrame = new InteractiveNode(scene);
  iFrame.setPrecision(Node.Precision.ADAPTIVE);
  iFrame.setPrecisionThreshold(scene.radius()/4);
  iFrame.translate(new Vector(30, 30, 0));
}

void draw() {
  background(0);
  //discard Processing matrices
  resetMatrix();
  //set initial model-view and projection proscene matrices
  setUniforms();
  fill(204, 102, 0, 150);
  scene.drawTorusSolenoid();
  scene.pushModelView();
  scene.applyModelView(iFrame.matrix());
  //iFrame.applyTransformation();//also possible here
  //model-view changed:
  setUniforms();
  if (scene.mouseAgent().defaultGrabber() == iFrame) {
    fill(0, 255, 255);
    scene.drawTorusSolenoid();
  } else if (iFrame.grabsInput(scene.mouseAgent())) {
    fill(255, 0, 0);
    scene.drawTorusSolenoid();
  } else {
    fill(0, 0, 255, 150);
    scene.drawTorusSolenoid();
  } 
  scene.popModelView();
}

public void keyPressed() {
  if ( key == 'i')
    scene.mouseAgent().shiftDefaultGrabber(iFrame, (Node)scene.eye());
}

//Whenever the model-view (or projection) matrices changes
// we need to update the shader:
void setUniforms() {
  shader(prosceneShader);
  pmv = Matrix.multiply(scene.projection(), scene.modelView());
  pmatrix.set(pmv.get(new float[16]));
  prosceneShader.set("proscene_transform", pmatrix);
}

public class InteractiveNode extends Node {
  public InteractiveNode(Graph graph) {
    super(graph);
  }

  // this one gotta be overridden because we want a copied frame (e.g., line 100 above, i.e.,
  // scene.eye().get()) to have the same behavior as its original.
  protected InteractiveNode(Graph otherGraph, InteractiveNode otherNode) {
    super(otherGraph, otherNode);
  }

  @Override
  public InteractiveNode get() {
    return new InteractiveNode(this.graph(), this);
  }

  // behavior is here :P
  @Override
  public void interact(MotionEvent event) {
    if (event.shortcut().matches(MouseAgent.RIGHT))
      translate(event);
    else if (event.shortcut().matches(MouseAgent.LEFT))
      rotate(event);
    else if (event.shortcut().matches(MouseAgent.WHEEL))
      if (isEye() && graph().is3D())
        translateZ(event);
      else
        scale(event);
  }

  @Override
  public void interact(TapEvent event) {
    if (event.shortcut().matches(MouseAgent.CENTER_TAP2))
      center();
    else if (event.shortcut().matches(MouseAgent.RIGHT_TAP))
      align();
  }
}