/**
 * Lego example
 * by Juan Carlos Cabrera and Diego Alexander Huerfano.
 * 
 * This example was designed and developed as a course project of the Visual Computing subject
 * directed by Jean Pierre Charalambos at Universidad Nacional de Colombia.
 * 
 * It was intented to represent the famous Lego game in a virtual environment which allows us to 
 * build all kind of models such that they are doable in the real game with these 10 basic chips.

 * The world of the game was modeled as a 3D matrix so that users move and locate the chips around
 * the space in a discrete way. It allows to validate moves and rotate chips in intervals of 90 degrees.
 * In adittion, it was done a procedure which makes chips fall down on the floor.
 *
 * The chip images was downloaded from the web site "http://www.juguetes.es/marcas-juguetes/lego/" and 
 * they were modified for visual purposes.
 *
 * Contact: juccabreraca@unal.edu.co and dahuerfanov@unal.edu.co
 */

import java.util.*;
import remixlab.proscene.*;
import remixlab.bias.core.*;
import remixlab.bias.event.*;
import remixlab.dandelion.geom.*;

//TODO partially broken. Fix me!

final int unit = 10, dim=40;

Scene scene;
PGraphics canvas;
PImage cube1, cube2, cube4, cube4L, cube8, cube16, cube1P, cube4LP, cube4P, cube8P;
PImage [] colors;
PImage icon;

ArrayList<ChipFrame> chips = new ArrayList<ChipFrame>();

boolean [] rectOver;
boolean [] colorOver;
int [] cubeTra;
int [] actualColor; 

void setup() {
  size(1000, 600, P3D);
  
  cubeTra = new int[10];
  rectOver = new boolean[10];
  colorOver = new boolean[10];
  colors = new PImage[10];
  actualColor = new int[3];
  
  actualColor[0] = 255;
  actualColor[1] = 255;
  actualColor[2] = 0;
  
  canvas = createGraphics(680, 600, P3D);
  canvas.smooth();
  scene = new Scene(this,canvas,320,0);
  
  scene.setAxesVisualHint(false);
  scene.disableKeyboardAgent();
  
  cube1 = loadImage("image/Cubo1.png" );
  cube2 = loadImage("image/Cubo2.png" );
  cube4 = loadImage("image/Cubo4.png" );
  cube4L = loadImage("image/Cubo4L.png"); 
  cube8 = loadImage("image/Cubo8.png");
  cube16 = loadImage("image/Cubo16.png");
  
  cube1P = loadImage("image/Cubo1P.png");
  cube4LP = loadImage("image/Cubo4LP.png");
  cube4P = loadImage("image/Cubo4P.png");
  cube8P = loadImage("image/Cubo8P.png");

  colors[0] = loadImage("image/Blanco.png");
  colors[1] = loadImage("image/Rojo.png");
  colors[2] = loadImage("image/Amarillo.png");
  colors[3] = loadImage("image/Naranja.png");
  colors[4] = loadImage("image/Azul.png");
  colors[5] = loadImage("image/Gris.png");
  colors[6] = loadImage("image/Morado.png");
  colors[7] = loadImage("image/RojoOscuro.png");
  colors[8] = loadImage("image/Verde.png");
  colors[9] = loadImage("image/VerdeClarito.png");
  
  icon = loadImage("image/Marca.png");
}

void draw() {
  background(255);
  update(mouseX,mouseY);
  canvas.beginDraw();
  scene.beginDraw();
  canvas.background(255);
  scene.drawFrames();
  updatePickedModelColor();
  drawPanel();
  scene.pg().translate(dim/2*unit,dim/2*unit, -2.5);
  scene.pg().box(dim*unit, dim*unit,5);
  
  // We draw the grid lines of the floor.
  for( int i=-dim/2; i<=dim/2; i++) {
      scene.pg().line(i*unit,-dim/2*unit,3,i*unit,dim/2*unit,3);
      scene.pg().line(-dim/2*unit,i*unit,3,dim/2*unit,i*unit,3);
  }
  scene.endDraw();
  canvas.endDraw();
  image(canvas, 320, 0);
}


// This method tells us if there is a chip in the (0,0,0) position.
boolean itsFree(int x, int y, int z) {
  for(ChipFrame chip : chips ) {
     if( chip.getPositionX()<x && chip.getPositionY()<y && chip.getPositionZ()<z ) {
        return false;
     }
  } 
  return true; 
}

