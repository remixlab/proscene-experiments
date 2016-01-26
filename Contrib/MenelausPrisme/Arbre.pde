public class Arbre {

  InteractiveFrame[] reperes ;
  WorldConstraint baseConstraint;
  LocalConstraint libre, rail, rail4, rail5;
  float rapport2, rapport3;
  Vec posText4, posText5, posText45;


  Arbre() {   
    reperes=new InteractiveFrame[6];
    reperes[0]=new InteractiveFrame(scene);
    reperes[1]=new InteractiveFrame(scene, reperes[0]);   
    reperes[2]=new InteractiveFrame(scene, reperes[0]);   
    reperes[3]=new InteractiveFrame(scene, reperes[0]);
    reperes[4]=new InteractiveFrame(scene, reperes[0]);   
    reperes[5]=new InteractiveFrame(scene, reperes[0]);

    // Initialize frames
    reperes[0].setTranslation(0, 0, 0); 
    reperes[1].setTranslation(20, 30, 240);  
    reperes[2].setTranslation(130, 200, 0);    
    reperes[3].setTranslation(-150, 200, 0);
    reperes[4].setTranslation(45, 100, 0);
    reperes[5].setTranslation(-25, 100, 0);  





    //graphics handers
    reperes[0].addGraphicsHandler(this, "drawBase");
    reperes[1].addGraphicsHandler(this, "drawPiquet1");
    reperes[2].addGraphicsHandler(this, "drawTriangle2");
    reperes[3].addGraphicsHandler(this, "drawTriangle3");
    reperes[4].addGraphicsHandler(this, "drawPiquet4");
    reperes[5].addGraphicsHandler(this, "drawPiquet5");


    // Set frame constraints
    baseConstraint = new WorldConstraint();
    baseConstraint.setTranslationConstraint(AxisPlaneConstraint.Type.FORBIDDEN, new Vec(0.0f, 0.0f, 0.0f));
    baseConstraint.setRotationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(0.0f, 0.0f, 1.0f));
    reperes[0].setConstraint(baseConstraint);

    libre = new LocalConstraint();
    libre.setTranslationConstraint(AxisPlaneConstraint.Type.FREE, new Vec(0.0f, 0.0f, 0.0f));
    libre.setRotationConstraint   (AxisPlaneConstraint.Type.FORBIDDEN, new Vec(0.0f, 0.0f, 0.0f));
    reperes[1].setConstraint(libre);

    rail = new LocalConstraint();
    rail.setTranslationConstraint(AxisPlaneConstraint.Type.AXIS, new Vec(1.0f, 0.0f, 0.0f));
    rail.setRotationConstraint(AxisPlaneConstraint.Type.FORBIDDEN, new Vec(0.0f, 0.0f, 0.0f));
    reperes[2].setConstraint(rail);
    reperes[3].setConstraint(rail);

    rail4 = new LocalConstraint();
    rail4.setTranslationConstraintType(AxisPlaneConstraint.Type.AXIS);
    rail4.setRotationConstraintType(AxisPlaneConstraint.Type.FORBIDDEN);
    reperes[4].setConstraint(rail4);

    rail5 = new LocalConstraint();
    rail5.setTranslationConstraintType(AxisPlaneConstraint.Type.AXIS);
    rail5.setRotationConstraintType(AxisPlaneConstraint.Type.FORBIDDEN);
    reperes[5].setConstraint(rail5);

    rapport2=0.7;
    rapport3=0.2;
  }          

  void drawBase(PGraphics pg) {
    //le sol
    float xx=600;
    float yy=600;
    float zz=-5;
    pg.noStroke();
    pg.beginShape(QUADS);
    pg.fill(255, 180, 140);
    pg.vertex( -xx, -yy, zz);
    pg.vertex( -xx, yy, zz);
    pg.fill(155, 100, 250); 
    pg.vertex( xx, yy, zz);
    pg.fill(200, 200, 255); 
    pg.vertex( xx, -yy, zz);
    pg.endShape();

    // la ligne des centres

    pg.stroke(0, 255, 0);
    pg.strokeWeight(10);
    pg.line(-500, 200, 0, 500, 200, 0);
    pg.strokeWeight(1);
  }

  void drawPiquet1(PGraphics pg) {
    Vec v0=Vec.multiply(reperes[1].translation().get(), -1.0);
    if (scene.mouseAgent().inputGrabber() == reperes[1] )  
      fill(255, 255, 0);
    else 
    fill(0, 255, 0);

    drawLigne(pg, #009900, new Vec(), v0);
    drawSphere(pg, new Vec());
    drawSphere(pg, v0);
  }

  void drawTriangle2(PGraphics pg) {

    if (scene.mouseAgent().inputGrabber() == reperes[4] ) 
      rapport2=1.0-reperes[4].translation().x()/reperes[2].translation().x();
    if (scene.mouseAgent().inputGrabber() == reperes[2] )  
      fill(255, 255, 0);
    else 
    fill(255, 0, 0);

    drawSphere(pg, new Vec());   
    Vec deux0=(reperes[2].translation().get());
    deux0.multiply(-1.0);
    Vec deux1=Vec.add(deux0, reperes[1].translation().get());
    triangle3d(pg, new Vec(0, 0, 0), deux0, deux1);
  }

  void drawTriangle3(PGraphics pg) {
    if ( scene.mouseAgent().inputGrabber() == reperes[5] ) 
      rapport3=1.0-reperes[5].translation().x()/reperes[3].translation().x();
    if (scene.mouseAgent().inputGrabber() == reperes[3] )  
      fill(255, 255, 0);
    else 
    fill(100, 100, 255);
    drawSphere(pg, new Vec()); 
    Vec trois0=(reperes[3].translation().get());
    trois0.multiply(-1.0);
    Vec trois1=Vec.add(trois0, reperes[1].translation().get());
    triangle3d(pg, new Vec(0, 0, 0), trois0, trois1);
  }

  void drawPiquet4(PGraphics pg) {
    rail4.setTranslationConstraintDirection(reperes[2].translation().get());
    reperes[4].setTranslation(Vec.multiply(reperes[2].translation(), 1.0-rapport2));
    if (scene.mouseAgent().inputGrabber() == reperes[4] )  
      fill(255, 255, 0);
    else 
    fill(0);   
    Vec v=reperes[1].translation().get();
    v.multiply(rapport2);
    drawSphere(pg, new Vec());
    drawSphere(pg, v);
    drawLigne(pg, 0, new Vec(), v);
  }

  void drawPiquet5(PGraphics pg) {
    rail5.setTranslationConstraintDirection(reperes[3].translation().get());
    reperes[5].setTranslation(Vec.multiply(reperes[3].translation(), 1.0-rapport3));
    if (scene.mouseAgent().inputGrabber() == reperes[5] )  
      fill(255, 255, 0);
    else 
    fill(0);
    pg.noStroke();
    pg.sphere(6);
    Vec v=reperes[1].translation().get();
    v.multiply(rapport3);
    drawSphere(pg, new Vec());
    drawSphere(pg, v);
    drawLigne(pg, 0, new Vec(), v);
  }



  void CalculDernierTriangle() {
    reperes[0].applyTransformation();

    Vec vv=Vec.multiply(reperes[1].translation().get(), rapport3); 
    Vec ww=Vec.multiply(reperes[1].translation().get(), rapport2);    
    float lambda=rapport3/rapport2;
    Vec td=Vec.subtract(reperes[4].translation(), reperes[5].translation());
    Vec res=Vec.add(reperes[5].translation(), Vec.multiply(td, lambda/(lambda-1.0)));
    Vec v1= Vec.add(reperes[5].translation(), vv);
    Vec v2= Vec.add(reperes[4].translation(), ww);

    drawSphere(#ffffff, res);
    triangle3d( res, reperes[5].translation(), v1, color(255, 0, 255));
    quad3d(reperes[5].translation(), v1, v2, reperes[4].translation(), color(255, 0, 255));

    //mobile sur le dernier triangle
    Vec bar=Vec.add(reperes[5].translation(), Vec.multiply(td, tempo));
    Vec b=Vec.multiply(reperes[1].translation().get(), tempo*rapport2+(1-tempo)*rapport3);   
    posText45=Vec.add(bar, b);
    drawSphere(#ffffff, bar);
    drawSphere(#ffffff, posText45);
    drawLigne(#ffffff, bar, posText45);

    //mobile sur les deux premiers triangles
    Vec v=reperes[4].translation().get();
    v.multiply(1-tempo);
    pushMatrix();
    translate(v.x(), v.y(), v.z());
    fill( 255);
    noStroke();
    sphere(6);
    ww=Vec.multiply(reperes[1].translation().get(), rapport2+tempo*(1-rapport2)); 
    translate(ww.x(), ww.y(), ww.z());
    sphere(6);
    popMatrix();

    posText4=Vec.add(v, ww);
    drawLigne(#ffffff, v, posText4);
    v=reperes[5].translation().get();
    v.multiply(tempo);
    ww=Vec.multiply(reperes[1].translation().get(), 1+tempo*(-1+rapport3));    
    posText5=Vec.add(v, ww);
    drawSphere(#ffffff, v);
    drawSphere(#ffffff, posText5);
    drawLigne(#ffffff, v, posText5);
  }
  void displayText() {
    pushStyle();
    Vec pos;
    scene.beginScreenDrawing();
    textFont(font);
    fill(0,150,0);
    pos = scene.eye().projectedCoordinatesOf(posText4);
    text("homothétie 1-->2", pos.x(), pos.y());
    pos = scene.eye().projectedCoordinatesOf(posText5);
    text("homothétie 2-->3", pos.x(), pos.y());
    pos = scene.eye().projectedCoordinatesOf(posText45);
    text("homothétie 3-->1", pos.x(), pos.y());
    scene.endScreenDrawing();
    popStyle();
  }
}