
class Floater {
  
  // location
  float x; 
  float y;
  
  //velocities
  float vx; 
  float vy;
  
  // size
  float s;
  
  //colour 
  int colour;
  
  //direction in which points a bitd's head on the picture
  PVector head= new PVector(-1, -1);
  //do not allow add velocity if true
  boolean still=false; 
  
  //for flapping 
  int frameCounteri;
  int frameCounter;
  
  
  
  
   
   
   
  int frame_counter_limit = 5;
  int frame_counter = 0;
  void ResetFrameCounter(){
    frame_counter = 0;
  }
  void IncrementFrameCounter(){
    if (frame_counter <= frame_counter_limit + 1)   frame_counter++;
  }
  boolean ChangeStateAllowed(){
    if (frame_counter >= frame_counter_limit) return true;
    return false;
  }
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  Floater(float floater_vr, float s) {
    //initialize random positions and random velocities
    x = (int)random(100, width-100);
    y = (int)random(100, height-100);
    colour = (int)random(0, 240);
    //vx = random(-floater_vr, floater_vr);
    //vy =  random(-floater_vr, floater_vr);
    vx = 0;
    vy = 0;
    this.s = s;
    
    frameCounteri = (int)random(3.999);
    frameCounter = 0;
  }
  
  //create in a certain position
  Floater(float floater_vr, float s, float x, float y) {
    this.x = x;
    this.y = y;
    colour = (int)random(0, 240);
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
  }
  
  //copy
  Floater(Floater f) {
    //initialize random positions and random velocities
    this.x = f.x;
    this.y = f.y;
    this.vx = f.vx;
    this.vy = f.vy;
    this.s = f.s;
    this.colour = f.colour;
    
    frameCounteri = (int)random(3.999);
    frameCounter = 0;
  }
  
  
  
  
  
  
  
  
  
}  
  
  
  
  