/*Authors: 
  Sebastian Chaparro
  William Rodriguez
*/ 
/*
Here are implemented two kinds of collision testing:
In the first case is calculated the bounding sphere of a Model, and we're going to verify
if there exists collision between these spheres.

If is the case (there exists a collision between spheres), we proceed to calculate the bounding box
of a Model and verify if there is a collision between the boxes.

In the scene are drawn the models, with their respective bounding spheres, if the first test of collision
is passed, there are shown the bounding boxes.

A red bounding box means that there's a collision between the boxes, a green bounding box means that there is no collision between the 
boxes but there is a collision between the bounding spheres.
*/

//Bounding Volumes collision 
//first approach: bounding collision with boxes
//second approach: boun collision with spheres
import remixlab.proscene.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;

Scene scene;
Model models[];
int colors[];
boolean[] collisions_s;
boolean[] collisions_c;

//Spheres calculated by Wiezlzalgorithm in linear time
float[][] spheres_w; 
//Spheres calculated by exhaustive enumeration
float[][] spheres_ex;
//Spheres calculated by a box bounding (non optimal)
float[][] spheres_br;

//Choose one of P3D for a 3D scene, or P2D or JAVA2D for a 2D scene
String renderer = P3D;
int mode = 0; //0 wiezlz, 1 exhaustive, 2 bounding box

void setup() {
  size(640, 360, renderer);
  //Scene instantiation
  scene = new Scene(this);
  models = new Model[50];
  colors = new int[models.length];
  spheres_w = new float[models.length][4];
  spheres_ex = new float[models.length][4];
  spheres_br = new float[models.length][4];
  collisions_c = new boolean[models.length];
  collisions_s = new boolean[models.length];
  
  for(int i = 0; i < models.length; i++){
    models[i] = new Model(scene, drawRandomPolygon(10));
    models[i].translate(random(-100,100),random(-100,100),random(-50,50));
    colors[i] = color(random(255),random(255),random(255));
    getSphere(i);
    collisions_c[i] = false;
    collisions_s[i] = false;
  }
  
  printInfo();
  smooth();
}

void mainDraw(){
  background(0);
  for (int i = 0; i < models.length; i++) {    
    if(i > 0){
      int c= colors[i];
      models[i].shape().setStroke(c);
      models[i].shape().setFill(c);
    }
    models[i].drawShape();
  }
}

void draw() {
  mainDraw();
  for(int i = 0; i < models.length; i++){
    checkSphereCollisions(i);
    if(collisions_s[i] == true){
      drawCube(i);
    }else{
      drawSphere(i);
    }
  }
}

PShape drawRandomPolygon(int num_vertex){
  PShape sh = createShape(); 
  sh.beginShape(QUAD_STRIP);
  for(int i = 0; i < num_vertex; i++){
    sh.vertex(random(0,15),random(0,15), random(0,15));  
  }
  sh.endShape(CLOSE);
  return sh;
}

//draw a rect bound
public void drawCube(int number){
  Model m = models[number];
  //translate to frame pos
  if(collisions_c[number]){
    stroke(color(255,0,0));
    fill(color(255,0,0,60));
  }else{
    stroke(color(0,255,0));
    fill(color(0,255,0,60));
  }
  //set translation, rotation
  Vec[][] cub = getFaces(m);
  for(int i = 0; i < cub.length; i++){
    beginShape();
    vertex(cub[i][0].x(), cub[i][0].y(), cub[i][0].z());
    vertex(cub[i][1].x(), cub[i][1].y(), cub[i][1].z());
    vertex(cub[i][3].x(), cub[i][3].y(), cub[i][3].z());
    vertex(cub[i][2].x(), cub[i][2].y(), cub[i][2].z());
    endShape(CLOSE);
  }
}

