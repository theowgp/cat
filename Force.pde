
class Force {
  
  
  //array of floaters
  ArrayList<Floater> floaters;
  void SetFloaters(ArrayList<Floater> floaters){
    this.floaters=floaters;
  }
  
  
  
  
  //independent movement's laws
  float r_repulsion;//repulsion range
  float f_repulsion;//repulsion force
  float r_still;//allignment range
  float r_attraction;//attraction range
  float f_attraction;//attraction force
  //public float bird_sigh1=250 ;
  
  // constraining the range(and velocitfloaters[j].y range) at which birds can move at a time
  float floater_vr;
  
  //minimal allowed distance between birds
  protected float eps;
  
  protected float friction;
  
  
  
  
  
  Force(float rr, float fr, float rs, float ra, float fa, float fvr, float e, float frct){
    //independent movement's laws
    r_repulsion = rr;
    f_repulsion = fr;
    r_still = rs;
    r_attraction = ra;
    f_attraction = fa;
    
    eps=e;
    
    friction = frct;
    
    floater_vr = fvr;
 }
  
  
  
  
  
  
  
  protected void Move() {
    for (int i = 0; i < floaters.size(); i++) {
      if(Allow(floaters.get(i))){
        floaters.get(i).x += floaters.get(i).vx * friction;
        floaters.get(i).y += floaters.get(i).vy * friction;
      }
    }
  }
  
  //does not allow floaters to move to close
  protected boolean Allow(Floater f){
   for (int i = 0; i < floaters.size(); i++) {
     if((f != floaters.get(i))&&(dist(f.x+f.vx, f.y+f.vy, floaters.get(i).x, floaters.get(i).y) < eps)){
       return false;                
     }
   }
   return true;
  }
  
  
  
  
  
  
  
  
  //virtuall   
  void Act(){}
  

  

  
  //interaction with each other
  void Interract(Floater fj, Floater fi){
     //velocity change
     float df = dist(fi.x, fi.y, fj.x, fj.y);
     float dvx = ((fi.x-fj.x)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction); 
     float dvy = ((fi.y-fj.y)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction);
     
     //new velocity
     float newvx = fj.vx + dvx;
     float newvy = fj.vy + dvy;
     
     //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
     float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
     if(dnewv > floater_vr)
     {
       newvx /= dnewv/floater_vr;
       
       newvy /= dnewv/floater_vr;
     }
     
     if(!fj.still){
       fj.vx=newvx;
       fj.vy=newvy;
     }
  }
  
  //outer influence (with a mouse currently 02.12.15)
  void Interract(Floater fj, float x, float y){
     //velocity change
     float df = dist(x, y, fj.x, fj.y);
     float dvx = ((x-fj.x)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction); 
     float dvy = ((y-fj.y)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction);
     
     //new velocity
     float newvx = fj.vx + dvx;
     float newvy = fj.vy + dvy;
     
     //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
     float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
     if(dnewv > floater_vr)
     {
       newvx /= dnewv/floater_vr;
       
       newvy /= dnewv/floater_vr;
     }
     
     if(!fj.still){
       fj.vx=newvx;
       fj.vy=newvy;
     }
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
 
  
  
  
  
  
  
  
  

 
 
 
}   
   

   
   
   
   
  
  
  
  
  
  