
class Floater {
  float x; 
  float y; // location
  float vx; 
  float vy; // velocities
  float s; // size
  
  //for flapping 
  int frameCounteri;
  int frameCounter;
  //int flappingRate  = 10;
  
  Floater(float floater_vr, float s, float w, float h, int flappingRate) {
    //initialize random positions and random velocities
    x = (int)random(100, w-100);
    y = (int)random(100, h-100);
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
    //size of a bird
    //s = (floater_ca + floater_ca)/2;
    frameCounteri = (int)random(3.9999);
    frameCounter = (int)random(flappingRate +0.999);

  }
  
  Floater(float floater_vr, float s, float w, float h, float x, float y) {
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
  
  
  
  