void mouseClicked() {
  if (rectOver[0] && itsFree(unit, unit, 2*unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, unit, unit, 2*unit), actualColor, unit, unit, 2*unit)); 
     chips.get(chips.size()-1).setPosition2(unit*0.5, unit*0.5, unit);
  }
  
  if (rectOver[1] && itsFree(unit, 2*unit, 2*unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, unit, 2*unit, 2*unit), actualColor, unit, 2*unit, 2*unit));
    chips.get(chips.size()-1).setPosition2(unit*0.5, unit, unit); 
  }
  
  if (rectOver[2] && itsFree(2*unit, 2*unit, 2*unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, 2*unit, 2*unit, 2*unit), actualColor, 2*unit, 2*unit, 2*unit));
     chips.get(chips.size()-1).setPosition2(unit, unit, unit); 
  }
  
  if (rectOver[3] && itsFree(4*unit, 2*unit, 2*unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, 4*unit, 2*unit, 2*unit), actualColor, 4*unit, 2*unit, 2*unit));
    chips.get(chips.size()-1).setPosition2(unit*2, unit, unit); 
  }
  
  if (rectOver[4] && itsFree(8*unit, 2*unit, 2*unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, 8*unit, 2*unit, 2*unit), actualColor, 8*unit, 2*unit, 2*unit));
    chips.get(chips.size()-1).setPosition2(unit*4, unit, unit); 
  }
  
  if (rectOver[5] && itsFree(unit, unit, unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, unit, unit, unit), actualColor, unit, unit, unit));
    chips.get(chips.size()-1).setPosition2(unit*0.5, unit*0.5, unit*0.5); 
  }
  
  if (rectOver[6] && itsFree(unit, 4*unit, 2*unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, unit, 4*unit, 2*unit), actualColor, unit, 4*unit, 2*unit));
    chips.get(chips.size()-1).setPosition2(unit*0.5, unit*2, unit); 
  }
  
  if (rectOver[7] && itsFree(unit, 4*unit, unit) ) {
      chips.add(new ChipFrame(scene, createShape(BOX, unit, 4*unit, unit), actualColor, unit, 4*unit, unit));
      chips.get(chips.size()-1).setPosition2(unit*0.5, unit*2, unit*0.5);
  }
  
  if (rectOver[8] && itsFree(2*unit, 2*unit, unit)) {
     chips.add(new ChipFrame(scene, createShape(BOX, 2*unit, 2*unit, unit), actualColor, 2*unit, 2*unit, unit));
    chips.get(chips.size()-1).setPosition2(unit, unit, unit*0.5); 
  }
  
  if (rectOver[9] && itsFree(2*unit, 4*unit, unit)){
     chips.add(new ChipFrame(scene, createShape(BOX, 2*unit, 4*unit, unit), actualColor, 2*unit, 4*unit, unit));
    chips.get(chips.size()-1).setPosition2(unit, unit*2, unit*0.5); 
  }
  
  if (colorOver[0]) {
     actualColor[0] = 255;
     actualColor[1] = 255;
     actualColor[2] = 255;
  }
  
  if (colorOver[1]) {
     actualColor[0] = 255;
     actualColor[1] = 0;
     actualColor[2] = 0;
  }
  
  if (colorOver[2]) {
     actualColor[0] = 255;
     actualColor[1] = 255;
     actualColor[2] = 0;
  }
  
  if (colorOver[3]) {
     actualColor[0] = 255;
     actualColor[1] = 174;
     actualColor[2] = 0;
  }
  
  if (colorOver[4]) {
     actualColor[0] = 0;
     actualColor[1] = 0;
     actualColor[2] = 255;
  }
  if (colorOver[5]) {
     actualColor[0] = 164;
     actualColor[1] = 164;
     actualColor[2] = 164;
  }
  if (colorOver[6]) {
     actualColor[0] = 192;
     actualColor[1] = 0;
     actualColor[2] = 255;
  }
  if (colorOver[7]) {
     actualColor[0] = 129;
     actualColor[1] = 1;
     actualColor[2] = 1;
  }
  if (colorOver[8]) {
     actualColor[0] = 3;
     actualColor[1] = 125;
     actualColor[2] = 0;
  }
  if (colorOver[9]) {
     actualColor[0] = 6;
     actualColor[1] = 255;
     actualColor[2] = 0;
  }
}