//draw a sphere bound
public void drawSphere(int number){
  Model m = models[number];
  if(collisions_s[number]){
    stroke(color(255,0,0));
    fill(color(255,0,0,60));
  }else{
    if(mode == 0){
      stroke(color(140,0,140));
      fill(color(140,0,140,60));  
    }else if(mode == 1){
      fill(color(0,0,240,60));  
    }else{
      fill(color(140,0,140,60));  
    }
  }
  
  if(mode == 0){
    float[] sph = new float[4];
    sph[0] = spheres_w[number][0];
    sph[1] = spheres_w[number][1];
    sph[2] = spheres_w[number][2];
    sph[3] = spheres_w[number][3];
    pushMatrix();
    Vec coords = (new Vec(sph[1],sph[2],sph[3]));
    coords = m.inverseCoordinatesOf(coords);
    translate(coords.x(),coords.y(),coords.z());
    pushStyle();
    noStroke();
    sphere(sph[0]*m.magnitude());
    popStyle();
    popMatrix();
  }else if(mode == 1){
    float[] sph1 = new float[4];
    sph1[0] = spheres_ex[number][0];
    sph1[1] = spheres_ex[number][1];
    sph1[2] = spheres_ex[number][2];
    sph1[3] = spheres_ex[number][3];
    pushMatrix();
    Vec coords = (new Vec(sph1[1],sph1[2],sph1[3]));
    coords = m.inverseCoordinatesOf(coords);  
    translate(coords.x(),coords.y(),coords.z());
    pushStyle();
    noStroke();
    sphere(sph1[0]*m.magnitude());  
    popStyle();
    popMatrix();
  }else{
    float[] sph2 = new float[4];
    sph2[0] = spheres_br[number][0];
    sph2[1] = spheres_br[number][1];
    sph2[2] = spheres_br[number][2];
    sph2[3] = spheres_br[number][3];
    pushMatrix();
    Vec coords = (new Vec(sph2[1],sph2[2],sph2[3]));
    coords = m.inverseCoordinatesOf(coords);  
    translate(coords.x(),coords.y(),coords.z());
    pushStyle();
    noStroke();
    sphere(sph2[0]*m.magnitude());  
    popStyle();
    popMatrix();
  }
}

public void getSphere(int number){
  Model m = models[number];  
  ArrayList<Vec> P = new ArrayList<Vec>(); 
  for(int i = 0; i < m.shape().getVertexCount(); i++){
    float x = m.shape().getVertex(i).x;
    float y = m.shape().getVertex(i).y;
    float z = m.shape().getVertex(i).z;
    P.add((new Vec(x,y,z)));
  }
  float[] sph = minsphere(P);
  if(sph[0]==Float.NaN) sph = minsphere(P);
  float[] sph1 = minsphere_ex(P);
  float[] sph2 = boundSphere(m);
  
  //save the values
  spheres_w[number][0] = sph[0];
  spheres_w[number][1] = sph[1];
  spheres_w[number][2] = sph[2];
  spheres_w[number][3] = sph[3];

  spheres_ex[number][0] = sph1[0];
  spheres_ex[number][1] = sph1[1];
  spheres_ex[number][2] = sph1[2];
  spheres_ex[number][3] = sph1[3];
  
  spheres_br[number][0] = sph2[0];
  spheres_br[number][1] = sph2[1];
  spheres_br[number][2] = sph2[2];
  spheres_br[number][3] = sph2[3];
}

//---------------------------------
//Used for bounding box collisions
public Vec[] getCube(PShape shape) {
  Vec v[] = new Vec[2];
  float minx = 999;
  float miny = 999;
  float maxx = -999;
  float maxy = -999;
  float minz = 999;
  float maxz = -999;  
  for(int i = 0; i < shape.getVertexCount(); i++){
    float x = shape.getVertex(i).x;
    float y = shape.getVertex(i).y;
    float z = shape.getVertex(i).z;
    minx = minx > x ? x : minx;
    miny = miny > y ? y : miny;
    minz = minz > z ? z : minz;
    maxx = maxx < x ? x : maxx;
    maxy = maxy < y ? y : maxy;
    maxz = maxz < z ? z : maxz;
  }
  v[0] = new Vec(minx,miny, minz);
  v[1] = new Vec(maxx,maxy, maxz);
  return v;
}

