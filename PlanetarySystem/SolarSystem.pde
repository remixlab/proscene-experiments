/**
 * Solar System.
 * by Juan Manuel Flórez Fandiño and Manuel L. Molano Saavedra.
 * 
 * 
 * This example illustrates how to create some figures (planets) by using textures and making a lighting model of the Solar System.
 *
 * The Copyright of each Planet's textures is on James Hastings-Trew.
 * Extra information on:  http://planetpixelemporium.com/planets.html
 *
 * It is suppose that you can control the speed of the simulation or even reverse it throught P5 control.
 */

static final float MAX_RADIUS = 5910;
static final float SCENE_RADIUS = 3000;

//Optional max diameter:142990
static final float MAX_DIAMETER = 300000;
static final float DIAMETER_SCALE = 50;

static final float MAX_ORBITAL_PERIOD = 90600;
static final float SPEED_SCALE = 0.00001;

static final float MAX_ROTATION_PERIOD = 5840;
static final float ROTATION_SCALE = 0.0001;


//It is the class that creates the abstraction of the planets
class SolarSystem {
  private Sun sun;
  private Planet[] planets;
  private ArrayList<AstronomicalObject> children = new ArrayList<AstronomicalObject>();
  
  public SolarSystem() {
    sun = new Sun(15000, 7.25, 587.28);
    planets = new Planet[9];
    int[] consts = {Planet.MERCURY, Planet.VENUS, Planet.EARTH,
      Planet.MARS, Planet.JUPITER, Planet.SATURN, Planet.URANUS,
      Planet.NEPTUNE, Planet.PLUTO};
    //Those positions are based on data from http://www.nasa.gov/  
    float[] positions = {158.04,138.87,323.76,352.79,117.75,142.58,204.70,270.23,57.20};
    for(int i = 0; i < 9; i++) {
      planets[i] = new Planet(consts[i]);
      planets[i].setT(positions[i]);
    }
    //children.add(new AsteroidBelt());
  }

//It draws Planets  
  public void draw() {
    pushMatrix();
    sun.draw();
    pointLight(255, 255, 255, 0, 0, 0);
    //Draw each thing in the array
    for(AstronomicalObject o : children) {
      o.draw();
    }
    for(Planet planet : planets) {
      planet.draw();
    }
    popMatrix();
  }
}

//It creates the sun. Everybody knows the sun is a star, so it has to be created with some special features respect to the planets
class Sun extends RotatingBody {
  public Sun(float diameter, float axialTiltDegrees, float rotationPeriod) {
    setAxialTilt(axialTilt);
    this.rotationPeriod = rotationPeriod;
    this.shape = createTexturedSphere(diameter/MAX_DIAMETER, loadImage("sun2.jpg"));
  }
}

//it creates the Saturn's ring
class SaturnRing extends AstronomicalObject {
  public SaturnRing() {
    shape = createRing(100, 70, loadImage("saturn-ring.png"));
  }
}

//It creates the Uranu´s ring
class UranusRing extends AstronomicalObject {
  public UranusRing() {
    shape = createRing(40, 30, loadImage("uranus-ring.png"));
  }
}


//It creates an asteroid belt (it's still a prototype)
class AsteroidBelt extends AstronomicalObject {
  public AsteroidBelt() {
    shape = createRing(100, 30, loadImage("asteroids.png"));
  }
}

//It sets the postions of each astronomical object
class Planet extends OrbitingBody {
  public static final int MERCURY = 0;
  public static final int VENUS = 1;
  public static final int EARTH = 2;
  public static final int MARS = 3;
  public static final int JUPITER = 4;
  public static final int SATURN = 5;
  public static final int URANUS = 6;
  public static final int NEPTUNE = 7;
  public static final int PLUTO = 8;
  public static final int MOON = 10;
  public static final int DEIMOS = 11;
  public static final int PHOBOS = 12;
  public static final int GANYMEDE = 13;
  public static final int CALLISTO = 14;
  public static final int IO = 15;
  public static final int EUROPA = 16;
  
