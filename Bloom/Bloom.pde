//Made by Ivan Castellanos

import remixlab.proscene.*;

PShader BloomShader, XConvShader, YConvShader;
PGraphics BloomGraphics, SrcGraphics, XConvGraphics, YConvGraphics;
Scene SrcScene;
boolean original;
color cols[];
float posns[], kernel[];
InteractiveModelFrame[] models;
int numCubes;

public void setup() {
  size(700, 700, P3D);
  colorMode(HSB, 255);
  numCubes = 100;
  cols = new color[numCubes];
  posns = new float[numCubes * 3];
  buildKernel(4.0);
  
  for (int i = 0; i < numCubes; i++){
    posns[3*i]=random(-1000, 1000);
    posns[3*i+1]=random(-1000, 1000);
    posns[3*i+2]=random(-1000, 1000);
    cols[i]= color(255 * i / 100.0, 255, 255, 255);
  }
  
  SrcGraphics = createGraphics(width, height, P3D);
  SrcScene = new Scene(this, SrcGraphics);
  SrcScene.setRadius(1000);
  SrcScene.showAll();
  models = new InteractiveModelFrame[numCubes];
  
  for (int i = 0; i < models.length; i++) {
    models[i] = new InteractiveModelFrame(SrcScene, Shape(i));
    models[i].translate(posns[3*i], posns[3*i+1], posns[3*i+2]);
    pushStyle();
    models[i].shape().setFill(cols[i]);
    popStyle();
  }
  
  XConvShader = loadShader("convfrag.glsl","convvert.glsl");
  XConvShader.set("imageIncrement", 0.002953125, 0.0);
  XConvShader.set("kernel", kernel);
  XConvShader.set("resolution", width, height);
  XConvGraphics = createGraphics(width, height, P3D);
  XConvGraphics.shader(XConvShader);
  
  YConvShader = loadShader("convfrag.glsl","convvert.glsl");
  YConvShader.set("imageIncrement", 0.0, 0.002953125);
  YConvShader.set("kernel", kernel);
  YConvShader.set("resolution", width, height);
  YConvGraphics = createGraphics(width, height, P3D);
  YConvGraphics.shader(YConvShader);
  
  BloomShader = loadShader("bloom.glsl");
  BloomGraphics = createGraphics(width, height, P3D);
  BloomGraphics.shader(BloomShader);
   
  frameRate(1000);
}

public void draw() {
  background(0);
  PGraphics pg = SrcGraphics;
  
  for (int i = 0; i < models.length; i++) 
    if (SrcScene.grabsAnyAgentInput(models[i]))
      {
        models[i].shape().setFill(color(255, 255, 255, 255));
      }
    else {
      pushStyle();
      colorMode(HSB, 255);
      models[i].shape().setFill(cols[i]);
      popStyle();
    }
    
  pg.beginDraw();
  SrcScene.beginDraw();
  pg.background(0);
  pg.lights();
  SrcScene.drawModels();
  SrcScene.endDraw();
  pg.endDraw();
  
  XConvGraphics.beginDraw();
  XConvShader.set("readTex", SrcScene.pg());
  XConvGraphics.image(pg, 0, 0);
  XConvGraphics.endDraw();
    
  YConvGraphics.beginDraw();
  YConvShader.set("readTex", XConvGraphics);
  YConvGraphics.image(pg, 0, 0);
  YConvGraphics.endDraw();    
    
  BloomGraphics.beginDraw();
  BloomShader.set("nuevoTex", YConvGraphics);
  BloomGraphics.image(pg, 0, 0);
  BloomGraphics.endDraw();    
  
  if (original) {
    image(SrcScene.pg(), 0, 0);
  } else {     
    image(BloomGraphics, 0, 0);
  }
}

float gauss(float x, float sigma)
{
  return exp( -( x * x ) / ( 2.0 * sigma * sigma ) );
}

void buildKernel(float sigma)
{
  int kernelSize = 2 * ceil( sigma * 3.0 ) + 1;
  kernel = new float[kernelSize];
  float halfWidth = ( kernelSize - 1 ) * 0.5;
  float sum = 0.0;
  for (int i = 0; i < kernelSize; ++i )
  {
    kernel[i]=gauss(i - halfWidth, sigma);
    sum += kernel[i];
  }      
  for (int i = 0; i < kernelSize; ++i )
  {
    kernel[ i ] /= sum;
  }
}

PShape Shape(int n) {
  PShape fig;
  if (n%2 == 0)
    fig = createShape(BOX, 60);
  else
    fig = createShape(SPHERE, 30);
  fig.setStroke(255);
  return fig;
}

void keyPressed() {
  original = !original;
}
