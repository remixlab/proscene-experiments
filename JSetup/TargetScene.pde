public class TargetScene extends AbstractScene {
  PApplet parent;
  public TargetScene(PApplet papplet) {
    // 1. P5 objects
    parent = papplet;

    // 2. P5 connection
    setMatrixHelper(new TargetMatrixHelper(this, parent.g));
    defMotionAgent = new TargetMouseAgent(this);
    defKeyboardAgent = new TargetKeyAgent(this);
    parent.registerMethod("mouseEvent", motionAgent());
    parent.registerMethod("keyEvent", keyboardAgent());
    parent.registerMethod("pre", this);
    parent.registerMethod("draw", this);

    // 3. Eye
    setLeftHanded();
    width = parent.width;
    height = parent.height;
    // default camera would be set with:
    //setEye(is3D() ? new Camera(this) : new Window(this));
    //but we overwrite its frame
    ///*
    eye = is3D() ? new Camera(this) : new Window(this);
    eye.setFrame(new CustomGrabberFrame(eye));
    setEye(eye());// calls showAll();
    //*/

    // 4. init
    init();
  }
  
  public void pre() {
    if ((width != parent.g.width) || (height != parent.g.height)) {
      width = parent.g.width;
      height = parent.g.height;
      eye().setScreenWidthAndHeight(width, height);
    }

    preDraw();
  }
  
  public void draw() {
    postDraw();
  }
  
  @Override
  public int width() {
    return parent.g.width;
  }

  @Override
  public int height() {
    return parent.g.height;
  }
  
  @Override
  public String info() {
    return "hello";
  }

  // DIM

  @Override
  public boolean is3D() {
    return (parent.g instanceof PGraphics3D);
  }

  // CHOOSE PLATFORM

  @Override
  protected void setPlatform() {
    platform = Platform.PROCESSING_DESKTOP;
  }

  @Override
  public void drawTorusSolenoid(int faces, int detail, float insideRadius, float outsideRadius) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawCylinder(float w, float h) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawHollowCylinder(int detail, float w, float h, Vec m, Vec n) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawCone(int detail, float x, float y, float r, float h) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawCone(int detail, float x, float y, float r1, float r2, float h) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawAxes(float length) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawGrid(float size, int nbSubdivisions) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawDottedGrid(float size, int nbSubdivisions) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawPath(KeyFrameInterpolator kfi, int mask, int nbFrames, float scale) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawEye(Eye eye, float scale) {
    // TODO Auto-generated method stub
    
  }

  @Override
  protected void drawKFIEye(float scale) {
    // TODO Auto-generated method stub
    
  }

  @Override
  protected void drawZoomWindowHint() {
    // TODO Auto-generated method stub
    
  }

  @Override
  protected void drawScreenRotateHint() {
    // TODO Auto-generated method stub
    
  }

  @Override
  protected void drawAnchorHint() {
    // TODO Auto-generated method stub
    
  }

  @Override
  protected void drawPointUnderPixelHint() {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawCross(float px, float py, float size) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawFilledCircle(int subdivisions, Vec center, float radius) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawFilledSquare(Vec center, float edge) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawShooterTarget(Vec center, float length) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void drawPickingTarget(GenericFrame gFrame) {
    // TODO Auto-generated method stub
    
  }

  @Override
  public float pixelDepth(Point pixel) {
    // TODO Auto-generated method stub
    return 0;
  }

  @Override
  public void disableDepthTest() {
    // TODO Auto-generated method stub
    
  }

  @Override
  public void enableDepthTest() {
    // TODO Auto-generated method stub
    
  }
}