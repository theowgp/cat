class Params{
  
  // constraining the range(and velocitfloaters[j].y range) at which birds can move at a time
  public float floater_xr=10;
  public float floater_yr=10;
  public float floater_vr=10;
  
 
  
  //independent movement's laws
  public float floater_cr=30;//repulsion range
  public float floater_crf=4;//repulsion force
  public float floater_cal=50;//allignment range
  public float floater_ca= 250;//attraction range
  public float floater_caf=2;//attraction force
  //public float bird_sigh1=250 ;
  
  
  //elasticity laws
  float elstc_dr  = 30;//elasticyty repose distance
  float elstc_eps = 3;// state of repose = [elstc_dr - elstc_eps, elstc_dr + elstc_eps] 
  float elstc_db = (float)Math.sqrt(width*width + height*height);//elasticity bound distance
  float elstc_f = 10;//elacticity force
  float elstc_vr=10;
  
  
  
  //friction coefficient
  float friction=0.5;
  
 
     
}