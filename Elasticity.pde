class Elasticity extends Force {
  
 
  Elasticity(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
  }
  
  
  
  
  
  
  void Apply(){
    for (int i = 1; i < floaters.size(); i++) {
      Interract(floaters.get(i-1), floaters.get(i));
      Interract(floaters.get(floaters.size()-i), floaters.get(floaters.size()-i-1));
    }
  }
 
 
}   
   