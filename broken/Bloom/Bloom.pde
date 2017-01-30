/**
 * Bloom.
 * by Ivan Castellanos and Jean Pierre Charalambos.
 *
 * This example illustrates how to attach a PShape to an interactive frame.
 * PShapes attached to interactive frames can then be automatically picked
 * and easily drawn.
 *
 * Press 'h' to display the key shortcuts and mouse bindings in the console.
 */

import remixlab.proscene.*;

PShader bloomShader, xConvShader, yConvShader;
PGraphics bloomGraphics, srcGraphics, xConvGraphics, yConvGraphics;
Scene srcScene;
boolean original;
float posns[], kernel[];
InteractiveFrame[] frames;
int numCubes;

public void setup() {
  size(900, 900, P3D);
  colorMode(HSB, 255);
  numCubes = 100;
  posns = new float[numCubes * 3];
  buildKernel(4.0);
  
  for (int i = 0; i < numCubes; i++){
    posns[3*i]=random(-1000, 1000);
    posns[3*i+1]=random(-1000, 1000);
    posns[3*i+2]=random(-1000, 1000);
  }
  
  srcGraphics = createGraphics(width, height, P3D);
  srcScene = new Scene(this, srcGraphics);
  srcScene.setRadius(1000);
  srcScene.showAll();
  frames = new InteractiveFrame[numCubes];
  
  for (int i = 0; i < frames.length; i++) {
    frames[i] = new InteractiveFrame(srcScene, Shape(i));
    frames[i].translate(posns[3*i], posns[3*i+1], posns[3*i+2]);
  }
  
  xConvShader = loadShader("convfrag.glsl","convvert.glsl");
  xConvShader.set("imageIncrement", 0.002953125, 0.0);
  xConvShader.set("kernel", kernel);
  xConvShader.set("resolution", width, height);
  xConvGraphics = createGraphics(width, height, P3D);
  xConvGraphics.shader(xConvShader);
  
  yConvShader = loadShader("convfrag.glsl","convvert.glsl");
  yConvShader.set("imageIncrement", 0.0, 0.002953125);
  yConvShader.set("kernel", kernel);
  yConvShader.set("resolution", width, height);
  yConvGraphics = createGraphics(width, height, P3D);
  yConvGraphics.shader(yConvShader);
  
  bloomShader = loadShader("bloom.glsl");
  bloomGraphics = createGraphics(width, height, P3D);
  bloomGraphics.shader(bloomShader);
   
  frameRate(1000);
}

public void draw() {
  background(0);
  srcScene.beginDraw();
  srcScene.pg().background(0);
  srcScene.pg().lights();
  srcScene.drawFrames();
  srcScene.endDraw();
  
  xConvGraphics.beginDraw();
  xConvShader.set("readTex", srcScene.pg());
  xConvGraphics.image(srcScene.pg(), 0, 0);
  xConvGraphics.endDraw();
    
  yConvGraphics.beginDraw();
  yConvShader.set("readTex", xConvGraphics);
  yConvGraphics.image(srcScene.pg(), 0, 0);
  yConvGraphics.endDraw();    
    
  bloomGraphics.beginDraw();
  bloomShader.set("nuevoTex", yConvGraphics);
  bloomGraphics.image(srcScene.pg(), 0, 0);
  bloomGraphics.endDraw();    
  
  if (original)
    srcScene.display();
  else
    srcScene.display(bloomGraphics);
}

float gauss(float x, float sigma) {
  return exp( -( x * x ) / ( 2.0 * sigma * sigma ) );
}

void buildKernel(float sigma) {
  int kernelSize = 2 * ceil( sigma * 3.0 ) + 1;
  kernel = new float[kernelSize];
  float halfWidth = ( kernelSize - 1 ) * 0.5;
  float sum = 0.0;
  for (int i = 0; i < kernelSize; ++i ) {
    kernel[i]=gauss(i - halfWidth, sigma);
    sum += kernel[i];
  }
  for (int i = 0; i < kernelSize; ++i )
    kernel[ i ] /= sum;
}

PShape Shape(int n) {
  PShape fig;
  if (n%2 == 0)
    fig = createShape(BOX, 60);
  else
    fig = createShape(SPHERE, 30);
  fig.setStroke(255);
  fig.setFill(color(random(0,255), random(0,255), random(0,255)));
  return fig;
}

void keyPressed() {
  original = !original;
}
