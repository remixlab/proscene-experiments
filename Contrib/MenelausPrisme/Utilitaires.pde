
Vec intersection(Vec p1, Vec q1, Vec p2, Vec q2) {
  Vec p1p2=Vec.subtract(p2, p1);
  Vec d1=Vec.subtract(p1, q1);
  Vec d2=Vec.subtract(p2, q2);
    Vec dm1=Vec.subtract(q1, p1);
  float lambda=detxy(p1p2, d2)/detxy(dm1, d2);
 return barycentre(lambda, p1, q1);
 
} 
//---------------------------------------------------
Vec barycentre(float lamb, Vec u, Vec v) {
  return comb(1.0-lamb, u, lamb, v);
}

//---------------------------------------------------
float detxy(Vec u, Vec v) {
  return u.x()*v.y()-u.y()*v.x();
}


Vec comb(float t1, Vec v1, float t2, Vec v2) {
  Vec res=Vec.add(Vec.multiply(v1, t1), Vec.multiply(v2, t2));
  return res;
}

Vec comb(float t1, Vec v1, float t2, Vec v2, float t3, Vec v3) {
  Vec res=Vec.add(Vec.multiply(v1, t1), Vec.multiply(v2, t2));
  res=Vec.add(res, Vec.multiply(v3, t3));
  return res;
}



void drawLigne(int c,Vec a, Vec b) {
  pushStyle();
  stroke(c);
  line(a.x(), a.y(), a.z(), b.x(), b.y(), b.z());
  popStyle();
}



void drawLigne(PGraphics pg,int c,Vec a, Vec b) {
   pg.pushStyle();
  pg.strokeWeight(10);
    pg.stroke(c);   
  pg.line(a.x(), a.y(), a.z(), b.x(), b.y(), b.z());
   pg.popStyle();
}

void afficher(Vec u) {
  println("vecteur = "+u.x()+"    "+u.y()+"   "+u.z());
}

void afficher(Quat q) {
  println("quaternion = x  "+q.x()+"  y  "+q.y()+" z  "+q.z()+"... w= "+q.z());
}
void drawSphere(PGraphics pg,Vec pos) {
  pg.pushStyle();
  pg.pushMatrix();
  pg.translate(pos.x(), pos.y(), pos.z());
  pg.noStroke();
  pg.sphere(6);
  pg.popMatrix();
  pg.popStyle();
}
void drawSphere(int c,Vec pos) {
  pushStyle();
  pushMatrix();
  translate(pos.x(), pos.y(), pos.z());
  noStroke();
  fill(c);
  sphere(6);
  popMatrix();
  popStyle();
}

void triangle3d(PGraphics pg,Vec a, Vec b, Vec c) {
  pg.beginShape(); 
  pg.vertex( a.x(), a.y(), a.z());        
  pg.vertex( b.x(), b.y(), b.z());
  pg.vertex( c.x(), c.y(), c.z());
  pg.endShape();
}

void triangle3d(Vec a, Vec b, Vec c, color couleur) {
  stroke(0, 100, 255);
  beginShape();
  fill(couleur);
  vertex( a.x(), a.y(), a.z());
  vertex( b.x(), b.y(), b.z());
  vertex( c.x(), c.y(), c.z());
  endShape();
}  
void quad3d(Vec a, Vec b, Vec c, Vec d,color couleur) {
  stroke(0, 100, 255);
   fill(couleur);
  beginShape(QUADS);
  vertex( a.x(), a.y(), a.z());
  vertex( b.x(), b.y(), b.z());
  vertex( c.x(), c.y(), c.z());
  vertex( d.x(), d.y(), d.z());  
  endShape();
}     