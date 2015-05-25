/*
 * Marcio Abreu
 * Richar Contreras
 * Universidad Nacional de Colombia
 * 
 * */
/*
 *  Este proyecto se basa en el desarrollo de un modelo de un brazo robótico tipo SCARA, al cual se le aplica cinemática
 * inversa con el fin de que su movimiento sea lo más semejante con las leyes de la física en el mundo real. 
 * Los brazos robots tipo Scara, tienen una parte llamada la muñeca que nos puede servir para orientar el terminal. 
 * Imaginemos que el brazo robótico toma un objeto y quiere poder transladarlo a otro lugar con un ángulo determinado. La muñeca se encargará de ello.
 * En el brazo Scara tenemos que resolver los dos ángulos de las articulaciones. 
 * En este tipo de brazos el eje Z no interviene en la cinemática inversa porque es un resultado en sí mismo. 
 * Desde el punto de vista del cálculo sólo tenemos en cuenta los ejes X e Y,  y la longitud de las articulaciones.
 */

import remixlab.proscene.*;
import remixlab.dandelion.core.*;
import remixlab.dandelion.geom.*;
import remixlab.dandelion.core.Constants.*;

float   Pi, degToRad, wristAng, tweezersAng, orientationAng, armAng, forearmAng, wristIncl, tweezersIncl;
Integer  armLen, forearmLen, wristLen, tweezersLen, robotHeight;
float targetX, targetY, targetZ;
float lastTargetX, lastTargetY, lastTargetZ;
float   robotHeightScaled, armLenScaled, forearmLenScaled, wristLenScaled, tweezersLenScaled, tweezersDistance=(float)0.11, limitValue;
float lastValueX, lastValueY, lastValueZ, lastValueW, lastValueT;

Scene scene;
InteractiveFrame repere;
boolean mode=true;
PShape parts, floor, shoulder, arm, foreArm, wrist, sph, sph2, sph3, cube;

public void setup() {
  size( 640, 640, P3D ); 

  ///SCENE SETUP///
  scene=new Scene(this); 
  scene.setRadius(800);
  scene.setGridVisualHint(true);
  scene.setAxesVisualHint(true);
  scene.camera().setPosition(new Vec(650, 0, -500));
  scene.camera().setOrientation(-(float)0.3, PI);
  scene.setVisualHints(Scene.PICKING);
  frame.setTitle(("fps retained: " + nf(0, 3, 5)));

  ///INTERACTIVE FRAME///
  repere=new InteractiveFrame(scene);

  ///FRAME RATE///
  frameRate(100);

  ///INPUT SETUP///
  setExoticCustomization();

  ///INITIALIZE MODEL VALUES///
  Pi   = PI;
  degToRad  = Pi  / 180;

  robotHeight   = 200;    
  armLen = 250;    
  forearmLen = 300;    
  wristLen = 100;  
  tweezersLen =  50;  

  targetX=300;         
  targetY=0;         
  targetZ=150;   
  lastTargetX=0;         
  lastTargetY=0;         
  lastTargetZ=0;
  tweezersAng=-90;       
  wristAng=0;

  robotHeightScaled    = robotHeight  /100;
  armLenScaled     = armLen/100;  
  forearmLenScaled     = forearmLen/100;   
  wristLenScaled     = wristLen/100;  
  tweezersLenScaled     = tweezersLen/100;  
  limitValue    = armLenScaled+forearmLenScaled;  

  floor = drawFloor();      
  shoulder = drawShoulder();

  sph = createShape(SPHERE, (float)0.6);
  sph.setStroke(false);
  sph.setFill(color(0, 0, 0));
  arm = drawArm();

  sph2 = createShape(SPHERE, (float)0.5);
  sph2.setStroke(false);
  sph2.setFill(color(0, 0, 0));
  foreArm = drawForearm();

  sph3 = createShape(SPHERE, (float)0.4);
  sph3.setStroke(false);
  sph3.setFill(color(0, 0, 0));
  wrist = drawWrist();
  cube = createShape(BOX, (float)0.5, (float).3, (float).3);
  cube.setStroke(false);
  cube.setFill(color(200, 200, 200));
}