public Vec[][] getFaces(Model m){
  Vec[] cub = getCube(m.shape());
  Vec[][] faces = new Vec[6][4];
  faces[0][0] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[0].y(), cub[0].z()));
  faces[0][1] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[0].y(), cub[0].z()));
  faces[0][2] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[1].y(), cub[0].z()));
  faces[0][3] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[1].y(), cub[0].z()));

  faces[1][0] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[0].y(), cub[1].z()));
  faces[1][1] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[0].y(), cub[1].z()));
  faces[1][2] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[1].y(), cub[1].z()));
  faces[1][3] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[1].y(), cub[1].z()));

  faces[2][0] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[0].y(), cub[0].z()));
  faces[2][1] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[1].y(), cub[0].z()));
  faces[2][2] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[0].y(), cub[1].z()));
  faces[2][3] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[1].y(), cub[1].z()));

  faces[3][0] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[0].y(), cub[0].z()));
  faces[3][1] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[1].y(), cub[0].z()));
  faces[3][2] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[0].y(), cub[1].z()));
  faces[3][3] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[1].y(), cub[1].z()));

  faces[4][0] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[0].y(), cub[0].z()));
  faces[4][1] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[0].y(), cub[0].z()));
  faces[4][2] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[0].y(), cub[1].z()));
  faces[4][3] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[0].y(), cub[1].z()));

  faces[5][0] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[1].y(), cub[0].z()));
  faces[5][1] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[1].y(), cub[0].z()));
  faces[5][2] = m.inverseCoordinatesOf(new Vec(cub[0].x(), cub[1].y(), cub[1].z()));
  faces[5][3] = m.inverseCoordinatesOf(new Vec(cub[1].x(), cub[1].y(), cub[1].z()));
  
  return faces;
}

//Is used the Separated Axis Theorem
public void checkCubeCollisions(int number, int candidate){
  Model player = models[number];
  collisions_c[number] = false;
  //check with each Face
  Vec[][] p_faces = getFaces(player);
  Vec[] box1 = getCube(player.shape());
  box1[0] = player.inverseCoordinatesOf(box1[0]);
  box1[1] = player.inverseCoordinatesOf(box1[1]);  
  Vec[][] o_faces = getFaces(models[candidate]);    
  Vec[] box2 = getCube(models[candidate].shape());
  box2[0] = models[candidate].inverseCoordinatesOf(box2[0]);
  box2[1] = models[candidate].inverseCoordinatesOf(box2[1]);  
  //check for each face
  for(int j = 0; j < o_faces.length; j++){
    for(int k = 0; k < p_faces.length; k++){
      collisions_c[number] = isACollision(p_faces[k], player, o_faces[j], models[candidate]) || collisions_c[number]; 
    }
  }
  //Check if one cube is inside the other
  if( box1[0].x() <= box2[0].x() && box1[1].x() >= box2[1].x() && box1[0].y() <= box2[0].y() && box1[1].y() >= box2[1].y() && box1[0].z() <= box2[0].z() && box1[1].z() >= box2[1].z())
    collisions_c[number] = true;
  if( box2[0].x() <= box1[0].x() && box2[1].x() >= box1[1].x() && box2[0].y() <= box1[0].y() && box2[1].y() >= box1[1].y() && box2[0].z() <= box1[0].z() && box2[1].z() >= box1[1].z())
    collisions_c[number] = true;
}

public boolean isACollision(Vec[] rect1, Frame frect1, Vec[] rect2, Frame frect2){
  //pass the coord of a rect to the coords of another frame (using this we can avoid the projection calculus)
  Vec[] r1 = new Vec[4];
  Vec[] r2 = new Vec[4];
  Vec[] comp = new Vec[4];
  Vec[] comp2 = new Vec[4];
  for(int i = 0; i < rect2.length; i++){    
    r1[i] = frect1.coordinatesOf(rect1[i]);
    r2[i] = frect2.coordinatesOf(rect2[i]);
    comp[i] = rect2[i];
    comp[i] = frect1.coordinatesOf(comp[i]);
    comp2[i] = rect1[i];
    comp2[i] = frect2.coordinatesOf(comp2[i]);
  }
  if(isInside(r1, comp) && isInside(r2, comp2)){
    return true;
  }
  return false;
}

