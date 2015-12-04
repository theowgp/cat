
class Flocking extends Force {
  
  Flocking(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
  }
  
  
  
  
  
  void Apply(){
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
   

   
   
   
   
  
  
  
  
  
  