public void draw() {    
  /*
    if(!mode){
   frame.setTitle(("fps retained: " + nf(frameRate, 3, 5)));
   pushMatrix();
   rotate(PI,PI,0,PI/2);
   fill(225);
   textSize(30);
   text("fps retained: " + nf(frameRate, 3, 5), -200, -420);
   popMatrix();
   }
   */

  ///GET TARGET COORDINATES///
  targetX = -repere.coordinatesOf(new Vec()).x();
  targetY = repere.coordinatesOf(new Vec()).z();
  targetZ = -repere.coordinatesOf(new Vec()).y()+200;

  //Se verifica si hubo algún cambio en alguna de las partes del robot para dibujar nuevamente
  if ((mode==false) && (targetX == lastTargetX) && (targetY == lastTargetY) && (targetZ == lastTargetZ)) {
    lastTargetX = targetX;
    lastTargetY = targetY;
    lastTargetZ = targetZ;
    //return;
    //Esto es una optimización del código para ambos modos, sin
    //embargo la cámara no es totalmente funcional en el modo
    //retenido --- pendiente para un futuras mejoras --- quitar
    //comentario al principio del draw eliminar código equivalente
    //al final del mismo, de esa manera se mantiene el efecto de luz
  }     

  lastTargetX = targetX;
  lastTargetY = targetY;
  lastTargetZ = targetZ;

  ///LIGHTS SETUP///
  background(255);
  lightSpecular(200, 200, 200);
  directionalLight(204, 204, 204, 0, 0, -1);
  directionalLight(204, 204, 204, 0, 0, 1);

  ///CALCULATE INVERSE KINEMATICS///
  InverseK();    

  ///DRAW INTERACTIVE FRAME///
  pushMatrix();
  scene.applyModelView(repere.matrix()); 
  if (repere.grabsInput(scene.motionAgent())) {
    fill(255, 0, 0, 5);
    sphere(100);
    ;
  } else {
    fill(0, 0, 255, 5);
    sphere(100);
  }  
  popMatrix();
  ///END DRAW INTERACTIVE FRAME///    

  scene.beginScreenDrawing();
  fill(225);
  textSize(30);
  if (mode) 
    text("fps immediate: " + nf(frameRate, 3, 5), 100, 30);
  else
    text("fps retained: " + nf(frameRate, 3, 5), 100, 30);
  scene.endScreenDrawing();
}

