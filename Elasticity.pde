class Elasticity extends Force {
  
 
  Elasticity(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
  }
  
  
  void CreateMatrix(){
    matrix = new int[floaters.size()][floaters.size()];
    
    for (int i = 0; i < floaters.size(); i++) {
      for (int j = 0; j < floaters.size(); j++) {
        if(Math.abs(i-j) == 1) matrix[i][j] = 1;
        else matrix[i][j] = 0;
      }
    }
  }
  
  
 
}   
   