// This method paints the button which is selected.
void update(int x, int y) {
  if((x>=0 && x<=320) && (y>=0 && x<=600)){
      if((x>=0 && x<=160) && (y>=0 &&  y<=80)){
        traFalse();
        rectOver[0]=true;
      } else if((x>=0 && x<=160) && (y>=80 &&  y<=160)){
        traFalse();
        rectOver[1]=true;
      } else if((x>=0 && x<=160) && (y>=160 &&  y<=240)){
        traFalse();
        rectOver[2]=true;
      } else if((x>=0 && x<=160) && (y>=240 &&  y<=320)){
        traFalse();
        rectOver[3]=true;
      } else if((x>=0 && x<=160) && (y>=320 &&  y<=400)){
        traFalse();
        rectOver[4]=true;
      } else if((x>=160 && x<=320) && (y>=0 &&  y<=80)){
        traFalse();
        rectOver[5]=true;
      } else if((x>=160 && x<=320) && (y>=80 &&  y<=160)){
        traFalse();
        rectOver[6]=true;
      } else if((x>=160 && x<=320) && (y>=160 &&  y<=240)){
        traFalse();
        rectOver[7]=true;
      } else if((x>=160 && x<=320) && (y>=240 &&  y<=320)){
        traFalse();
        rectOver[8]=true;
      } else if((x>=160 && x<=320) && (y>=320 &&  y<=400)){
        traFalse();
        rectOver[9]=true;
      } else if((x>=0 && x<=64) && (y>=470 &&  y<=535)){
        traFalse();
        colorOver[0]=true;
      } else if((x>=64 && x<=128) && (y>=470 &&  y<=535)){
        traFalse();
        colorOver[1]=true;
      } else if((x>=128 && x<=192) && (y>=470 &&  y<=535)){
        traFalse();
        colorOver[2]=true;
      } else if((x>=192 && x<=256) && (y>=470 &&  y<=535)){
        traFalse();
        colorOver[3]=true;
      } else if((x>=256 && x<=320) && (y>=470 &&  y<=535)){
        traFalse();
        colorOver[4]=true;
      } else if((x>=0 && x<=64) && (y>=535 &&  y<=600)){
        traFalse();
        colorOver[5]=true;
      } else if((x>=64 && x<=128) && (y>=535 &&  y<=600)){
        traFalse();
        colorOver[6]=true;
      } else if((x>=128 && x<=192) && (y>=535 &&  y<=600)){
        traFalse();
        colorOver[7]=true;
      } else if((x>=192 && x<=256) && (y>=535 &&  y<=600)){
        traFalse();
        colorOver[8]=true;
      } else if((x>=256 && x<=320) && (y>=535 &&  y<=600)){
        traFalse();
        colorOver[9]=true;
      } else{
         traFalse();
      }
   } else{
      traFalse();
   }
}