//Se dibujan cada una de las partes del brazo con sus respectivas translaciones y rotaciones para
//que todo encaje perfectamente.
public void drawModel() {
  background(15);
  pushMatrix();
  scale(30*(float)(1/.3));

  ///FLOOR//
  stroke(10, 10, 10);
  noStroke();
  fill(10, 10, 10);
  beginShape(QUAD);                                                                                                       
  vertex((float)5.0, -robotHeightScaled, (float)5.0);     
  vertex((float)-5.0, -robotHeightScaled, (float)5.0);        
  vertex((float)-5.0, -robotHeightScaled, (float)-5.0);         
  vertex((float)5.0, -robotHeightScaled, (float)-5.0);         
  endShape();  
  ///END FLOOR///

  ///SHOULDER///  
  rotate(orientationAng, (float)0.0, (float)1.0, (float)0.0 );   
  stroke(20, 255, 20);
  noStroke();
  fill(0, 80, 0);
  beginShape(QUAD);                           
  vertex( (float)0.4, (float)0.0, -(float)0.6);           
  vertex(-(float)0.4, (float)0.0, -(float)0.6);  
  vertex(-(float)0.4, (float)0.0, (float)0.6);    
  vertex( (float)0.4, (float)0.0, (float)0.6);   
  vertex( (float)0.4, -robotHeightScaled, (float)0.6);       
  vertex(-(float)0.4, -robotHeightScaled, (float)0.6);       
  vertex(-(float)0.4, -robotHeightScaled, -(float)0.6);                       
  vertex( (float)0.4, -robotHeightScaled, -(float)0.6); 
  vertex((float) (float)0.4, (float)0.0, (float)0.6);
  vertex(-(float)0.4, (float)0.0, (float)0.6);                      
  vertex(-(float)0.4, -robotHeightScaled, (float)0.6);                     
  vertex( (float)0.4, -robotHeightScaled, (float)0.6);                                             
  vertex( (float)0.4, -robotHeightScaled, -(float)0.6);                     
  vertex(-(float)0.4, -robotHeightScaled, -(float)0.6);                         
  vertex(-(float)0.4, (float)0.0, -(float)0.6 );                      
  vertex( (float)0.4, (float)0.0, -(float)0.6 );                                          
  vertex(-(float)0.4, (float)0.0, (float)0.6 );                        
  vertex(-(float)0.4, (float)0.0, -(float)0.6 );                         
  vertex(-(float)0.4, -robotHeightScaled, -(float)0.6 );                       
  vertex(-(float)0.4, -robotHeightScaled, (float)0.6 );                                               
  vertex( (float)0.4, (float)0.0, -(float)0.6);                         
  vertex( (float)0.4, (float)0.0, (float)0.6  );                          
  vertex( (float)0.4, -robotHeightScaled, (float)0.6);                 
  vertex( (float)0.4, -robotHeightScaled, -(float)0.6);
  endShape();
  ///END SHOULDER///

  ///ARM///
  translate((float)0.0, (float)0.0, (float)0.0);
  rotate(armAng, (float)0.0, (float)0.0, (float)1.0);
  stroke(0, 0, 0);
  noStroke();
  fill(0, 0, 0);
  sphere((float)0.6);                       
  stroke(20, 255, 20);
  noStroke();
  fill(0, 80, 0);                                                 
  beginShape(QUAD);
  vertex(armLenScaled, (float)0.3, -(float)0.4);                          
  vertex((float)0.0, (float)0.3, -(float)0.4);                        
  vertex((float)0.0, (float)0.3, (float)0.4);                           
  vertex(armLenScaled, (float)0.3, (float)0.4);                                 
  vertex(armLenScaled, -(float)0.3, (float)0.4);                    
  vertex((float)0.0, -(float)0.3, (float)0.4);                   
  vertex((float)0.0, -(float)0.3, -(float)0.4);                   
  vertex(armLenScaled, -(float)0.3, -(float)0.4);                                       
  vertex(armLenScaled, (float)0.3, (float)0.4);                        
  vertex((float)0.0, (float)0.3, (float)0.4);                       
  vertex((float)0.0, -(float)0.3, (float)0.4);                       
  vertex(armLenScaled, -(float)0.3, (float)0.4);                                           
  vertex(armLenScaled, -(float)0.3, -(float)0.4);                        
  vertex((float)0.0, -(float)0.3, -(float)0.4);                      
  vertex((float)0.0, (float)0.3, -(float)0.4);                        
  vertex(armLenScaled, (float)0.3, -(float)0.4);                                             
  vertex((float)0.0, (float)0.3, (float)0.4);                         
  vertex((float)0.0, (float)0.3, -(float)0.4);                        
  vertex((float)0.0, -(float)0.3, -(float)0.4);                        
  vertex((float)0.0, -(float)0.3, (float)0.4);                                           
  vertex(armLenScaled, (float)0.3, -(float)0.4);                          
  vertex(armLenScaled, (float)0.3, (float)0.4);     
  vertex(armLenScaled, -(float)0.3, (float)0.4);
  vertex(armLenScaled, -(float)0.3, -(float)0.4); 
  endShape();
  ///END ARM///

  ///FOREARM///
  translate(armLenScaled, (float)0.0, (float)0.0);
  rotate(forearmAng, (float)0.0, (float)0.0, (float)1.0);
  stroke(0, 0, 0);
  noStroke();
  fill(0, 0, 0);
  sphere((float)0.5);
  stroke(20, 255, 20);
  noStroke();
  fill(0, 80, 0);
  beginShape(QUAD);      
  vertex(forearmLenScaled, (float)0.3, -(float)0.3);
  vertex((float)0.0, (float)0.3, -(float)0.3);
  vertex((float)0.0, (float)0.3, (float)0.3);
  vertex(forearmLenScaled, (float)0.3, (float)0.3);
  vertex(forearmLenScaled, -(float)0.3, (float)0.3);
  vertex((float)0.0, -(float)0.3, (float)0.3);
  vertex((float)0.0, -(float)0.3, -(float)0.3);
  vertex(forearmLenScaled, -(float)0.3, -(float)0.3);
  vertex(forearmLenScaled, (float)0.3, (float)0.3);
  vertex((float)0.0, (float)0.3, (float)0.3);
  vertex((float)0.0, -(float)0.3, (float)0.3);
  vertex(forearmLenScaled, -(float)0.3, (float)0.3);
  vertex(forearmLenScaled, -(float)0.3, -(float)0.3);
  vertex((float)0.0, -(float)0.3, -(float)0.3);
  vertex((float)0.0, (float)0.3, -(float)0.3);
  vertex(forearmLenScaled, (float)0.3, -(float)0.3);
  vertex((float)0.0, (float)0.3, (float)0.3);
  vertex((float)0.0, (float)0.3, -(float)0.3);
  vertex((float)0.0, -(float)0.3, -(float)0.3);
  vertex((float)0.0, -(float)0.3, (float)0.3);
  vertex(forearmLenScaled, (float)0.3, -(float)0.3);
  vertex(forearmLenScaled, (float)0.3, (float)0.3);
  vertex(forearmLenScaled, -(float)0.3, (float)0.3);
  vertex(forearmLenScaled, -(float)0.3, -(float)0.3);
  endShape();
  ///END FOREARM///

  ///WRIST///
  translate(forearmLenScaled, (float)0.0, (float)0.0);
  rotate(wristIncl, (float)0.0, (float)0.0, (float)1.0);
  rotate(tweezersIncl, (float)1.0, (float)0.0, (float)0.0);
  stroke(0, 0, 0);
  noStroke();
  fill(0, 0, 0);
  sphere ((float)0.4);
  stroke(20, 255, 20);
  noStroke();
  fill(0, 80, 0);                                            
  beginShape(QUAD);    
  vertex(wristLenScaled, (float)0.3, -(float)0.2);
  vertex((float)0.0, (float)0.3, -(float)0.2);
  vertex((float)0.0, (float)0.3, (float)0.2);
  vertex(wristLenScaled, (float)0.3, (float)0.2);
  vertex(wristLenScaled, -(float)0.3, (float)0.2);
  vertex((float)0.0, -(float)0.3, (float)0.2);
  vertex((float)0.0, -(float)0.3, -(float)0.2);
  vertex(wristLenScaled, -(float)0.3, -(float)0.2);
  vertex(wristLenScaled, (float)0.3, (float)0.2);
  vertex((float)0.0, (float)0.3, (float)0.2);
  vertex((float)0.0, -(float)0.3, (float)0.2);
  vertex(wristLenScaled, -(float)0.3, (float)0.2);
  vertex(wristLenScaled, -(float)0.3, -(float)0.2);
  vertex((float)0.0, -(float)0.3, -(float)0.2);
  vertex((float)0.0, (float)0.3, -(float)0.2);
  vertex(wristLenScaled, (float)0.3, -(float)0.2);
  vertex((float)0.0, (float)0.3, (float)0.2);
  vertex((float)0.0, (float)0.3, -(float)0.2);
  vertex((float)0.0, -(float)0.3, -(float)0.2);
  vertex((float)0.0, -(float)0.3, (float)0.2);
  vertex(wristLenScaled, (float)0.3, -(float)0.2);
  vertex(wristLenScaled, (float)0.3, (float)0.2);
  vertex(wristLenScaled, -(float)0.3, (float)0.2);
  vertex(wristLenScaled, -(float)0.3, -(float)0.2);
  endShape();   
  ///END WRIST///

  ///TWEEZERS//
  translate(wristLenScaled, (float)0.0, tweezersDistance*2);
  stroke(125, 125, 125);     
  noStroke(); 
  fill(200, 200, 200);
  box((float)0.5, (float).3, (float).3);
  translate( (float)0, (float)0.0, tweezersDistance*(-4));
  stroke(0, 0, 0);    
  noStroke(); 
  box((float)0.5, (float).3, (float).3);
  ///END TWEEZERS///

  popMatrix();
}

