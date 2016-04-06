public class Ellipse {
  public float radiusX, radiusY;
  public PVector center;
  public color colour;
  public int contourColour;

  public Ellipse() {
    contourColour = color(random(0, 255), random(0, 255), random(0, 255));
    setColor();
    setPosition();
    setRadii();
  }
  
  public void setColor() {
    setColor(color(random(0, 255), random(0, 255), random(0, 255)));
  }

  public void setColor(color c) {
    colour = c;
  }
  
  public void setRadii() {
    float maxRadius = 50;
    setRadii(random(20, maxRadius), random(20, maxRadius));
  }
  
  public void setRadii(float rx, float ry) {
    radiusX = rx;
    radiusY = ry;
  }
  
  public void setPosition() {
    float maxRadius = 50;
    float low = maxRadius;
    float highX = width - maxRadius;
    float highY = height - maxRadius;
    setPosition(new PVector(random(low, highX), random(low, highY)));
  }

  public void setPosition(PVector p) {
    center = p;
  }

  public void draw() {
    pushStyle();
    stroke(contourColour);
    strokeWeight(4);
    fill(colour);
    ellipse(center.x, center.y, 2 * radiusX, 2 * radiusY);
    popStyle();
  }
}
