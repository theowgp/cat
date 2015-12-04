class Elasticity extends Force {
  
  
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
  
  
  
  
  
  Elasticity(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
    
         
  }
  
  
  void Act(){
    for (int i = 1; i < floaters.size(); i++) {
      Interract(floaters.get(i-1), floaters.get(i));
      Interract(floaters.get(floaters.size()-i), floaters.get(floaters.size()-i-1));
    }
  }
 


  

  

 
 
 
}   
   