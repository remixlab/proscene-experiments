/**
 * Menelaus Prisme version PROSCENE 3.0 fait le 24/01/2016
 * by Jacques Maire (http://www.alcys.com/)
 * 
 * Part of proscene classroom: http://www.openprocessing.org/classroom/1158
 * Check also the collection: http://www.openprocessing.org/collection/1438
 *
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;
import remixlab.dandelion.constraint.*;

Scene scene;
Arbre arbre;
PFont font;
float tempo;

void setup() {
  size(800, 800, P3D);
  scene=new Scene(this);
  scene.setRadius(260);
  scene.showAll();
  scene.setGridVisualHint(false);
  font=loadFont("AdobeArabic-Regular-24.vlw");  
  textFont(font);
  arbre=new Arbre();
}

void draw() { 
  background(0,0,100);
   tempo=1.0/2000.0*(millis()%2000);
 //
  lights();
  ambientLight(150, 102, 102); 
  //
  scene.drawFrames();
  arbre.CalculDernierTriangle();
  arbre.displayText();
}