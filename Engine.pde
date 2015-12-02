
class Engine {
  
  //parameters and constants such as repulsion/attraction range, force rtc.
  Params p;
  
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //size of a bird
  float s;
  //minimal allowed distance between birds
  float eps=4;
  
  
    
  
  
  
  
  
  
  
  
  Engine(int n, float s, Params p){
    this.p = p;
    this.s=s;
    
    
    // creating birds
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(p.floater_vr, s, width, height));
    }
 }
  
  
  void IterateFrame(){
    DetermineVelocities();
    for (int i = 0; i < floaters.size(); i++) {
      Move(floaters.get(i));
    }
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
    if(f.x<=0) f.x = width-1;
    if(f.x>=width) f.x = 0;
    if(f.y<=0) f.y = height-1;
    if(f.y>=height) f.y = 0;
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
  
  
  
  
  void DetermineVelocities(){
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
      floaters.add(new Floater(p.floater_vr, s, width, height, mouseX-s/2, mouseY-s/2));
    }
  }
  
 
 
  
 
   
   

   
   
   
   
  
  
  
  
  
} 
  