// Se implementa una función para cada parte del brazo robótico, para cuando
// se este dibujando en modo retenido
public PShape drawFloor() {

  PShape part = createShape();
  ///FLOOR//
  part.beginShape(QUAD);
  part.stroke(10, 10, 10);
  part.noStroke();
  part.fill(10, 10, 10);
  part.vertex((float)5.0, -robotHeightScaled, (float)5.0);     
  part.vertex((float)-5.0, -robotHeightScaled, (float)5.0);        
  part.vertex((float)-5.0, -robotHeightScaled, (float)-5.0);         
  part.vertex((float)5.0, -robotHeightScaled, (float)-5.0);         
  part.endShape();  
  ///END FLOOR///   

  return part;
}

public PShape drawShoulder() {
  PShape part = createShape();

  ///SHOULDER///  
  part.beginShape(QUAD);      

  part.stroke(20, 255, 20);
  part.noStroke();
  part.fill(0, 80, 0);
  part.vertex( (float)0.4, (float)0.0, -(float)0.6);           
  part.vertex(-(float)0.4, (float)0.0, -(float)0.6);  
  part.vertex(-(float)0.4, (float)0.0, (float)0.6);    
  part.vertex( (float)0.4, (float)0.0, (float)0.6);   
  part.vertex( (float)0.4, -robotHeightScaled, (float)0.6);       
  part.vertex(-(float)0.4, -robotHeightScaled, (float)0.6);       
  part.vertex(-(float)0.4, -robotHeightScaled, -(float)0.6);                       
  part.vertex( (float)0.4, -robotHeightScaled, -(float)0.6); 
  part.vertex((float) (float)0.4, (float)0.0, (float)0.6);
  part.vertex(-(float)0.4, (float)0.0, (float)0.6);                      
  part.vertex(-(float)0.4, -robotHeightScaled, (float)0.6);                     
  part.vertex( (float)0.4, -robotHeightScaled, (float)0.6);                                             
  part.vertex( (float)0.4, -robotHeightScaled, -(float)0.6);                     
  part.vertex(-(float)0.4, -robotHeightScaled, -(float)0.6);                         
  part.vertex(-(float)0.4, (float)0.0, -(float)0.6 );                      
  part.vertex( (float)0.4, (float)0.0, -(float)0.6 );                                          
  part.vertex(-(float)0.4, (float)0.0, (float)0.6 );                        
  part.vertex(-(float)0.4, (float)0.0, -(float)0.6 );                         
  part.vertex(-(float)0.4, -robotHeightScaled, -(float)0.6 );                       
  part.vertex(-(float)0.4, -robotHeightScaled, (float)0.6 );                                               
  part.vertex( (float)0.4, (float)0.0, -(float)0.6);                         
  part.vertex( (float)0.4, (float)0.0, (float)0.6  );                          
  part.vertex( (float)0.4, -robotHeightScaled, (float)0.6);                 
  part.vertex( (float)0.4, -robotHeightScaled, -(float)0.6);
  part.endShape();
  ///END SHOULDER///
  return part;
}

