/**
 * Solar System.
 * by Juan Manuel Fl??rez Fandi??o and Manuel L. Molano Saavedra.
 * 
 * 
 * This example illustrates how to create some figures (planets) by using textures and making a lighting model of the Solar System.
 *
 * The Copyright of each Planet's textures is on James Hastings-Trew.
 * Extra information on:  http://planetpixelemporium.com/planets.html
 *
 * It is suppose that you can control the speed of the simulation or even reverse it throught P5 control.
 */

//TODO partially broken. Fix me!
import controlP5.*;
import remixlab.proscene.*;

static float SIMULATION_SPEED = 1;

ControlP5 cp5;
Scene scene;

SolarSystem ss;

PImage starfield;

void setup() {
  size(800, 600, P3D);
  
  scene = new Scene(this);
  scene.setRadius(3000);
  
  ss = new SolarSystem();
  
  //It puts the background image
  starfield = loadImage("starfield.jpg");
  
  // Controls of P5
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  Group controls = cp5.addGroup("Controls")
    .setPosition(20, 50)
    .setBackgroundColor(color(255,50,0))
    .setSize(200, 30);
    
  cp5.addSlider("SIMULATION_SPEED")
    .setPosition(0, 0)
    .setRange(-3.0, 3.0)
    .setNumberOfTickMarks(61)
    .setGroup(controls);
}

void draw() {
  background(0);
  scene.beginScreenDrawing();
  image(starfield, 0, 0, width, height);
  scene.endScreenDrawing();
  
  ss.draw();
  
  scene.beginScreenDrawing();
  cp5.draw();
  scene.endScreenDrawing();
}

class TestCanvas extends Canvas {
  
  float n;
  float a;
  
  public void setup(PApplet p) {
    println("starting a test canvas.");
    n = 1;
  }
  public void draw(PGraphics p) {
    n += 0.01;
    p.ellipseMode(CENTER);
    p.fill(lerpColor(color(0,100,200),color(0,200,100),map(sin(n),-1,1,0,1)));
    p.rect(0,0,200,200);
    p.fill(255,150);
    a+=0.01;
    ellipse(100,100,abs(sin(a)*150),abs(sin(a)*150));
    ellipse(40,40,abs(sin(a+0.5)*50),abs(sin(a+0.5)*50));
    ellipse(60,140,abs(cos(a)*80),abs(cos(a)*80));
  }
}