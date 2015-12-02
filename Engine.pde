
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
      floaters.add(new Floater(p.floater_vr, s, w, h));
    }
    
    this.w=w;
    this.h=h;
    this.s=s;
  }
  
  
  
  void Move(Floater f) {
    //close borders   
    //if ( floaters.get(j).x + f.vx > f.s && f.x  + f.vx < w - f.s) f.x +=  f.vx;
    //if ( f.y + f.vy > f.s && f.y  + f.vy < h - f.s) f.y +=  f.vy;
    
    if(Allow(f)){
      f.x += f.vx * p.friction;
      f.y += f.vy * p.friction;
    }
    
    //to make a looping border of the frame
    if(f.x<=0) f.x = w-1;
    if(f.x>=w) f.x = 0;
    if(f.y<=0) f.y = h-1;
    if(f.y>=h) f.y = 0;
  }
  
  //does not allow floaters to move to close
  boolean Allow(Floater f){
   for (int i = 0; i < floaters.size(); i++) {
     if((f != floaters.get(i))&&(dist(f.x+f.vx, f.y+f.vy, floaters.get(i).x, floaters.get(i).y) < eps)){
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
      }
    }
  }
  
 
  void mouseClicked()  {
    if(mouseButton == LEFT){
      for (int i = 0; i < floaters.size(); i++) {
          Interract(floaters.get(i), mouseX, mouseY);
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
      Move(floaters.get(i));
      Drawbird(floaters.get(i));
      //Drawboid(floaters.get(i));
    }
  }
  
  
  float a0=100;
  float a1;
  void Drawbird(Floater f) {
      //draw a flapping bird
      //rotate
      pushMatrix();
      translate(f.x + f.s/2, f.y + f.s/2);
      rotate(DirectionAngle(f));
      //DirectionAngle(f);
      //a1 = DirectionAngle(f);
      //if (a1 != a0){
      //  println("angle=", a1);
      //  a0=a1;
      //}
      image(frms[f.frameCounteri], -f.s/2, -f.s/2, f.s, f.s);
      popMatrix();
      f.frameCounter++;
      if (f.frameCounter > flappingRate) {
       f.frameCounter=0;
       f.frameCounteri++;
      }
    
      if (f.frameCounteri >= 3) f.frameCounteri = 0;
   }
   
   void Drawboid(Floater f) {
      //draw a boid with velocity vector
      //rotate
      pushMatrix();
      translate(f.x + f.s/2, f.y + f.s/2);
      
      line(0, 0, f.vx*10, f.vy*10);
      ellipseMode(CENTER); 
      fill(0);
      ellipse(f.vx*10, f.vy*10, 5, 5);
      
      fill(255);
      ellipseMode(CENTER); 
      ellipse(0, 0, 10, 10);
      //line(-f.head.x*20, -f.head.y*20, f.head.x*20, f.head.y*20);
      //ellipseMode(CENTER); 
      //ellipse(f.head.x*20, f.head.y*20, 10, 10);
      //ellipseMode(CENTER); 
      //ellipse(-f.head.x*20, -f.head.y*20, 10, 10);
      
      popMatrix();
   }
   
   
   float DirectionAngle(Floater f){
     //find out the cos between the head vector of a bird and its velocity vector
     float cos = (float)((f.head.x*f.vx + f.vy*f.head.y) / (Math.sqrt((f.vx*f.vx + f.vy*f.vy)) * Math.sqrt((f.head.x*f.head.x + f.head.y*f.head.y))));
     
     //a1 = cos;
     //if (a1 != a0){
     //  println("cos=", a1);
     //  a0=a1;
     //}
     
     //check if the end point of the velocity vector is to the left or to the right from the head vector of the bird
     //float x = f.x + f.vx;
     //float y = f.y + f.vy;
     //float vpoint = y - x*f.head.y/f.head.x + f.x*f.head.y/f.head.x - f.y;
     
     //(simplified check) the location of the bird doesn't matter for the relative position of its head and velocity vectors
     float x = f.vx;
     float y = f.vy;
     float vpoint = y - x*f.head.y/f.head.x;
     
     if(vpoint >= 0) return -acos(cos);
     else return acos(cos);
   }
   
   
   
   
  
  
  
  
  
} 
  