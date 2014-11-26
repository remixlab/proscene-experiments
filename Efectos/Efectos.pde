import remixlab.proscene.*;

PShader NoiseShader, KaleidoShader, RaysShader, DofShader, PixelShader, EdgeShader, colorShader, FxaaShader, HorizontalShader;
PGraphics DrawGraphics, DofGraphics, NoiseGraphics, KaleidoGraphics, RaysGraphics, PixelGraphics, EdgeGraphics, SrcGraphics, colorGraphics, FxaaGraphics, HorizontalGraphics;
Scene SrcScene;
boolean bdepth, brays, bpixel, bedge, bdof, bkaleido, bnoise, bfxaa, bhorizontal;
color cols[];
float posns[];
int startTime;
InteractiveModelFrame[] models;

public void setup() {
  size(700, 700, P3D);
  //colorMode(HSB, 255);
  cols = new color[100];
  posns = new float[300];
  
  for (int i = 0; i<100; i++){
    posns[3*i]=random(-1000, 1000);
    posns[3*i+1]=random(-1000, 1000);
    posns[3*i+2]=random(-1000, 1000);
    cols[i]= color(random(255), random(255), random(255));
  }
  
  SrcGraphics = createGraphics(width, height, P3D);
  
  SrcScene = new Scene(this, SrcGraphics);

  models = new InteractiveModelFrame[100];

  for (int i = 0; i < models.length; i++) {
    models[i] = new InteractiveModelFrame(SrcScene, boxShape());
    models[i].translate(posns[3*i], posns[3*i+1], posns[3*i+2]);
    //Wierdly enough color.HSB breaks picking
    //pushStyle saves picking and enables coloring
    pushStyle();
    colorMode(HSB, 255);
    models[i].shape().setFill(cols[i]);
    popStyle();
  }

  SrcScene.setRadius(1000);
  SrcScene.showAll();
    
  //Declaration of PShader and PGraphics for the efects  
    
  colorShader = loadShader("colorfrag.glsl");
  colorShader.set("maxDepth", SrcScene.radius()*2);
  colorGraphics = createGraphics(width, height, P3D);
  colorGraphics.shader(colorShader);
  
  EdgeShader = loadShader("edge.glsl");
  EdgeGraphics = createGraphics(width, height, P3D);
  EdgeGraphics.shader(EdgeShader);
  EdgeShader.set("aspect", 1.0/width, 1.0/height);
  
  PixelShader = loadShader("pixelate.glsl");
  PixelGraphics = createGraphics(width, height, P3D);
  PixelGraphics.shader(PixelShader);
  PixelShader.set("xPixels", 100.0);
  PixelShader.set("yPixels", 100.0);
  
  RaysShader = loadShader("RaysFrag.glsl");
  RaysGraphics = createGraphics(width, height, P3D);
  RaysGraphics.shader(RaysShader);
  RaysShader.set("lightPositionOnScreen", 0.5, 0.5);
  RaysShader.set("lightDirDOTviewDir", 0.3);
  
  DofShader = loadShader("dof.glsl");  
  DofGraphics = createGraphics(width, height, P3D);
  DofGraphics.shader(DofShader);
  DofShader.set("aspect", width / (float) height);
  DofShader.set("maxBlur", 0.015);  
  DofShader.set("aperture", 0.02);
  
  KaleidoShader = loadShader("kaleido.glsl");
  KaleidoGraphics = createGraphics(width, height, P3D);
  KaleidoGraphics.shader(KaleidoShader);
  KaleidoShader.set("segments", 2.0);

  NoiseShader = loadShader("noise.glsl");
  NoiseGraphics = createGraphics(width, height, P3D);
  NoiseGraphics.shader(NoiseShader);
  NoiseShader.set("frequency", 4.0);
  NoiseShader.set("amplitude", 0.1);
  NoiseShader.set("speed", 0.1);
  
  FxaaShader = loadShader("fxaa.glsl");
  FxaaGraphics = createGraphics(width, height, P3D);
  FxaaGraphics.shader(FxaaShader);
  FxaaShader.set("resolution", 1.0 / width, 1.0 / height);
  
  HorizontalShader = loadShader("horizontal.glsl");
  HorizontalGraphics = createGraphics(width, height, P3D);
  HorizontalGraphics.shader(HorizontalShader);
  HorizontalShader.set("h", 0.005);
  HorizontalShader.set("r", 0.5);
  frameRate(1000);
}