public PShape drawArm() {
  PShape part= createShape();
  ///ARM///

  part.beginShape(QUAD);
  part.stroke(20, 255, 20);
  part.noStroke();
  part.fill(0, 80, 0);
  part.vertex(armLenScaled, (float)0.3, -(float)0.4);                          
  part.vertex((float)0.0, (float)0.3, -(float)0.4);                        
  part.vertex((float)0.0, (float)0.3, (float)0.4);                           
  part.vertex(armLenScaled, (float)0.3, (float)0.4);                                 
  part.vertex(armLenScaled, -(float)0.3, (float)0.4);                    
  part.vertex((float)0.0, -(float)0.3, (float)0.4);                   
  part.vertex((float)0.0, -(float)0.3, -(float)0.4);                   
  part.vertex(armLenScaled, -(float)0.3, -(float)0.4);                                       
  part.vertex(armLenScaled, (float)0.3, (float)0.4);                        
  part.vertex((float)0.0, (float)0.3, (float)0.4);                       
  part.vertex((float)0.0, -(float)0.3, (float)0.4);                       
  part.vertex(armLenScaled, -(float)0.3, (float)0.4);                                           
  part.vertex(armLenScaled, -(float)0.3, -(float)0.4);                        
  part.vertex((float)0.0, -(float)0.3, -(float)0.4);                      
  part.vertex((float)0.0, (float)0.3, -(float)0.4);                        
  part.vertex(armLenScaled, (float)0.3, -(float)0.4);                                             
  part.vertex((float)0.0, (float)0.3, (float)0.4);                         
  part.vertex((float)0.0, (float)0.3, -(float)0.4);                        
  part.vertex((float)0.0, -(float)0.3, -(float)0.4);                        
  part.vertex((float)0.0, -(float)0.3, (float)0.4);                                           
  part.vertex(armLenScaled, (float)0.3, -(float)0.4);                          
  part.vertex(armLenScaled, (float)0.3, (float)0.4);     
  part.vertex(armLenScaled, -(float)0.3, (float)0.4);
  part.vertex(armLenScaled, -(float)0.3, -(float)0.4); 
  part.endShape();
  ///END ARM///

  return part;
}