public boolean isInside(Vec[] rect, Vec[] rect2){ 
  //suppsose that is in rect coords      
  float [] vals = getValues(rect2); //order max and min Values
  if((vals[0] <= rect[0].x() && rect[0].x() <= vals[1] && vals[1] <= rect[3].x())
    || (rect[0].x() <= vals[0] && vals[0] <= rect[3].x() && rect[3].x() <= vals[1])
    || (vals[0] >= rect[0].x() && vals[1] <= rect[3].x())
    || (vals[0] <= rect[0].x() && vals[1] >= rect[3].x())){
    if((vals[2] <= rect[0].y() && rect[0].y() <= vals[3] && vals[3] <= rect[3].y())
      || (rect[0].y() <= vals[2] && vals[2] <= rect[3].y() && rect[3].y() <= vals[3])
      || (vals[2]>= rect[0].y() && vals[2] <= rect[3].y())
      || (vals[2]<= rect[0].y() && vals[3] >= rect[3].y())){
      if((vals[4] <= rect[0].z() && rect[0].z() <= vals[5] && vals[5] <= rect[3].z())
        || (rect[0].z() <= vals[4] && vals[4] <= rect[3].z() && rect[3].z() <= vals[5])
        || (vals[4]>= rect[0].z() && vals[4] <= rect[3].z())
        || (vals[4]<= rect[0].z() && vals[5] >= rect[3].z())){
          return true;
        }
    }
  }
  return false;
}


public float[] getValues(Vec[] rect){
  float[] ord = new float[6];
  ord[0] = rect[0].x();
  ord[1] = rect[0].x();
  ord[2] = rect[0].y();
  ord[3] = rect[0].y();
  ord[4] = rect[0].z();
  ord[5] = rect[0].z();
  for(int i = 0 ; i < 4; i++){
    if(rect[i].x() <= ord[0])
      ord[0] = rect[i].x();
    if(rect[i].x() >= ord[1])
      ord[1] = rect[i].x();      
    if(rect[i].y() <= ord[2])
      ord[2] = rect[i].y();      
    if(rect[i].y() >= ord[3])
      ord[3] = rect[i].y();      
    if(rect[i].z() <= ord[4])
      ord[4] = rect[i].z();      
    if(rect[i].z() >= ord[5])
      ord[5] = rect[i].z();      
  }
  return ord;
}
//---------------------------------------------

//---------------------------------------------
//Used for bounding sphere collisions 
//---------------------------------------------
//exhaustive enumeration
//the first field is the radius, second and thid cente x and center y z
//be undefined is defined with radius = -1
public float[] minsphere_ex(ArrayList<Vec> P){
  float[] sph = new float[4];
  float radiusEpsilon = 1e-4f; 
  for(int i = 0; i < P.size(); i++){
    Vec p1 = P.get(i);
    for(int j = 0; j < P.size(); j++){
      if(i!=j){
        Vec p2 = P.get(j);
        float radius = 0.5*(Vec.distance(p1,p2)) + radiusEpsilon;
        Vec center = new Vec();
        Vec.subtract(p1,p2, center);
        center.multiply(0.5);
        center.add(p2);        
        if(sph[0] < radius){
          sph = new float[]{radius,center.x(),center.y(),center.z()};
        }
      }
    }
  }
  return sph;
}
//---------------------------------------
//---------------------------------------
//sphere not optimal according to a bounding box
public float[] boundSphere(Model m) {
  Vec max = new Vec(-999,0,0);
  Vec may = new Vec(0,-999,0);
  Vec maz = new Vec(0,0,-999);
  Vec mix = new Vec(999,0,0);
  Vec miy = new Vec(0,999,0);
  Vec miz = new Vec(0,0,999);
  PShape shape = m.shape();
  for(int i = 0; i < shape.getVertexCount(); i++){
    float x = shape.getVertex(i).x;
    float y = shape.getVertex(i).y;
    float z = shape.getVertex(i).z;
    if(mix.x() > x)mix = new Vec(shape.getVertex(i).x,shape.getVertex(i).y,shape.getVertex(i).z);
    if(miy.y() > y)miy = new Vec(shape.getVertex(i).x,shape.getVertex(i).y,shape.getVertex(i).z);
    if(miz.z() > z)miz = new Vec(shape.getVertex(i).x,shape.getVertex(i).y,shape.getVertex(i).z);
    if(max.x() < x)max = new Vec(shape.getVertex(i).x,shape.getVertex(i).y,shape.getVertex(i).z);
    if(may.y() < y)may = new Vec(shape.getVertex(i).x,shape.getVertex(i).y,shape.getVertex(i).z);
    if(maz.z() < z)maz = new Vec(shape.getVertex(i).x,shape.getVertex(i).y,shape.getVertex(i).z);
  }
  float cx = (mix.x()+max.x())/2;
  float cy = (miy.y()+may.y())/2;
  float cz = (miz.z()+maz.z())/2;
  Vec v = (new Vec(cx,cy,cz));
  
  float great,temp;
  great = sqrt( (max.x()-cx)*(max.x()-cx) + (max.y()-cy)*(max.y()-cy) + (max.z()-cz)*(max.z()-cz) );
  temp = sqrt( (may.x()-cx)*(may.x()-cx) + (may.y()-cy)*(may.y()-cy) + (may.z()-cz)*(may.z()-cz) ); 
  great = great<temp ? temp : great;
  temp = sqrt( (maz.x()-cx)*(maz.x()-cx) + (maz.y()-cy)*(maz.y()-cy) + (maz.z()-cz)*(maz.z()-cz) );
  great = great<temp ? temp : great;
  temp = sqrt( (cx-miz.x())*(cx-miz.x()) + (cy-miz.y())*(cy-miz.y()) + (cz-miz.z())*(cz-miz.z()) );
  great = great<temp ? temp : great;
  temp = sqrt( (cx-mix.x())*(cx-mix.x()) + (cy-mix.y())*(cy-mix.y()) + (cz-mix.z())*(cz-mix.z()) ); 
  great = great<temp ? temp : great;
  temp = sqrt( (cx-miy.x())*(cx-miy.x()) + (cy-miy.y())*(cy-miy.y()) + (cz-miy.z())*(cz-miy.z()) ); 
  great = great<temp ? temp : great;
  
  return new float[]{great,v.x(),v.y(),v.z()};
}
//---------------------------------------
//---------------------------------------

