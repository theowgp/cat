
class Floater {
  float x; 
  float y; // location
  float vx; 
  float vy; // velocities
  float s; // size
  
  Floater(float floater_vr, float s, float w, float h) {
    //initialize random positions and random velocities
    x = (int)random(100, w-100);
    y = (int)random(100, h-100);
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
    //size of a bird
    //s = (floater_ca + floater_ca)/2;

  }
  
  
}  
  
  
  
  