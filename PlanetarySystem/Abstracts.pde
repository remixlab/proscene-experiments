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


//It's the piece of code that models the behavior and main fearures of an astronomical object
abstract class AstronomicalObject {
  protected PShape shape;
  protected float axialTilt = 0;
  
  protected void applyRotations() {
    rotateY(axialTilt);
  }
  
  protected void applyTranslations() {}
  
  protected void applyTransformations() {
    applyTranslations();
    applyRotations();
  }
  
  public void draw() {
    pushMatrix();
    applyTransformations();
    shape(shape);
    popMatrix();
  }
  
  public PShape getShape() {
    return shape;
  }
  
  public void setShape(PShape shape) {
    this.shape = shape;
  }
  
  public void setAxialTilt(float degrees) {
    this.axialTilt = (degrees*PI)/180f;
  }
}

abstract class RotatingBody extends AstronomicalObject {
  protected float r = 0;
  protected float rotationPeriod;
  
  protected void applyRotations() {
    super.applyRotations();
    rotateZ(r);
    incrementR();
  }
  
  protected void incrementR() {
    r += (MAX_ROTATION_PERIOD/this.rotationPeriod)*ROTATION_SCALE*SIMULATION_SPEED;
  }
  
  public float getR() {
    return r;
  }
  
  public void setR(float r) {
    this.r = r;
  }
}

abstract class OrbitingBody extends RotatingBody {
  protected float semiMajorAxis;
  protected float semiMinorAxis;
  protected float eccentricity;
  protected float orbitalPeriod;
  protected float orbitalInclination;
  protected float t = 0;
  
  protected PShape orbit;
  
  public void draw() {
    pushMatrix();
    rotateX(orbitalInclination);
    shape(orbit);
    float t2Pi = t*2*PI;
    translate(semiMajorAxis*cos(t2Pi), semiMinorAxis*sin(t2Pi),0);
    incrementT();
    super.applyTransformations();
    shape(this.shape);
    popMatrix();
  }
  
  protected void setOrbit() {
    stroke(255);
    noFill();
    orbit = createShape(ELLIPSE, -semiMajorAxis, -semiMinorAxis,
      semiMajorAxis*2, semiMinorAxis*2);
  }
    
  
  protected void incrementT() {
    t += (MAX_ORBITAL_PERIOD/this.orbitalPeriod)*SPEED_SCALE*SIMULATION_SPEED;
  }
  
  public void setSemiMinorAxis(float semiMajorAxis, float eccentricity) {
    this.semiMinorAxis = semiMajorAxis * sqrt(1-pow(eccentricity,2));
  }
  
  public void setT(float trueAnomaly) {
    //to radians
    trueAnomaly = (trueAnomaly*PI)/180f;
    t = acos((this.eccentricity+cos(trueAnomaly))/
      (1+this.eccentricity*cos(trueAnomaly)))/(2*PI);
  }
  
  public float getT() {
    return t;
  }
  
  public void setOrbitalInclination(float oi) {
    this.orbitalInclination = (oi*PI)/180f;
  }
    
}

PShape createRing(int diameter, int theWidth, PImage tex) {
  PShape p = createShape();
  float r = diameter, R = diameter + theWidth;
  int points = 50;
  float step = (2*PI)/(points-1);
  float t = 0, s = step;
  
  p.beginShape(TRIANGLE_STRIP);
  p.texture(tex);
  for(int i = 0; i < points; i++) {
    p.vertex(r*cos(t), r*sin(t), 0, 0, tex.height);
    p.vertex(R*cos(s), R*sin(s), 0, tex.width, 0);
    t += step;
    s += step;
  }
  p.endShape();
  
  return p;
}

PShape createTexturedSphere(float scale, PImage t) {
  noStroke();
  int ptsW = 30, ptsH = 30;
  int numPtsW = 30;
  
  float[] coorX;
  float[] coorY;
  float[] coorZ;
  float[] multXZ;

  // The number of points around the width and height
  int numPointsW=numPtsW+1;
  int numPointsH_2pi=numPtsW;  // How many actual pts around the sphere (not just from top to bottom)
  int numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

  coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
  coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
  coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
  multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  for (int i=0; i<numPointsW ;i++) {  // For all the points around the width
    float thetaW=i*2*PI/(numPointsW-1);
    coorX[i]=sin(thetaW);
    coorZ[i]=cos(thetaW);
  }
  
  for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
    if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
      float thetaH=(i-1)*2*PI/(numPointsH_2pi);
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=0;
    } 
    else {
      //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
      float thetaH=i*2*PI/(numPointsH_2pi);

      //PI+ below makes the top always the point instead of the bottom.
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=sin(thetaH);
    }
  }
  
  float rx=200, ry=200, rz=200;

  // These are so we can map certain parts of the image on to the shape 
  float changeU=t.width/(float)(numPointsW-1); 
  float changeV=t.height/(float)(numPointsH-1); 
  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture
  
  PShape planet = createShape();
  planet.beginShape(TRIANGLE_STRIP);
  planet.texture(t);
  for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
    // Goes into the array here instead of loop to save time
    float coory=coorY[i];
    float cooryPlus=coorY[i+1];

    float multxz=multXZ[i];
    float multxzPlus=multXZ[i+1];

    for (int j=0; j<numPointsW; j++) {  // For all the pts in the ring
      planet.normal(coorX[j]*multxz, coory, coorZ[j]*multxz);
      planet.vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
      planet.normal(coorX[j]*multxzPlus, cooryPlus, coorZ[j]*multxzPlus);
      planet.vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  planet.endShape();
  planet.scale(scale);
  planet.rotateX(-PI/2);
  return planet;
}