//---------------------------------------
//---------------------------------------
//Welzlz algorithm implementation
//http://www.inf.ethz.ch/personal/emo/PublFiles/SmallEnclDisk_LNCS555_91.pdf
public float[] minsphere(ArrayList<Vec> P){
  return b_minsphere(P, new ArrayList<Vec>());
}

public float[] b_minsphere(ArrayList<Vec> P, ArrayList<Vec> R){
  if(P.size() == 0 || R.size() == 4){
    return b_ms(R);
  }
  int idx = int(random(P.size()));
  //idx = 0;
  Vec p = P.get(idx);
  ArrayList<Vec> P_minus_p = new ArrayList<Vec>();
  P_minus_p.addAll(P);
  P_minus_p.remove(p);
  float[] sph = b_minsphere(P_minus_p,R);
  if(!inside_sphere(sph,p) || sph[0] == -1){
    ArrayList<Vec> R_u_p = new ArrayList<Vec>();
    R_u_p.addAll(R);
    R_u_p.add(p);
    sph = b_minsphere(P_minus_p,R_u_p);
  }
  return sph;
}

public boolean inside_sphere(float[] sph, Vec point){
  float rad = sph[0];
  Vec v = new Vec(sph[1], sph[2], sph[3]);
  if(abs(Vec.distance(v,point)) <= rad) {
    return true;
   }
   return false;  
}

