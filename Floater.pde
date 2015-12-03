
class Floater {
  float x; 
  float y; // location
  float vx; 
  float vy; // velocities
  float s; // size
  //direction in which points a bitd's head on the picture
  PVector head= new PVector(-1, -1);
  
  //for flapping 
  int frameCounteri;
  int frameCounter;
  //int flappingRate  = 10;
  
  Floater(float floater_vr, float s) {
    //initialize random positions and random velocities
    x = (int)random(100, width-100);
    y = (int)random(100, height-100);
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
    //size of a bird
    //s = (floater_ca + floater_ca)/2;
    frameCounteri = (int)random(3.999);
    frameCounter = 0;//(int)random(flappingRate +0.999);

  }
  
  Floater(float floater_vr, float s, float x, float y) {
    //initialize random positions and random velocities
    this.x = x;
    this.y = y;
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
    //size of a bird
    //s = (floater_ca + floater_ca)/2;

  }
  
  
}  
  
  
  
  