  protected float diameter;
  protected ArrayList<AstronomicalObject> children = new ArrayList<AstronomicalObject>();
  protected ArrayList<AstronomicalObject> satellites = new ArrayList<AstronomicalObject>();
  
  
  //It sets the main features of each astronomical object
  public Planet(int which) {
    switch(which) {
      case MERCURY:
        init(4879, 57.91, 0.2056, 88.0, 1407.6, 0.01, 7.0, loadImage("mercury.jpg"));
        break;
      case VENUS:
        init(12104, 108.21, 0.0067, 224.7, -5832.5, 177.4, 3.4, loadImage("venus.jpg"));
        break;
      case EARTH:
        init(12756, 149.6, 0.0167, 365.2, 23.9, 23.4, 0f, loadImage("earth.jpg"));
        this.satellites.add(new Planet(MOON));
        break;
      case MARS:
        init(6792, 227.92, 0.0935, 687.0, 24.6, 25.2, 1.9, loadImage("mars.jpg"));
        this.satellites.add(new Planet(DEIMOS));
        this.satellites.add(new Planet(PHOBOS));
        break;
      case JUPITER:
        init(142984, 778.57, 0.0489, 4331, 9.9, 3.1, 1.3, loadImage("jupiter.jpg"));
        this.satellites.add(new Planet(GANYMEDE));
        this.satellites.add(new Planet(CALLISTO));
        this.satellites.add(new Planet(IO));
        this.satellites.add(new Planet(EUROPA));
        break;
      case SATURN:
        init(120536, 1433.53, 0.0565, 10747, 10.7, 26.7, 2.5, loadImage("saturn.jpg"));
        children.add(new SaturnRing());
        break;
      case URANUS:
        init(51118, 2872.46, 0.0457, 30589, -17.2, 97.8, 0.8, loadImage("uranus.jpg"));
        children.add(new UranusRing());
        break;
      case NEPTUNE:
        init(49528, 4495.06, 0.0113, 59800, 16.1, 28.3, 1.8, loadImage("neptune.jpg"));
        break;
      case PLUTO:
        init(2390, 5906.38, 0.2488, 90588, -153.3, 122.5, 17.2, loadImage("pluto.jpg"));
        break;
      case MOON:
        init(3475, 30f, 0.0549, 27.3, 655.7, 6.7, 5.1, loadImage("moon.jpg"));
        break;
      case DEIMOS:
        init(1000, 30, 0.00024, 30.2976, 655.7, 0, 26, loadImage("deimos.jpg"));//13
        break;
      case PHOBOS:
        init(1500, 20, 0.0148, 0.3189, 655.7, 0, 26.81, loadImage("phobos.jpg"));//23
        break;
      case GANYMEDE:
        init(5262.4, 300, 0.0011, 7.15, 1, 0, 0.186, loadImage("ganymede.jpg"));//23
        break;
      case CALLISTO:
        init(4820.6, 350, 0.007, 16.689018, 1, 0, 0.281, loadImage("callisto.jpg"));//23
        break;
      case IO:
        init(3660, 250, 0.0041, 1.769138, 1, 0, 0.036, loadImage("io.jpg"));//23
        break;
      case EUROPA:
        init(3121.6, 200, 0.0101, 3.551810, 1, 0, 0.464, loadImage("europa.jpg"));//23
        break;
    }
  }
  
 //
  public void draw() {
    pushMatrix();
    rotateX(orbitalInclination);
    shape(orbit);
    float t2Pi = t*2*PI;
    translate(semiMajorAxis*cos(t2Pi), semiMinorAxis*sin(t2Pi),0);
    incrementT();
    //Draws satellites such as the Moon or Io
    for(AstronomicalObject o : satellites) {
      o.draw();
    }
    super.applyTransformations();
    //It applies the things done above
    for(AstronomicalObject o : children) {
      o.draw();
    }
    shape(this.shape);
    popMatrix();
  }
  
  
  //This void helps to set the Planet's features
  public void init(float diameter, float semiMajorAxis, float eccentricity,
      float orbitalPeriod, float rotationPeriod, float axialTiltDeg,
      float orbitalInclinationDeg, PImage tex) {
    this.eccentricity = eccentricity;
    this.diameter = diameter;
    this.semiMajorAxis = (semiMajorAxis/MAX_RADIUS) * SCENE_RADIUS;
    setSemiMinorAxis(semiMajorAxis, eccentricity);
    this.semiMinorAxis = (this.semiMinorAxis/MAX_RADIUS) * SCENE_RADIUS;
    this.orbitalPeriod = orbitalPeriod;
    this.rotationPeriod = rotationPeriod;
    this.axialTilt = (axialTiltDeg*PI)/180f;
    setOrbitalInclination(orbitalInclinationDeg);
    setOrbit();
//    if(hasMoons) {
//      moons = new ArrayList<Planet>();
//    }
    t = r = 0;
    this.shape = createTexturedSphere(diameter/MAX_DIAMETER, tex);
  }
}