public PShape drawForearm() {
  PShape part = createShape();

  ///FOREARM///
  
  part.beginShape(QUAD);  
  part.stroke(20, 255, 20);
  part.noStroke();
  part.fill(0, 80, 0);
  part.vertex(forearmLenScaled, (float)0.3, -(float)0.3);
  part.vertex((float)0.0, (float)0.3, -(float)0.3);
  part.vertex((float)0.0, (float)0.3, (float)0.3);
  part.vertex(forearmLenScaled, (float)0.3, (float)0.3);
  part.vertex(forearmLenScaled, -(float)0.3, (float)0.3);
  part.vertex((float)0.0, -(float)0.3, (float)0.3);
  part.vertex((float)0.0, -(float)0.3, -(float)0.3);
  part.vertex(forearmLenScaled, -(float)0.3, -(float)0.3);
  part.vertex(forearmLenScaled, (float)0.3, (float)0.3);
  part.vertex((float)0.0, (float)0.3, (float)0.3);
  part.vertex((float)0.0, -(float)0.3, (float)0.3);
  part.vertex(forearmLenScaled, -(float)0.3, (float)0.3);
  part.vertex(forearmLenScaled, -(float)0.3, -(float)0.3);
  part.vertex((float)0.0, -(float)0.3, -(float)0.3);
  part.vertex((float)0.0, (float)0.3, -(float)0.3);
  part.vertex(forearmLenScaled, (float)0.3, -(float)0.3);
  part.vertex((float)0.0, (float)0.3, (float)0.3);
  part.vertex((float)0.0, (float)0.3, -(float)0.3);
  part.vertex((float)0.0, -(float)0.3, -(float)0.3);
  part.vertex((float)0.0, -(float)0.3, (float)0.3);
  part.vertex(forearmLenScaled, (float)0.3, -(float)0.3);
  part.vertex(forearmLenScaled, (float)0.3, (float)0.3);
  part.vertex(forearmLenScaled, -(float)0.3, (float)0.3);
  part.vertex(forearmLenScaled, -(float)0.3, -(float)0.3);
  part.endShape();
  ///END FOREARM///

  return part;
}
public PShape drawWrist() {
  PShape part = createShape();

  ///WRIST///

  part.beginShape(QUAD);    
  part.stroke(20, 255, 20);
  part.noStroke();
  part.fill(0, 80, 0);  
  part.vertex(wristLenScaled, (float)0.3, -(float)0.2);
  part.vertex((float)0.0, (float)0.3, -(float)0.2);
  part.vertex((float)0.0, (float)0.3, (float)0.2);
  part.vertex(wristLenScaled, (float)0.3, (float)0.2);
  part.vertex(wristLenScaled, -(float)0.3, (float)0.2);
  part.vertex((float)0.0, -(float)0.3, (float)0.2);
  part.vertex((float)0.0, -(float)0.3, -(float)0.2);
  part.vertex(wristLenScaled, -(float)0.3, -(float)0.2);
  part.vertex(wristLenScaled, (float)0.3, (float)0.2);
  part.vertex((float)0.0, (float)0.3, (float)0.2);
  part.vertex((float)0.0, -(float)0.3, (float)0.2);
  part.vertex(wristLenScaled, -(float)0.3, (float)0.2);
  part.vertex(wristLenScaled, -(float)0.3, -(float)0.2);
  part.vertex((float)0.0, -(float)0.3, -(float)0.2);
  part.vertex((float)0.0, (float)0.3, -(float)0.2);
  part.vertex(wristLenScaled, (float)0.3, -(float)0.2);
  part.vertex((float)0.0, (float)0.3, (float)0.2);
  part.vertex((float)0.0, (float)0.3, -(float)0.2);
  part.vertex((float)0.0, -(float)0.3, -(float)0.2);
  part.vertex((float)0.0, -(float)0.3, (float)0.2);
  part.vertex(wristLenScaled, (float)0.3, -(float)0.2);
  part.vertex(wristLenScaled, (float)0.3, (float)0.2);
  part.vertex(wristLenScaled, -(float)0.3, (float)0.2);
  part.vertex(wristLenScaled, -(float)0.3, -(float)0.2);
  part.endShape();   
  ///END WRIST///
  return part;
}

