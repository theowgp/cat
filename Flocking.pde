
class Flocking extends Force {
  
  
  ////array of floaters
  //ArrayList<Floater> floaters;
  
  
  
  
  ////independent movement's laws
  //float r_repulsion=30;//repulsion range
  //float f_repulsion=4;//repulsion force
  //float r_still=50;//allignment range
  //float r_attraction= 250;//attraction range
  //float f_attraction=2;//attraction force
  ////public float bird_sigh1=250 ;
  
  //// constraining the range(and velocitfloaters[j].y range) at which birds can move at a time
  //float floater_vr=10;
  
  
  
  
  
  Flocking(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
   
     
  }
  
  
  void Act(){
    for (int j = 0; j < floaters.size(); j++) {
      //determine relative velocities
      for (int i = 0; i < floaters.size(); i++) {
        if (i!=j){//doesn't consider itself
          float d = dist(floaters.get(i).x, floaters.get(i).y, floaters.get(j).x, floaters.get(j).y);
          //allignment
          if(r_repulsion <=d && d <= r_still){
            floaters.get(j).vx = (floaters.get(j).vx + floaters.get(i).vx)/2;    
            floaters.get(j).vy = (floaters.get(j).vy + floaters.get(i).vy)/2;
          }
          //repulsion or attraction
          else{
            Interract(floaters.get(j), floaters.get(i));
          }
        }
      }
    }
  }
 


  

  

 
 
 
}   
   

   
   
   
   
  
  
  
  
  
  