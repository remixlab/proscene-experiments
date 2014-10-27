import remixlab.proscene.*;

PShader XConvShader, YConvShader, colorShader;
PGraphics BloomGraphics, SrcGraphics, colorGraphics, XConvGraphics;
Scene BloomScene, SrcScene, colorScene;
boolean original;
color cols[];
float posns[], kernel[];
int startTime;

public void setup() {
  size(700, 700, P2D);
  colorMode(HSB, 255);
  cols = new color[100];
  posns = new float[300];
  buildKernel(4.0);
  
  for (int i = 0; i<100; i++){
    posns[3*i]=random(-1000, 1000);
    posns[3*i+1]=random(-1000, 1000);
    posns[3*i+2]=random(-1000, 1000);
    cols[i]= color(255 * i / 100.0, 255, 255, 255);
  }
  
  SrcGraphics = createGraphics(width, height, P3D);
  SrcScene = new Scene(this, SrcGraphics);
  SrcScene.setRadius(1000);
  SrcScene.showAll();
  
  colorGraphics = createGraphics(width, height, P3D);
  colorScene = new Scene(this, colorGraphics);
  colorScene.setRadius(1000);
  colorScene.showAll();
  colorScene.setCamera(SrcScene.camera());
  colorScene.disableMouseAgent();
  colorScene.disableKeyboardAgent();
    
  XConvShader = loadShader("bloomfrag.glsl");//,"bloomvert.glsl");
  YConvShader = loadShader("bloomfrag.glsl");//,"bloomvert.glsl");
  
  XConvShader.set("imageIncrement", 0.001953125, 0.0);
  XConvShader.set("kernel", kernel);
  XConvShader.set("resolution", 1024, 1024);
 
  YConvShader.set("imageIncrement", 0.0, 0.001953125);
  YConvShader.set("kernel", kernel);
  YConvShader.set("resolution", 1024, 1024);
  
  XConvGraphics = createGraphics(width, height, P3D);
  XConvGraphics.shader(XConvShader);
  
  BloomGraphics = createGraphics(width, height, P3D);
  BloomGraphics.shader(YConvShader);
  frameRate(1000);
}

public void draw() {
  background(0);
  drawGeometry(SrcScene);
  drawGeometry(colorScene);

  if (original) {
    image(colorScene.pg(), 0, 0);
  } else {   
    BloomGraphics.beginDraw();
    XConvGraphics.beginDraw();
    XConvShader.set("readTex", colorGraphics);
    XConvGraphics.image(colorGraphics, 0, 0);
    YConvShader.set("readTex", XConvGraphics);
    BloomGraphics.image(XConvGraphics, 0, 0);
    XConvGraphics.endDraw();  
    BloomGraphics.endDraw();    
    image(BloomGraphics, 0, 0);
  }
}

private void drawGeometry(Scene scene) {
  PGraphics pg = scene.pg();
  pg.beginDraw();
  scene.beginDraw();
  pg.background(0);
  pg.noStroke();
  pg.lights();
  for (int i = 0; i < 100; i++) {
    pg.pushMatrix();
    pg.fill(cols[i]);
    pg.translate(posns[3*i], posns[3*i+1], posns[3*i+2]);
    pg.box(60);
    pg.popMatrix();
  }
  scene.endDraw();
  pg.endDraw();
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

void keyPressed() {
  original = !original;
}