// This method paint the left panel.
void drawPanel() {
   image(cube1,0,0);
  if (rectOver[0]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(0, 0, 160, 80);
  
  
  image(cube2,0,80);
  if (rectOver[1]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(0, 80, 160, 80);
  
  
  image(cube4,0,160);
  if (rectOver[2]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(0, 160, 160, 80);
  
  
  image(cube8,0,240);
  if (rectOver[3]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(0, 240, 160, 80);
  
  
  image(cube16,0,320);
    if (rectOver[4]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(0,320, 160, 80);

  image(cube1P,160,0);
    if (rectOver[5]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(160,0, 160, 80);
  
  image(cube4L,160,80);
    if (rectOver[6]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(160,80, 160, 80);
  
  
  image(cube4LP,160,160);
    if (rectOver[7]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(160,160, 160, 80);
  
  
  image(cube4P,160,240);
    if (rectOver[8]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(160,240, 160, 80);
  
  
  image(cube8P,160,320);
  if (rectOver[9]) {
    fill(0,100,255,120);
  } else {
    fill(0,0);
  }
  rect(160,320, 160, 80);
 
 
  image(colors[0],0,470);
  if (colorOver[0]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(0,470, 64, 64);
  
  image(colors[1],64,470);
   if (colorOver[1]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(64,470, 64, 64);
 
  
  image(colors[2],128,470);
 if (colorOver[2]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(128,470, 64, 64);
  
  image(colors[3],192,470);
 if (colorOver[3]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(192,470, 64, 64);
  
  image(colors[4],256,470);
 if (colorOver[4]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(256,470, 64, 64);
  
  image(colors[5],0,535);
 if (colorOver[5]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(0,535, 64, 64);
  
  image(colors[6],64,535);
 if (colorOver[6]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(64,535, 64, 64);
  
  image(colors[7],128,535);
  if (colorOver[7]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(128,535, 64, 64);
  
  image(colors[8],192,535);
  if (colorOver[8]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(192,535, 64, 64);
  
  image(colors[9],256,535);
  if (colorOver[9]) {
    fill(255,246,0,120);
  } else {
    fill(0,0);
  }
  noStroke();
  rect(256,535, 64, 64);
  
  image(icon,0,400);
  stroke(0);
}


void traFalse(){
   for(int i = 0; i<10; i++){
     rectOver[i] = false;
   }
   for(int i = 0; i<10; i++){
     colorOver[i] = false;
   }
}

void keyPressed(KeyEvent e) {
   if( e.getKeyCode()== LEFT) {
     for (ChipFrame chip : chips) {
      if (chip.grabsInput(scene.motionAgent())){
        int aux = chip.sizeX;
        chip.sizeX = chip.sizeY;
        chip.sizeY = aux;
        chip.rotate();
        if( !validateChips(false) ) {
          chip.rotate();
          aux = chip.sizeX;
          chip.sizeX = chip.sizeY;
          chip.sizeY = aux;
        } else {
          validateChips(true);          
        }
        break;
      }
     }
   } else if( e.getKeyCode()== RIGHT) {
     for (ChipFrame chip : chips) {
      if (scene.motionAgent().isInputGrabber(chip)){
        int aux = chip.sizeX;
        chip.sizeX = chip.sizeY;
        chip.sizeY = aux;
        chip.rotate();
        if( !validateChips(false) ) {
          chip.rotate();
          aux = chip.sizeX;
          chip.sizeX = chip.sizeY;
          chip.sizeY = aux;
        } else {
          validateChips(true);          
        }
        break;
      }
     }
   }
}


void mouseReleased() {
   validateChips(true);
}


/* This method validates the moves so that chips do not overlap each other and do not get out of
 * the 3D matrix. Besides, it places the chips on the floor or above of another chip. 
*/
boolean validateChips(boolean reset) {
 int temp[][][] = new int[dim][dim][dim];
   boolean valid = true;
   int index = 0; 
   int xc[] = new int[chips.size()], yc[] = new int[chips.size()], zc[] = new int[chips.size()] ;
  for(ChipFrame chip : chips ) {
    int x1, y1, z1, x2, y2, z2;    
    x1 = chip.getPositionX();
    y1 = chip.getPositionY();
    z1 = chip.getPositionZ();
    if(x1%10 >= 5){
      x1 = x1/unit*unit + unit;
    } else {
      x1 = x1/unit*unit;
    }
    if(y1%10 >= 5){
      y1 = y1/unit*unit +unit;
    } else {
      y1 = y1/unit*unit;
    }
    if(z1%10 >= 5){
      z1 = z1/unit*unit + unit;
    } else {
      z1 = z1/unit*unit;
    }
    x2 = x1 + chip.sizeX;
    y2 = y1 + chip.sizeY;
    if( x1<0 || y1<0 || z1<0 || x2>dim*unit || y2>=dim*unit ) {
      valid = false;
      break;
    }
    for( int k=z1/unit-1; k>=0; k-- ) {
       boolean down = true;
       for(int i=x1/10; i<x2/10 && down; i++) {
         for(int j=y1/10; j<y2/10 && down; j++) {
           if( temp[i][j][k]!=0 ) down = false;
         }  
       }
       if( down ) z1-=unit;
    }
    xc[index] = x1 + chip.sizeX/2;
    yc[index] = y1 + chip.sizeY/2;
    zc[index] = z1 + chip.sizeZ/2;
    z2 = z1 + chip.sizeZ; 
    if( x1<0 || y1<0 || z1<0 || x2>dim*unit || y2>=dim*unit || z2>=dim*unit ) {
      valid = false;
      break;
    }
    for(int i=x1/10; i<x2/10; i++) {
       for(int j=y1/10; j<y2/10; j++) {
          for(int k=z1/10; k<z2/10; k++) {
              if(temp[i][j][k]!=0) {
                 valid = false; 
              }
              temp[i][j][k] = index+1;
          }
       } 
    }
    index++;
    if(!valid) break;
  }  
  if(valid) {
     index = 0;
     for(ChipFrame chip : chips ) {
        chip.setPosition2(xc[index], yc[index], zc[index++]); 
     }
     return true;
  } 
  if(reset){
     index = 0;
     for(ChipFrame chip : chips ) {
        chip.setPosition2(chip.xc, chip.yc, chip.zc); 
     }
  } 
  return false;
}

void updatePickedModelColor() {
  for (ChipFrame chip : chips) {
    if (scene.motionAgent().isInputGrabber(chip))
      chip.shape().setFill(color(255, 229, 235));
    else{
      chip.shape().setFill(color(chip.colorP[0], chip.colorP[1], chip.colorP[2]));
    }    
    chip.shape().setStroke(color(0, 0, 0));
  }
}