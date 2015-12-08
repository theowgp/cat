
class Flocking extends Force {
  
  Flocking(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
  }
  
  void CreateMatrix(){
    matrix = new int[floaters.size()][floaters.size()];
    
    for (int i = 0; i < floaters.size(); i++) {
      for (int j = 0; j < floaters.size(); j++) {
        if(i!=j) matrix[i][j] = 1;
        else matrix[i][j] = 0;
      }
    }
  }
  
  
  
  
  void Apply(){
    for (int i = 0; i < floaters.size(); i++) {
      //determine relative velocities
      for (int j = 0; j < floaters.size(); j++) {
        if (matrix[i][j] == 1){
          float d = dist(floaters.get(j).x, floaters.get(j).y, floaters.get(i).x, floaters.get(i).y);
          //allignment
          if(r_repulsion <=d && d <= r_still){
            floaters.get(i).vx = (floaters.get(i).vx + floaters.get(j).vx)/2;    
            floaters.get(i).vy = (floaters.get(i).vy + floaters.get(j).vy)/2;
          }
          //repulsion or attraction
          else{
            Interract(floaters.get(i), floaters.get(j));
          }
        }
      }
    }
  }
 

 
 
}   
   

   
   
   
   
  
  
  
  
  
  