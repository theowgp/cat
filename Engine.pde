
class Engine {
  
  //width and height of the screen
  float w;
  float h;
  
  //parameters and constants such as repulsion/attraction range, force rtc.
  Params p;
  
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //size
  float s;
  //minimal allowed distance between birds
  float eps=4;
  
  
  //bird frames
  PImage[] frms;
  //for bird flapping images
  //int frameCounteri=0;
  //int frameCounter=0;
    int flappingRate;
  
  
  
  
  
  
  
  
  
  Engine(int n, float s, int flappingRate, Params p, float w, float h, PImage[] frms){
    this.frms = frms;
    this.p = p;
    this.flappingRate = flappingRate;
    
    // creating birds
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(p.floater_vr, s, w, h, flappingRate));
    }
    
    this.w=w;
    this.h=h;
    this.s=s;
  }
  
  
  
  void Move(int j) {
    //float ddx=0;
    //float ddy=0;
    //close borders   
    //if ( floaters.get(j).x + ddx + floaters.get(j).vx > floaters.get(j).s && floaters.get(j).x + ddx + floaters.get(j).vx < w - floaters.get(j).s) floaters.get(j).x +=  floaters.get(j).vx + ddx;
    //if ( floaters.get(j).y + ddy + floaters.get(j).vy > floaters.get(j).s && floaters.get(j).y + ddy + floaters.get(j).vy < h - floaters.get(j).s) floaters.get(j).y +=  floaters.get(j).vy + ddy;
    
    if(Allow(floaters.get(j), j)){
      floaters.get(j).x += floaters.get(j).vx * p.friction;
      floaters.get(j).y += floaters.get(j).vy * p.friction;
    }
    
  
    
    
    //to make a looping border of the frame
    if(floaters.get(j).x<=0) floaters.get(j).x = w-1;
    if(floaters.get(j).x>=w) floaters.get(j).x = 0;
    if(floaters.get(j).y<=0) floaters.get(j).y = h-1;
    if(floaters.get(j).y>=h) floaters.get(j).y = 0;
  }
  //does not allow floaters to move to close
  boolean Allow(Floater f, int j){
   for (int i = 0; i < floaters.size(); i++) {
     if((i!=j)&&(dist(f.x+f.vx, f.y+f.vy, floaters.get(i).x, floaters.get(i).y) < eps)){
       return false;                
     }
   }
   return true;
  }
  
  
  
  
  void DetermineVelocity(){
    for (int j = 0; j < floaters.size(); j++) {
      //determine relative velocities
      for (int i = 0; i < floaters.size(); i++) {
        if (i!=j){//doesn't consider itself
          float d = dist(floaters.get(i).x, floaters.get(i).y, floaters.get(j).x, floaters.get(j).y);
          //repulsion
          if(d <= p.floater_cr){
            Interract(floaters.get(j), floaters.get(i), false);
          }
          else
          //allignement
          if (d<= p.floater_cal){
            Interract(floaters.get(j), floaters.get(i), true);      
          }
          else
          //attraction
          if(d <= p.floater_ca){
            Interract(floaters.get(j), floaters.get(i), false);
          }
        }
      }
      
      //for the allignement
      //println("vx= ",floaters.get(j).vx);//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      //println("vy= ",floaters.get(j).vy);//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    }
  }
  

  
  //interaction with each other
  void Interract(Floater fj, Floater fi, boolean allignment){
     if(allignment){
       fj.vx = (fj.vx + fi.vx)/2;    
       fj.vy = (fj.vy + fi.vy)/2;
       return;
     }
     
     //velocity change
     float df = dist(fi.x, fi.y, fj.x, fj.y);
     float dvx = ((fi.x-fj.x)/df) * RelativeForce(df); 
     float dvy = ((fi.y-fj.y)/df) * RelativeForce(df);
     
     //new velocity
     float newvx = fj.vx + dvx;
     float newvy = fj.vy + dvy;
     
     //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
     float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
     if(dnewv > p.floater_vr)
     {
       newvx /= dnewv/p.floater_vr;
       
       newvy /= dnewv/p.floater_vr;
     }
     
     fj.vx=newvx;
     fj.vy=newvy;
  }
  
  //outer influence (with a mouse currently 02.12.15)
  void Interract(Floater fj, float x, float y){
     //velocity change
     float df = dist(x, y, fj.x, fj.y);
     float dvx = ((x-fj.x)/df) * RelativeForce(df); 
     float dvy = ((y-fj.y)/df) * RelativeForce(df);
     
     //new velocity
     float newvx = fj.vx + dvx;
     float newvy = fj.vy + dvy;
     
     //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
     float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
     if(dnewv > p.floater_vr)
     {
       newvx /= dnewv/p.floater_vr;
       
       newvy /= dnewv/p.floater_vr;
     }
     
     fj.vx=newvx;
     fj.vy=newvy;
  }
   
  //Force depending on the relative distance d between birds and force parameters such as repulsion force p.floater_crf and attraction force p.floater_caf
  float RelativeForce(float d){// d in [0, floater_cr] DForce in [p.floater_crf, 0]; d in  (floater_cr, floater_ca] DForce in (0, p.floater_caf];  
    if(d<=p.floater_cr){
      return -p.floater_crf *(-d/p.floater_cr + 1); //thr smaller the distance d the stronger the repulsion
    }
    else
    if(p.floater_cr < d && d <= p.floater_ca){
      return (float)(   p.floater_crf * ( (d-p.floater_cr)/(p.floater_ca - p.floater_cr) )    );//thr bigger the distance d the stronger the repulsion
    }
    return 0;
  }
 
  
  
  
  
  
  
  void mouseDragged()  {
    if(mouseButton == LEFT){
      for (int i = 0; i < floaters.size(); i++) {
          Interract(floaters.get(i), mouseX, mouseY);
          //floaters.get(i).vx += /*floater_vr*/(mouseX-floaters.get(i).x)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y);
          //floaters.get(i).vy += /*floater_vr*/(mouseY-floaters.get(i).y)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y);
      }
    }
  }
  
 
  void mouseClicked()  {
    if(mouseButton == LEFT){
      for (int i = 0; i < floaters.size(); i++) {
          Interract(floaters.get(i), mouseX, mouseY);
          //floaters.get(i).vx += /*floater_vr*/(mouseX-floaters.get(i).x)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y);
          //floaters.get(i).vy += /*floater_vr*/(mouseY-floaters.get(i).y)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y);
       }
    }
    else{
      floaters.add(new Floater(p.floater_vr, s, w, h, mouseX-s/2, mouseY-s/2));
    }
  }
  
 
  
  void draw() {
    //determine velocity of each bird
    DetermineVelocity();
       
    //move each bird and draw it  
    for (int i = 0; i < floaters.size(); i++) {
      Move(i);
      Drawbird(i);
    }
  }
  
  void Drawbird(int i) {
      //draw a flapping bird
      //rotate
      pushMatrix();
      translate(floaters.get(i).x + floaters.get(i).s/2, floaters.get(i).y + floaters.get(i).s/2);
      //rotate(DirectionAngle(floaters.get(i)));
      //println("angle=",DirectionAngle(floaters.get(i)));
      //println("vx=);
      rotate(2*PI);
      image(frms[floaters.get(i).frameCounteri], -floaters.get(i).s/2, -floaters.get(i).s/2, floaters.get(i).s, floaters.get(i).s);
      popMatrix();
      floaters.get(i).frameCounter++;
      if (floaters.get(i).frameCounter > flappingRate) {
       floaters.get(i).frameCounter=0;
       floaters.get(i).frameCounteri++;
      }
    
      if (floaters.get(i).frameCounteri >= 3) floaters.get(i).frameCounteri = 0;
   }
   
   float DirectionAngle(Floater f){
     //find out the cos between the head vector of a bird and its velocity vector
     float cos = (f.head.x*f.vx + f.vy*f.head.y) / ((f.vx*f.vx + f.vy*f.vy) * (f.head.x*f.head.x + f.head.y*f.head.y));
     
     //check if the end point of the velocity vector is to the left or to the right from the head vector of the bird
     //float x = f.x + f.vx;
     //float y = f.y + f.vy;
     //float vpoint = y - x*f.head.y/f.head.x + f.x*f.head.y/f.head.x - f.y;
     
     //(simplified check) the location of the bird doesn't matter for the relative position of its head and velocity vectors
     float x = f.vx;
     float y = f.vy;
     float vpoint = y - x*f.head.y/f.head.x;
     
     if(vpoint >= 0) return acos(cos);
     else return -acos(cos);
   }
   
   
   
   
  
  
  
  
  
} 
  