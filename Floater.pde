
class Floater {
  
  // location
  float x; 
  float y;
  
  //velocities
  float vx; 
  float vy;
  
  // size
  float s;
  
  //direction in which points a bitd's head on the picture
  PVector head= new PVector(-1, -1);
  //do not allow add velocity if true
  boolean still=false; 
  
  //for flapping 
  int frameCounteri;
  int frameCounter;
  
  
  Floater(float floater_vr, float s) {
    //initialize random positions and random velocities
    x = (int)random(100, width-100);
    y = (int)random(100, height-100);
    //vx = random(-floater_vr, floater_vr);
    //vy =  random(-floater_vr, floater_vr);
    vx = 0;
    vy = 0;
    this.s = s;
    
    frameCounteri = (int)random(3.999);
    frameCounter = 0;
  }
  
  Floater(float floater_vr, float s, float x, float y) {
    this.x = x;
    this.y = y;
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
  }
  
  Floater(Floater f) {
    //initialize random positions and random velocities
    this.x = f.x;
    this.y = f.y;
    this.vx = f.vx;
    this.vy = f.vy;
    this.s = f.s;
    
    frameCounteri = (int)random(3.999);
    frameCounter = 0;
  }
  
}  
  
  
  
  