public void draw() {
    PGraphics pg = SrcGraphics;

  // 1. Draw into main buffer
  for (int i = 0; i < models.length; i++) 
    if (SrcScene.grabsAnyAgentInput(models[i]))
      models[i].shape().setFill(color(255, 0, 0));
    else {
      pushStyle();
      colorMode(HSB, 255);
      models[i].shape().setFill(cols[i]);
      popStyle();
    }
  pg.beginDraw();
  SrcScene.beginDraw();
  pg.background(0);
  SrcScene.drawModels();
  SrcScene.endDraw();
  pg.endDraw();
 
  DrawGraphics = SrcGraphics;
  
  if (bdepth){
    colorGraphics.beginDraw();
    colorGraphics.background(0);
    SrcScene.drawModels(colorGraphics);
    colorGraphics.endDraw();
    DrawGraphics = colorGraphics;
  }
  if (bkaleido) {
    KaleidoGraphics.beginDraw();
    KaleidoShader.set("tex", DrawGraphics);
    KaleidoGraphics.image(SrcGraphics, 0, 0);
    KaleidoGraphics.endDraw();    
    DrawGraphics = KaleidoGraphics;
  }
  if (bnoise) {
    NoiseGraphics.beginDraw();
    NoiseShader.set("time", millis() / 1000.0);
    NoiseShader.set("tex", DrawGraphics);
    NoiseGraphics.image(SrcGraphics, 0, 0);
    NoiseGraphics.endDraw();    
    DrawGraphics = NoiseGraphics;
  }
  if (bpixel) {
    PixelGraphics.beginDraw();
    PixelShader.set("tex", DrawGraphics);
    PixelGraphics.image(SrcGraphics, 0, 0);
    PixelGraphics.endDraw();
    DrawGraphics = PixelGraphics;    
  }
  if (bdof) {  
    DofGraphics.beginDraw();
    DofShader.set("focus", map(mouseX, 0, width, -0.5f, 1.5f));    
    DofShader.set("tDepth", colorGraphics);
    DofShader.set("tex", DrawGraphics);
    DofGraphics.image(SrcGraphics, 0, 0);
    DofGraphics.endDraw();    
    DrawGraphics = DofGraphics;
  }
  if (bedge) {  
    EdgeGraphics.beginDraw();
    EdgeShader.set("tex", DrawGraphics);
    EdgeGraphics.image(SrcGraphics, 0, 0);
    EdgeGraphics.endDraw();    
    DrawGraphics = EdgeGraphics;
  }
  if (bhorizontal) {
    HorizontalGraphics.beginDraw();
    HorizontalShader.set("tDiffuse", DrawGraphics);
    HorizontalGraphics.image(SrcGraphics, 0, 0);
    HorizontalGraphics.endDraw();    
    DrawGraphics = HorizontalGraphics;
  }
  if (brays) {   
    RaysGraphics.beginDraw();
    RaysShader.set("otex", DrawGraphics);
    RaysShader.set("rtex", DrawGraphics);
    RaysGraphics.image(SrcGraphics, 0, 0);
    RaysGraphics.endDraw();    
    DrawGraphics = RaysGraphics;
  }
  if (bfxaa) {
    FxaaGraphics.beginDraw();
    FxaaShader.set("tDiffuse", DrawGraphics);
    FxaaGraphics.image(SrcGraphics, 0, 0);
    FxaaGraphics.endDraw();    
    DrawGraphics = FxaaGraphics;
  }
  image(DrawGraphics, 0, 0);
}

PShape boxShape() {
  return createShape(BOX, 60);
}

void keyPressed() {
  if(key=='1')
    bdepth = !bdepth;
  if(key=='2')
    bkaleido = !bkaleido;
  if(key=='3')
    bnoise = !bnoise;
  if(key=='4')
    bpixel = !bpixel;
  if(key=='5')
    bdof = !bdof;  
  if(key=='6')
    bedge = !bedge;
  if(key=='7')
    bhorizontal = !bhorizontal;
  if(key=='8')
    brays = !brays;
  if(key=='9')
    bfxaa = !bfxaa;
}


