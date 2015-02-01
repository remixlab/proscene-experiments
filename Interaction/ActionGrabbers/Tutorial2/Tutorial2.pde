import remixlab.bias.core.*;
import remixlab.bias.event.*;
import remixlab.proscene.*;

public class GrabberEllipse extends GrabberObject {
  PGraphics pg;
  public float radiusX, radiusY;
  public PVector center;
  public color colour;

  public GrabberEllipse(PGraphics p) {
    pg = p;
    setColor();
    setPosition();
  }

  public GrabberEllipse(PGraphics p, PVector c, float r) {
    pg = p;
    radiusX = r;
    radiusY = r;
    center = c;    
    setColor();
  }

  public void setColor() {
    setColor(color(random(0, 255), random(0, 255), random(0, 255), 125));
  }

  public void setColor(color myC) {
    colour = myC;
  }

  public void setPosition(float x, float y) {
    setPositionAndRadii(new PVector(x, y), radiusX, radiusY);
  }

  public void setPositionAndRadii(PVector p, float rx, float ry) {
    center = p;
    radiusX = rx;
    radiusY = ry;
  }

  public void setPosition() {
    float maxRadius = 50;
    float low = maxRadius;
    float highX = w - maxRadius;
    float highY = h - maxRadius;
    float r = random(20, maxRadius);
    setPositionAndRadii(new PVector(random(low, highX), random(low, highY)), r, r);
  }

  public void draw() {
    draw(colour);
  }

  public void draw(int c) {
    pg.pushStyle();
    pg.stroke(c);
    pg.fill(c);
    pg.ellipse(center.x, center.y, 2*radiusX, 2*radiusY);
    pg.popStyle();
  }

  @Override
  public boolean checkIfGrabsInput(DOF2Event event) {
    float x = event.x() - oX;
    float y = event.y() - oY;
    return(pow((x - center.x), 2)/pow(radiusX, 2) + pow((y - center.y), 2)/pow(radiusY, 2) <= 1);
  }
  
  @Override
  public void performInteraction(DOF2Event event) {
    if( event.id() != MotionEvent.NO_ID ) {
      radiusX += event.dx();
      radiusY += event.dy();
    }
  }
  
  @Override
  public void performInteraction(ClickEvent event) {
    colour = color(color(random(0, 255), random(0, 255), random(0, 255), 125));
  }
}

int w = 200;
int h = 120;
int oX = 640-w;
int oY = 360-h;
GrabberEllipse e;
PGraphics canvas;
Scene scene;
PGraphics ctrlCanvas;
boolean showAid = true;

color c;

void setup() {
  size(640, 360, P3D);

  canvas = createGraphics(640, 360, P3D); 
  scene = new Scene(this, canvas);
  scene.addGraphicsHandler(this, "drawing");

  ctrlCanvas = createGraphics(w, h);

  e = new GrabberEllipse(ctrlCanvas, new PVector(w/2, h/2), 30);
  scene.mouseAgent().addGrabber(e);
}

void draw() {
  canvas.beginDraw();
  scene.beginDraw();
  canvas.background(255);    
  scene.endDraw();
  canvas.endDraw();
  image(canvas, scene.originCorner().x(), scene.originCorner().y());
 
  if(showAid) {
    ctrlCanvas.beginDraw();  
    ctrlCanvas.background(125, 125, 125, 125);    
    ctrlDrawing(ctrlCanvas);
    ctrlCanvas.endDraw();
    image(ctrlCanvas, oX, oY);
  }
}

void drawing(Scene s) {
  s.pg().pushStyle();
  s.pg().fill(e.colour);
  s.drawTorusSolenoid(int(map(PI*e.radiusX*e.radiusY, 20, w*h, 2, 50)), 100, e.radiusY, e.radiusX);
  s.pg().popStyle();
}

void ctrlDrawing(PGraphics pg) {
  pg.pushStyle();
  pg.stroke(255, 255, 0);
  pg.fill(100);
  if ( scene.mouseAgent().isInputGrabber(e) )
    e.draw(color(red(e.colour), green(e.colour), blue(e.colour)));
  else
    e.draw();
  pg.popStyle();
}

void keyPressed() {
  if(key == ' ')
    showAid = !showAid;
}