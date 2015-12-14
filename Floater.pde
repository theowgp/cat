
class Floater {
  
  // location
  float x; 
  float y;
  
  //velocities
  float vx; 
  float vy;
  
  // size
  float s;
  
  //hash number to identify floaters
  int number;
  
  //remember last neighbors
  Floater left;
  Floater right;
  //allow interraction between left and right
  boolean ilr = true;
    
  //direction in which points a bitd's head on the picture
  PVector head= new PVector(-1, -1);
  //do not allow add velocity if true
  boolean still=false; 
  
  //for flapping 
  int frameCounteri;
  int frameCounter;
  
  //is a bird
  boolean isabird;
  
  
  Floater(float floater_vr, float s, boolean isab) {
    //initialize random positions and random velocities
    if(isabird){
      x = (int)random(100, width/2-100);
      y = (int)random(100, height/2-100);
    }
    else{
      x = (int)random( width/2-100, width-100);
      y = (int)random( height/2-100, height-100);
    }
    //x = (int)random(100, width-100);
    //y = (int)random(100, height-100)
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    //vx = 0;//random(-floater_vr, floater_vr);
    //vy = 0;//random(-floater_vr, floater_vr);
    this.s = s;
    this.isabird = isab;
    
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
  
  //for bullets
  Floater(float floater_vr, float x, float y, float vx, float vy) {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
  
  Floater(Floater f) {
    x = f.x;
    y = f.y;
    vx = f.vx;
    vy = f.vy;
    s  = f.s;
    
    frameCounteri = (int)random(3.999);
    frameCounter = 0;
  }
  
  
}  
  
  
  
  