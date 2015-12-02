class Params{
  
  // constraining the range(and velocitfloaters[j].y range) at which birds can move at a time
  public float floater_xr=10;
  public float floater_yr=10;
  public float floater_vr=10;
  
 
  
  //independent movement's laws
  public float floater_cr=10;//repulsion range
  public float floater_crf=4;//repulsion force
  public float floater_cal=70;//allignment range
  public float floater_ca= 250;//attraction range
  public float floater_caf=2;//attraction force
  //public float bird_sigh1=250 ;
  
  
  //friction coefficient
  float friction=0.5;
  
 
     
}