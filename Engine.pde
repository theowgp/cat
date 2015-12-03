
class Engine {
  
  
  
  
  //parameters and constants such as repulsion/attraction range, force rtc.
  Params p;
  
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //size of a bird
  float s;
  //minimal allowed distance between birds
  float eps=4;
  
  //for throwing a boid
  int pbk=-1;//pressed boid k
  
    
  
  
  
  
  
  
  
  Engine(int n, float s, Params p){
    this.p = p;
    this.s=s;
    
    
    // creating birds
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(p.floater_vr, s));
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
    //if ( f.x + f.vx > f.s && f.x  + f.vx < w - f.s) f.x +=  f.vx;
    //if ( f.y + f.vy > f.s && f.y  + f.vy < h - f.s) f.y +=  f.vy;
    
    if(Allow(f)){
      f.x += f.vx;// * p.friction;
      f.y += f.vy;// * p.friction;
    }
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
    //flocking interraction
    //Flocking();
    //elasticity interaction
    Elasticity();    
  }
  
  void Flocking(){
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
  
  void Elasticity(){
    for (int i = 1; i < floaters.size(); i++) {
      InteractElasticly(floaters.get(i-1), floaters.get(i));
      InteractElasticly(floaters.get(floaters.size()-i), floaters.get(floaters.size()-i-1));
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
     float dvx = ((fi.x-fj.x)/df) * RelativeForce(df, p.floater_cr, p.floater_crf, p.floater_cal, p.floater_ca, p.floater_caf); 
     float dvy = ((fi.y-fj.y)/df) * RelativeForce(df, p.floater_cr, p.floater_crf, p.floater_cal, p.floater_ca, p.floater_caf);
     
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
     float dvx = ((x-fj.x)/df) * RelativeForce(df, p.floater_cr, p.floater_crf, p.floater_cal, p.floater_ca, p.floater_caf); 
     float dvy = ((y-fj.y)/df) * RelativeForce(df, p.floater_cr, p.floater_crf, p.floater_cal, p.floater_ca, p.floater_caf);
     
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
  float RelativeForce(float d, float fcr, float frf, float fcal, float fca, float faf){// d in [0, floater_cr] DForce in [p.floater_crf, 0]; d in  (floater_cr, floater_ca] DForce in (0, p.floater_caf];  
    if(d<=fcr){
      return -frf *(-d/fcr + 1); //thr smaller the distance d the stronger the repulsion
    }
    else
    if( d <= fcal){
      return 0;
    }
    else
    if(d <= fca){
      return (float)(   faf * ( (d-fcal)/(fca - fcal) )    );//the bigger the distance d the stronger the repulsion
    }
    return 0;
  }
 
  
  //interaction with each other
  void InteractElasticly(Floater fj, Floater fi){
     //velocity change
     float df = dist(fi.x, fi.y, fj.x, fj.y);
     float dvx = ((fi.x-fj.x)/df) * RelativeForce(df, p.elstc_dr-p.elstc_eps, p.elstc_f, p.elstc_dr+p.elstc_eps, p.elstc_db, p.elstc_f); 
     float dvy = ((fi.y-fj.y)/df) * RelativeForce(df, p.elstc_dr-p.elstc_eps, p.elstc_f, p.elstc_dr+p.elstc_eps, p.elstc_db, p.elstc_f);
     
     //new velocity
     float newvx = fj.vx + dvx;
     float newvy = fj.vy + dvy;
     
     //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
     float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
     if(dnewv > p.elstc_vr)
     {
      newvx /= dnewv/p.elstc_vr;
       
      newvy /= dnewv/p.elstc_vr;
     }
     
     fj.vx=newvx;
     fj.vy=newvy;
  }
  
  
  
  
  
  
  void mouseClicked()  {
    if(mouseButton == RIGHT){
      floaters.add(new Floater(p.floater_vr, s, mouseX-s/2, mouseY-s/2));
    }
  }
  
 
 void mouseDragged()  {
    if(pbk>=0){
         floaters.get(pbk).x=mouseX-floaters.get(pbk).s/2;
         floaters.get(pbk).y=mouseY-floaters.get(pbk).s/2;
         floaters.get(pbk).vx = 0;
         floaters.get(pbk).vy = 0;
    }
    else{
      for (int i = 0; i < floaters.size(); i++) {
        Interract(floaters.get(i), mouseX, mouseY);
      }
    }
  }
 
  
  
  void mousePressed()  {
    if(mouseButton == LEFT){
      //find out which boid is pressed, if it is pressed
      for (int i = 0; i < floaters.size(); i++) {
          if(pmouseX > floaters.get(i).x && pmouseX < floaters.get(i).x+floaters.get(i).s && pmouseY > floaters.get(i).y && pmouseY < floaters.get(i).y + floaters.get(i).s){
            pbk=i;
          }
      }
      if(pbk>=0){
        floaters.get(pbk).x=mouseX-floaters.get(pbk).s/2;
        floaters.get(pbk).y=mouseY-floaters.get(pbk).s/2;
        floaters.get(pbk).vx = 0;
        floaters.get(pbk).vy = 0;
      }
      // if no boid has been pressed then (flocking)Interract
      else{
        for (int i = 0; i < floaters.size(); i++) {
          Interract(floaters.get(i), mouseX, mouseY);
        }
      }
    }
  }
 
 
  void mouseReleased()  {
    if(mouseButton == LEFT){
      if(pbk>=0){
         //floaters.get(pbk).x = mouseX - floaters.get(pbk).s/2;
         //floaters.get(pbk).y = mouseY - floaters.get(pbk).s/2;
         
         //determine the velocity at which to throw the ball
         //new velocity
         float newvx = (mouseX-pmouseX);
         float newvy = (mouseY-pmouseY);
         
         //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
         float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
         if(dnewv > p.elstc_vr)
         {
          newvx /= dnewv/p.elstc_vr;
           
          newvy /= dnewv/p.elstc_vr;
         }
         
         floaters.get(pbk).vx = newvx;
         floaters.get(pbk).vy = newvy;
      }
    }
    pbk=-1;
  }

 
 
 
}   
   

   
   
   
   
  
  
  
  
  
  