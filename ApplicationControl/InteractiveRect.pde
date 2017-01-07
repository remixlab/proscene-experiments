public class InteractiveRect extends InteractiveFrame {
  float halfWidth = 40, halfHeight = 40;
  int alpha = 125;
  int colour = color(0, 255, 255, alpha);

  InteractiveRect(Scene scn) {
    super(scn);      
    updateRect();
  }

  void changeShape(DOF1Event event) {
    halfWidth += event.dx()*5;
    updateRect();
  }

  void changeShape(DOF2Event event) {
    halfWidth += event.dx();
    halfHeight += event.dy();
    updateRect();
  }

  void changeColor() {
    colour = color(color(random(0, 255), random(0, 255), random(0, 255), 125));
    updateRect();
  }

  void colorBlue() {
    colour = color(0, 0, 255, alpha);
    updateRect();
  }

  void colorRed() {
    colour = color(255, 0, 0, alpha);
    updateRect();
  }

  void updateRect() {
    PShape ps = createShape(RECT, 80, 0, 2 * halfWidth, 2 * halfHeight); 
    setShape(ps);
    ps.setFill(color(colour));
  }
}