public void setExoticCustomization() {
  ///EYE///
  scene.mouseAgent().setButtonBinding(Target.EYE, CENTER, DOF2Action.ZOOM_ON_ANCHOR);
  scene.mouseAgent().setButtonBinding(Target.EYE, LEFT, DOF2Action.TRANSLATE);
  scene.mouseAgent().setButtonBinding(Target.EYE, RIGHT, DOF2Action.ROTATE_CAD);
  ///INTERACTIVE FRAME///
  scene.mouseAgent().setButtonBinding(Target.FRAME, LEFT, DOF2Action.TRANSLATE);
  scene.mouseAgent().setButtonBinding(Target.FRAME, CENTER, DOF2Action.SCALE);
  scene.mouseAgent().setWheelBinding(Target.FRAME, DOF1Action.TRANSLATE_Z);
  scene.mouseAgent().setButtonBinding(Target.FRAME, RIGHT, null);
  ///KEYBOARD///
  //TODO restore pending until keys(char) are back!
  /*
  scene.setKeyboardShortcut('S', null);
  scene.setKeyboardShortcut('g', KeyboardAction.TOGGLE_AXES_VISUAL_HINT);
  */
}

public void keyPressed() {
  if (key =='A') {
    wristAng=wristAng-(float).5;
  }   
  if (key =='S') {
    wristAng=wristAng+(float).5;
  }
  if (key =='Z') {
    tweezersAng=tweezersAng-(float).5;
  }   
  if (key =='X') {
    tweezersAng=tweezersAng+(float).5;
  } 
  if (key =='N') {
    if (tweezersDistance>.11) {
      tweezersDistance=tweezersDistance-(float).005;
    }
  }
  if (key =='M') {
    if (tweezersDistance<.15) {
      tweezersDistance=tweezersDistance+(float).005;
    }
  }
  if (key == '1') {
    setExoticCustomization();
    mode=true;
  }
  if (key == '2') {
    //scene.setMouseButtonBinding(Target.EYE, CENTER, null);
    //scene.setMouseButtonBinding(Target.EYE, LEFT, null);
    //scene.setMouseButtonBinding(Target.EYE, RIGHT, null);
    mode=false;
  }
}