//adapted from http://www.flipcode.com/archives/Smallest_Enclosing_Spheres.shtml
public float[] b_ms(ArrayList<Vec> points){
  float radiusEpsilon = 1e-4f; 
  if(points.size() == 0){
    return new float[]{-1,0,0,0};
  }
  if(points.size() == 1){
    Vec point = points.get(0);
    return new float[]{radiusEpsilon,point.x(),point.y(),point.z()};
  }
  if(points.size() == 2){ 
    Vec p1 = points.get(0);
    Vec p2 = points.get(1);
    Vec a = new Vec(); 
    Vec.subtract(p2,p1,a);
    Vec o = new Vec();
    Vec.multiply(a,0.5,o);
    float radius = sqrt(Vec.dot(o,o)) + radiusEpsilon;
    Vec center = new Vec();
    Vec.add(p1,o,center);
    return new float[]{radius,center.x(),center.y(),center.z()};
  }
  if(points.size() == 3){ 
    Vec p1 = points.get(0);
    Vec p2 = points.get(1);
    Vec p3 = points.get(2);
    Vec a = new Vec(); 
    Vec.subtract(p2,p1,a);
    Vec b = new Vec(); 
    Vec.subtract(p3,p1,b);
    Vec aCrossb = new Vec();
    Vec.cross(a, b, aCrossb); 
    Vec o1 = new Vec();
    Vec.cross(aCrossb, a, o1); 
    Vec o2 = new Vec();
    Vec.cross(b, aCrossb, o2); 

    float Denominator = 2.0f * (Vec.dot(aCrossb,aCrossb));
    o1.multiply(Vec.dot(b,b));
    o2.multiply(Vec.dot(a,a));
    Vec o = new Vec();
    Vec.add(o1,o2,o);
    o.divide(Denominator);    
    float radius = sqrt(Vec.dot(o,o)) + radiusEpsilon;
    Vec center = new Vec();
    Vec.add(p1,o,center);
    return new float[]{radius,center.x(),center.y(),center.z()};
  }
  
  Vec p1 = points.get(0);
  Vec p2 = points.get(1);
  Vec p3 = points.get(2);
  Vec p4 = points.get(3);
  Vec a = new Vec(); 
  Vec.subtract(p2,p1,a);
  Vec b = new Vec(); 
  Vec.subtract(p3,p1,b);
  Vec c = new Vec(); 
  Vec.subtract(p4,p1,c);

  float Denominator = 2.0f * det(a.x(),a.y(),a.z(),
                                 b.x(),b.y(),b.z(),
                                 c.x(),c.y(),c.z());

  Vec o1 = new Vec();
  Vec.cross(a, b, o1); 
  o1.multiply(Vec.dot(c,c));
  Vec o2 = new Vec();
  Vec.cross(c, a, o2); 
  o2.multiply(Vec.dot(b,b));
  Vec o3 = new Vec();
  Vec.cross(b, c, o3); 
  o3.multiply(Vec.dot(a,a));
  Vec o = new Vec();
  Vec.add(o1,o2,o);
  o.add(o3);
  o.divide(Denominator);    
  float radius = sqrt(Vec.dot(o,o)) + radiusEpsilon;
  Vec center = new Vec();
  Vec.add(p1,o,center);
  return new float[]{radius,center.x(),center.y(),center.z()};  
}

float det(float m11, float m12, float m13, 
                    float m21, float m22, float m23, 
                    float m31, float m32, float m33){
  return m11 * (m22 * m33 - m32 * m23) -
         m21 * (m12 * m33 - m32 * m13) +
         m31 * (m12 * m23 - m22 * m13);
}
//---------------------------------------
//---------------------------------------
public void checkSphereCollisions(int number){
  Model player = models[number];
  collisions_s[number] = false;
  //check with each obj
  for(int i = 0; i < models.length;i++){
    if(i==number) continue;
    //Check if one sphere is inside the other
    if(sphere_intersection(spheres_w[number], spheres_w[i], number, i)){
      collisions_s[number] = true;
      checkCubeCollisions(number,i);
    }
  }
}

//An intersection exist if the distance between the center of the spheres is less than the sum of the radius of each sphere
public boolean sphere_intersection(float[] sph, float[] sph1, int m1, int m2){
  float rad = sph[0]*models[m1].magnitude();
  Vec v = models[m1].inverseCoordinatesOf(new Vec(sph[1], sph[2], sph[3]));
  float rad1 = sph1[0]*models[m2].magnitude();
  Vec v1 = models[m2].inverseCoordinatesOf(new Vec(sph1[1], sph1[2], sph1[3]));
  if(Vec.distance(v,v1) <= rad+rad1) {
    return true;
  }
  return false;  
}

//Chage mode:
//Z - Wiezlz
//X - Exhaustive
//C - Bounding
void keyPressed() {
  if (key == 'Z' || key == 'z') {
    mode = 0;
  } 
  else if (key == 'x' || key == 'X') {
    mode = 1;
  } 
  else if (key == 'C' || key == 'c') {
    mode = 2;
  } 
}

//Info about the radius calculated by each method.
void printInfo(){
  for(int i = 0; i < models.length; i++){
    println("Figura : " + i);
    println("Radio Ex : " + spheres_ex[i][0] + " Radio W : " + spheres_w[i][0] + " Radio B : " + spheres_br[i][0]);
    print("Centro Ex : (" + spheres_ex[i][1] + ", " + spheres_ex[i][2] + ", " + spheres_ex[i][3] + ")");
    print(" Centro W : (" + spheres_w[i][1] + ", " + spheres_w[i][2] + ", " + spheres_w[i][3]+ ")");
    println(" Centro B : (" + spheres_br[i][1] + ", " + spheres_br[i][2] + ", " + spheres_br[i][3]+ ")");

  }
}
