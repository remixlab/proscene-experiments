/**
 * ChipFrame. 
 * by Juan Carlos Cabrera and Diego Alexander Huerfano.
 * 
 * This class is part of the Lego example.
 * 
 * ChipFrame represents a chip in the model which allows us to do rotations and moves.
 * It has been overrided the methods rotate and spin from the InteractiveModelFrame class
 * in order to control every user's interactive move.
 *  
 * It is used the class Rot so that rotations are done with 90 degrees.
 */


class ChipFrame extends InteractiveFrame {
    int [] colorP;
    int sizeX, sizeY, sizeZ;
    float xc, yc, zc;
    Rot rot = new Rot();
    
    public ChipFrame(Scene s, PShape p, int[] colorP, int sizeX, int sizeY, int sizeZ) {
        super(s, p);
        this.colorP = new int[3];
        this.colorP[0] = colorP[0];
        this.colorP[1] = colorP[1];
        this.colorP[2] = colorP[2];
        this.sizeX = sizeX;
        this.sizeY = sizeY;
        this.sizeZ = sizeZ;
        this.setWheelSensitivity(0);
        rot.fromRotatedBasis(new Vec(0,1,0), new Vec(-1,0,0), new Vec(0,0,0));
    }
    
    public void setPosition2(float x, float y, float z) {
      setPosition(x,y,z);
      xc = x;
      yc = y;
      zc = z;
    }
    
    public void rotate() {
      this.rotate(rot);
    }
    
    public void spin() {}
    
    public int getPositionX(){
       return (int)(this.position().x() - sizeX*0.5); 
    }
    public int getPositionY(){
       return (int)(this.position().y() - sizeY*0.5); 
    }
    public int getPositionZ(){
       return (int)(this.position().z() - sizeZ*0.5); 
    }
}