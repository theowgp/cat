
class Engine {
  
  //width and height of the screen
  float w;
  float h;
  
  //parameters and constants such as repulsion/attraction range, force rtc.
  Params p;
  
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //size
  float s;
  //minimal allowed distance between birds
  float eps=5;
  
  //bird frames
  PImage[] frms;
  //for bird flapping images
  //int frameCounteri=0;
  //int frameCounter=0;
    int flappingRate;
  
  
  
  
  
  
  
  
  
  Engine(int n, float s, int flappingRate, Params p, float w, float h, PImage[] frms){
    this.frms = frms;
    this.p = p;
    this.flappingRate = flappingRate;
    
    // creating birds
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(p.floater_vr, s, w, h, flappingRate));
    }
    
    this.w=w;
    this.h=h;
    this.s=s;
  }
  
  
  
  void move(int j) {
    //float ddx=0;
    //float ddy=0;
    //close borders   
    //if ( floaters.get(j).x + ddx + floaters.get(j).vx > floaters.get(j).s && floaters.get(j).x + ddx + floaters.get(j).vx < w - floaters.get(j).s) floaters.get(j).x +=  floaters.get(j).vx + ddx;
    //if ( floaters.get(j).y + ddy + floaters.get(j).vy > floaters.get(j).s && floaters.get(j).y + ddy + floaters.get(j).vy < h - floaters.get(j).s) floaters.get(j).y +=  floaters.get(j).vy + ddy;
    
    if(allow(floaters.get(j).x + floaters.get(j).vx, floaters.get(j).y + floaters.get(j).vy, j)){
      floaters.get(j).x += floaters.get(j).vx;
      floaters.get(j).y += floaters.get(j).vy;
    }
  
    
    
    //to make a looping border of the frame
    if(floaters.get(j).x<=0) floaters.get(j).x = w-1;
    if(floaters.get(j).x>=w) floaters.get(j).x = 0;
    if(floaters.get(j).y<=0) floaters.get(j).y = h-1;
    if(floaters.get(j).y>=h) floaters.get(j).y = 0;
  }
  boolean allow(float x, float y, int j){
    for (int i = 0; i < floaters.size(); i++) {
      if((i!=j)&&(dist(x, y, floaters.get(i).x, floaters.get(i).y) < eps)){
        return false;                
      }
    }
    return true;
  }
  
  
  
  
  void determine_velocity(){
    for (int j = 0; j < floaters.size(); j++) {
      //determine relative velocities
      int ac = 1;
      for (int i = 0; i < floaters.size(); i++) {
        if (i!=j){//doesn't consider itself
          float d   = dist(floaters.get(i).x, floaters.get(i).y, floaters.get(j).x, floaters.get(j).y);
          //repulsion
          if(d <= p.floater_cr){
            floaters.get(j).vx = addd(floaters.get(j).vx, -((floaters.get(i).x-floaters.get(j).x)/d) * p.floater_crf * dforce_attraction(d));
            floaters.get(j).vy = addd(floaters.get(j).vy, -((floaters.get(i).y-floaters.get(j).y)/d) * p.floater_crf * dforce_attraction(d));
          }
          else
          //allignement
          //if (d<= p.floater_cal){
          //floaters.get(j).vx = addd(floaters.get(i).vx, floaters.get(j).vx);
          //floaters.get(j).vy = addd(floaters.get(i).vy, floaters.get(j).vy);
          //ac++;
          //}
          //else
          //attraction
          //if(d >= p.floater_ca && d <= p.floater_ca + p.bird_sight){
          if(d <= p.floater_ca){
            floaters.get(j).vx = addd(floaters.get(j).vx, ((floaters.get(i).x-floaters.get(j).x)/d) * p.floater_caf * dforce_attraction(d));
            floaters.get(j).vy = addd(floaters.get(j).vy, ((floaters.get(i).y-floaters.get(j).y)/d) * p.floater_caf * dforce_attraction(d));
          }
        }
      }
      //for the allignement
      //this combination makes birds fly nicely from right lower corner to the uper
      //floaters.get(j).vx = (floaters.get(j).vx+random(-p.floater_vr, 0)) /(ac+1)  ;
      //floaters.get(j).vy = (floaters.get(j).vy+random(-p.floater_vr, 0)) /(ac+1)  ;
      //floaters.get(j).vx /=ac; 
      //floaters.get(j).vy /=ac; 
    }
  }
  
  //floaters mowment laws
  float dforce_repulsion(float d){// returns value from [0, 1] d ranges from 0, floater_cr
    return (-d/p.floater_cr + 1); //thr smaller the distance d the stronger the repulsion 
  }
  float dforce_attraction(float d){// returns value from [0, 1] dranges from floater_ca to width+height 
    return ( (d-p.floater_ca)/(w+h-p.floater_ca) );//thr bigger the distance d the stronger the repulsion
  }
  
   
  //my defined addition to make sure the speed doesn't exceed its limits
  float addd(float a, float b){
     if(Math.abs(a + b) < p.floater_vr){
       return a+b;
     }
     else{
       if( a+b <= 0 ) return -p.floater_vr;
       else return p.floater_vr;
     }
   }
 
  
  
  
  
  
  
  void mouseDragged()  {
    if(mouseButton == LEFT){
      for (int i = 0; i < floaters.size(); i++) {
          floaters.get(i).vx = addd(floaters.get(i).vx, /*floater_vr*/(mouseX-floaters.get(i).x)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
          floaters.get(i).vy = addd(floaters.get(i).vy, /*floater_vr*/(mouseY-floaters.get(i).y)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
      }
    }
  }
  
 
  void mouseClicked()  {
    if(mouseButton == LEFT){
      for (int i = 0; i < floaters.size(); i++) {
          floaters.get(i).vx = addd(floaters.get(i).vx, /*floater_vr*/(mouseX-floaters.get(i).x)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
          floaters.get(i).vy = addd(floaters.get(i).vy, /*floater_vr*/(mouseY-floaters.get(i).y)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
       }
    }
    else{
      floaters.add(new Floater(p.floater_vr, s, w, h, mouseX-s/2, mouseY-s/2));
    }
  }
  
 
  
  void draw() {
    //determine velocity of each bird
    determine_velocity();
       
    //move each bird and draw it  
    for (int i = 0; i < floaters.size(); i++) {
      move(i);
      drawbird(i);
    }
  }
  
  void drawbird(int i) {
      //draw a flapping bird
      image(frms[floaters.get(i).frameCounteri], floaters.get(i).x, floaters.get(i).y, floaters.get(i).s, floaters.get(i).s);
      floaters.get(i).frameCounter++;
      if (floaters.get(i).frameCounter > flappingRate) {
       floaters.get(i).frameCounter=0;
       floaters.get(i).frameCounteri++;
      }
    
      if (floaters.get(i).frameCounteri == 3) floaters.get(i).frameCounteri = 0;
   }
   
   
   
   
  
  
  
  
  
} 
  