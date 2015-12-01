class Params{
  
  // constraining the range(and velocitfloaters[j].y range) at which birds can move at a time
  public float floater_xr=10;
  public float floater_yr=10;
  public float floater_vr=10;
  
 
  
  //independent movement's laws
  public float floater_cr=10;//repulsion range
  public float floater_crf=7;//repulsion force
  public float floater_cal=30;
  public float floater_ca= 40;//attraction range
  public float bird_sigh1=250 ;
  public float floater_caf=5;//attraction force
  
  //friction coefficient
  float friction=0.5;
  
 
     
}