void InverseK() {  
  float   Afx, Afy, LadoA, LadoB, Alfa, Beta, Gamma, Modulo, Hypot, Xprime, Yprime;

  ///ORIENTATION///
  //Se halla el ángulo de giro de todo el brazo
  orientationAng = (atan2(targetY, targetX)); 

  ///COMPUTE VALUES///
  /*
        * Se va a hacer una especie de equivalencia, donde se tendrán que calcular un eje X ficticio
   * y otro eje Y ficticio; se llamarán Xprime e Yprime. Estas variables en realidad 
   * son los ejes X e Y visto en dos dimensiones.
   * */

  /*
        * Primeramente  se tiene que calcular el módulo formado por los catetos X e Y:
   */
  Modulo  = sqrt(abs(pow(targetX, 2))+abs(pow(targetY, 2))); 

  /*
        * Después se hace una reconversión de variables Xprime y Yprime, las cuales nos hará de puente para hacer el calculo de los ángulos que veremos más adelante.
   */
  Xprime=Modulo;
  Yprime=targetZ;
  Afx=cos(degToRad*tweezersAng)*(wristLen+tweezersLen);
  LadoB=Xprime-Afx;
  Afy=sin(degToRad*tweezersAng)*(wristLen+tweezersLen);
  LadoA=Yprime-Afy-robotHeight;
  Hypot=sqrt((pow(LadoA, 2))+(pow(LadoB, 2)));

  /*
        * Se usa la función Atan2(Y, X). Debido a que tiene en cuenta de los signos contenidos
   * en los valores X e Y, tiene presente además el cuadrante en el que se encuentra
   * y puede recorrer los cuatro cuadrantes.
   */
  Alfa=atan2(LadoA, LadoB);
  Beta=acos( ((pow(armLen, 2))-(pow(forearmLen, 2))+(pow(Hypot, 2)))/(2*armLen*Hypot) );

  /*
        * El triángulo formado por el brazo, ante brazo e Hipotenusa suele ser del tipo irregular, 
   * sobre todo si los dos catetos (brazo y ante brazo) no son iguales. 
   * Para resolver los ángulos de este tipo de triángulo hay que aplicar el Teorema del Coseno.
   */
  ///ARM ANGLE//
  armAng= (Alfa+Beta);
  Gamma=acos( ((pow(armLen, 2))+(pow(forearmLen, 2))-(pow(Hypot, 2)))/(2*armLen*forearmLen) );

  ///FOREARM ANGLE///-
  forearmAng=(-((180*degToRad)-Gamma));

  /*
       * el ángulo de cabeceo, es el ángulo que se le da al brazo para que esa posición se mantenga constante 
   * desde el punto de vista del observador, aunque el brazo se mueva a otra posición. 
   */
  ///WRIST ANGLE///
  wristIncl= (tweezersAng*degToRad-armAng-forearmAng);

  ///TWEEZERS ANGLE///
  tweezersIncl= wristAng;    

  ///CHECK IF NEW POSITION IS A FEASIBLE SOLUTION//
  ///IF NOT, GO BACK TO LAST FEASIBLE SOLUTION///
  if ((Float.toString(armAng).equals("NaN")) || (Float.toString(forearmAng).equals("NaN")) || tweezersAng<-135 || tweezersAng >-30) {    
    targetX=lastValueX;     
    targetY=lastValueY;
    targetZ=lastValueZ;
    wristAng=lastValueW;
    tweezersAng=lastValueT;
    InverseK();
  } 
  ///RE-DRAW OTHERWISE//
  lastValueX=targetX;
  lastValueY=targetY;
  lastValueZ=targetZ;
  lastValueW=wristAng;
  lastValueT=tweezersAng;
  if (mode) {  
    drawModel();
  } else {        
    drawParts();
  }
}

public void drawParts() {
  background(15);
  
  pushMatrix();
  scale(100);
  shape(floor);

  rotate(orientationAng, (float)0.0, (float)1.0, (float)0.0 ); 
  shape(shoulder);

  translate((float)0.0, (float)0.0, (float)0.0);
  rotate(armAng, (float)0.0, (float)0.0, (float)1.0);
  stroke(0, 0, 0);
  noStroke();
  fill(0, 0, 0);

  shape(sph);
  shape(arm);

  translate(armLenScaled, (float)0.0, (float)0.0);
  rotate(forearmAng, (float)0.0, (float)0.0, (float)1.0);
  stroke(0, 0, 0);
  noStroke();
  fill(0, 0, 0);
  shape(sph2);
  shape(foreArm);

  translate(forearmLenScaled, (float)0.0, (float)0.0);
  rotate(wristIncl, (float)0.0, (float)0.0, (float)1.0);
  rotate(tweezersIncl, (float)1.0, (float)0.0, (float)0.0);
  stroke(0, 0, 0);
  noStroke();
  fill(0, 0, 0);
  shape(sph3);
  shape(wrist);

  translate(wristLenScaled, (float)0.0, tweezersDistance*2);
  stroke(125, 125, 125);     
  noStroke(); 
  fill(200, 200, 200);
  shape(cube);
  translate( (float)0, (float)0.0, tweezersDistance*(-4));
  stroke(0, 0, 0);    
  noStroke(); 
  shape(cube);
  popMatrix();
}