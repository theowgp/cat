class Force {
  
  
  //array of floaters
  ArrayList<Floater> floaters;
  void SetFloaters(ArrayList<Floater> floaters){
    this.floaters=floaters;
  }
  
  //interaction matrix
  int[][] matrix;
  void SetMatrix(int[][] matrix){
    this.matrix=matrix;
  }

  
  
  
  //independent movement's laws
  float r_repulsion;//repulsion range
  float f_repulsion;//repulsion force
  float r_still;//still range
  float r_attraction;//attraction range
  float f_attraction;//attraction force
  //public float bird_sigh1=250 ;
  
  // constraining the range(and velocitfloaters[j].y range) at which birds can move at a time
  float floater_vr=10;
  
  
  
  
  
  Force(float rr, float fr, float rs, float ra, float fa, float fvr){
    //independent movement's laws
    r_repulsion=rr;
    f_repulsion=fr;
    r_still=rs;
    r_attraction= ra;
    f_attraction=fa;
    
    
    
    floater_vr=fvr;
 }
 
 Force(Force f){
    //independent movement's laws
    r_repulsion=f.r_repulsion;
    f_repulsion=f.f_repulsion;
    r_still=f.r_still;
    r_attraction= f.r_attraction;
    f_attraction=f.f_attraction;
    
    
    
    floater_vr=f.floater_vr;
 }
 
 
 
//void CreateMatrix(){
//    matrix = new int[floaters.size()][floaters.size()];
    
//    for (int i = 0; i < floaters.size(); i++) {
//      for (int j = 0; j < floaters.size(); j++) {
//        if(Math.abs(i-j) == 1) matrix[i][j] = 1;
//        else matrix[i][j] = 0;
//      }
//    }
//  }
 
// void CreateMatrixZeros(){
//    matrix = new int[floaters.size()][floaters.size()];
    
//    for (int i = 0; i < floaters.size(); i++) {
//      for (int j = 0; j < floaters.size(); j++) {
//        matrix[i][j] = 0;
//      }
//    }
//  }
   
  
  
  
  void Apply(){
    for (int i = 0; i < floaters.size(); i++) {
      //determine relative velocities
      for (int j = 0; j < floaters.size(); j++) {
        if (matrix[i][j] > 0){
          for(int k=0; k < matrix[i][j]; k++){
            Interract(floaters.get(i), floaters.get(j));
          }
        }
      }
    }
  }
  



  
  //interaction with each other
  void Interract(Floater fj, Floater fi){
     //velocity change
     float df = dist(fi.x, fi.y, fj.x, fj.y);
     float dvx = ((fi.x-fj.x)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction); 
     float dvy = ((fi.y-fj.y)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction);
     
     AddVelocity(fj, dvx, dvy);
  }
  
  //outer influence (with a mouse currently 02.12.15)
  void Interract(Floater fj, float x, float y){
     //velocity change
     float df = dist(x, y, fj.x, fj.y);
     float dvx = ((x-fj.x)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction); 
     float dvy = ((y-fj.y)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction);

     AddVelocity(fj, dvx, dvy);
  }
  
  //if the velocity is too large normilize it
  void AddVelocity(Floater f, float vx, float vy){
    //new velocity
     float newvx = f.vx + vx;
     float newvy = f.vy + vy;
     
     //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
     float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
     if(dnewv > floater_vr)
     {
       newvx /= dnewv/floater_vr;
       
       newvy /= dnewv/floater_vr;
     }
     
     if(!f.still){
       f.vx=newvx;
       f.vy=newvy;
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
   