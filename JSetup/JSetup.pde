/**
 * Este ejemplo muestra los pasos minimos que se necesitan para crear una escena interactiva
 * que puede reaccionar al mouse y al keyboard de Processing. Se puede pensar en una libreria
 * proscene_tiny que comprende todos los paquetes de proscene, menos el de remixlab.bias.ext.*.
 * y el de remixlab.proscene.*. (observese que aca no se emplean). Asimismo, se tendria la
 * libreria proscene_tiny.js, como el port de proscene_tiny empleando gwt (y la extension que
 * hace posible emplear la api como en cualquier libreria js).
 *
 * Bajo el supuesto de que la api de proscene_tiny.js es de libre acceso en js, entonces la
 * estructura de paquetes de proscene para un target dado (como p5.js, webgl o three.js)
 * seria:
 *
 * proscene_tiny.js + target.js, donde target.js estaria compuesto al menos por:
 * TargetKeyAgent, TargetMouseAgent, TargetMatrixHelper y TargetScene. Observe que target.js
 * es constante (para cualquier app en la aplicacion), pero que se debe escribir a mano
 * (una sola vez).
 *
 * Entonces, finalmente, la estructura de una app cualquiera (como la de este ejemplo), seria:
 *
 * proscene_tiny.js (port empleando gwt) + target.js (port manual que se realiza una solo vez
 * para cada plataforma) + las fuentes del ejemplo, en este caso: CustomScene,CustomGrabberFrame
 * y la clase principal JSetup.
 *
 * El ejercicio que le propongo a partir de las anteriores observaciones, es el de portar este
 * ejemplo para el target de p5.js. Si todo va bien, luego podriamos ensayar el target de
 * webgl/three.js.
 *
 * 'i' -> shifts default grabber
 * 's' -> interpolates to fit scene
 * 'a' -> adds KeyFrame to path 1
 * 'r' -> removes path 1
 * '1' -> plays path 1
 * 'left' & 'right' arrows -> rotates z
 */

import remixlab.proscene.*;
import remixlab.bias.core.*;
import remixlab.bias.event.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;

CustomScene scene;
CustomGrabberFrame gFrame;
//String renderer = P2D;
String renderer = P3D;

void setup() {
  size(640, 360, renderer);    
  scene = new CustomScene(this); 
  gFrame = new CustomGrabberFrame(scene);
  gFrame.setGrabsInputThreshold(scene.radius()/4, true);
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