public class Particle2D {
  public PVector speed;
  public PVector pos;
  public int age;
  public int ageMax;

  public Particle2D() {
    speed = new PVector();
    pos = new PVector();
    init();
  }

  public void animate() {
    speed.z -= 0.05f;
    pos = PVector.add(pos, PVector.mult(speed, 10f));

    if (++age == ageMax)
      init();
  }

  public void draw() {    
    stroke( 255 * ((float) age / (float) ageMax), 255 * ((float) age / (float) ageMax), 255);
    vertex(pos.x, pos.y);
  }

  public void init() {    
    pos = new PVector();
    float angle = 2.0f * PI * random(1);
    float norm = 0.04f * random(1);
    speed = new PVector(norm * cos(angle), norm  * sin(angle));
    age = 0;
    ageMax = 50 + (int) random(100);
  }
}
