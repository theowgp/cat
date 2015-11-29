
class Engine {
  
  //width and height of the screen
  float w;
  float h;
  
  //parameters and constants such as repulsion/attraction range, force rtc.
  Params p;
  
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  
  //bird frames
  PImage[] frms;
  //for bird flapping images
  int frameCounteri=0;
  int frameCounter=0;
  
  
  
  
  
  
  
  
  
  Engine(int n, float s, Params p, float w, float h, PImage[] frms){
    this.frms=frms;
    this.p=p;
    
    // creating birds
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(p.floater_vr, s, w, h));
    }
    
    this.w=w;
    this.h=h;
    
    
  }
  
  
  
  void move(int j) {
    //float ddx=0;
    //float ddy=0;
    //close borders   
    //if ( floaters.get(j).x + ddx + floaters.get(j).vx > floaters.get(j).s && floaters.get(j).x + ddx + floaters.get(j).vx < w - floaters.get(j).s) floaters.get(j).x +=  floaters.get(j).vx + ddx;
    //if ( floaters.get(j).y + ddy + floaters.get(j).vy > floaters.get(j).s && floaters.get(j).y + ddy + floaters.get(j).vy < h - floaters.get(j).s) floaters.get(j).y +=  floaters.get(j).vy + ddy;
    
    floaters.get(j).x += floaters.get(j).vx;
    floaters.get(j).y += floaters.get(j).vy;
  
    
    
    //to make a looping border of the frame
    if(floaters.get(j).x<=0) floaters.get(j).x = w-1;
    if(floaters.get(j).x>=w) floaters.get(j).x = 0;
    if(floaters.get(j).y<=0) floaters.get(j).y = h-1;
    if(floaters.get(j).y>=h) floaters.get(j).y = 0;
  }
  
  
  
  
  void determine_velocity(){
    for (int j = 0; j < floaters.size(); j++) {
      //determine relative velocities
      for (int i = 0; i < floaters.size(); i++) {
        if (i!=j){//doesn't consider itself
          float d   = dist(floaters.get(i).x, floaters.get(i).y, floaters.get(j).x, floaters.get(j).y);
          //repulsion
          if(d <= p.floater_cr){
            floaters.get(j).vx = addd(floaters.get(j).vx, -((floaters.get(i).x-floaters.get(j).x)/d) * p.floater_crf * dforce_attraction(d));
            floaters.get(j).vy = addd(floaters.get(j).vy, -((floaters.get(i).y-floaters.get(j).y)/d) * p.floater_crf * dforce_attraction(d));
          }
          else//attraction
          //if(d >= floater_ca && d <= floater_ca + bird_sight){
          if(d <= p.floater_ca){
            floaters.get(j).vx = addd(floaters.get(j).vx, ((floaters.get(i).x-floaters.get(j).x)/d) * p.floater_caf * dforce_attraction(d));
            floaters.get(j).vy = addd(floaters.get(j).vy, ((floaters.get(i).y-floaters.get(j).y)/d) * p.floater_caf * dforce_attraction(d));
          }
        }
      }
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
 
  
  
  
  
  
  
  void mouseDragged(int mouseX, int mouseY)  {
    for (int i = 0; i < floaters.size(); i++) {
        floaters.get(i).vx = addd(floaters.get(i).vx, /*floater_vr*/(mouseX-floaters.get(i).x)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
        floaters.get(i).vy = addd(floaters.get(i).vy, /*floater_vr*/(mouseY-floaters.get(i).y)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
     }
  }
  
 
  void mouseClicked(int mouseX, int mouseY)  {
    for (int i = 0; i < floaters.size(); i++) {
        floaters.get(i).vx = addd(floaters.get(i).vx, /*floater_vr*/(mouseX-floaters.get(i).x)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
        floaters.get(i).vy = addd(floaters.get(i).vy, /*floater_vr*/(mouseY-floaters.get(i).y)/dist(mouseX, mouseY, floaters.get(i).x, floaters.get(i).y));
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
      image(frms[frameCounteri], floaters.get(i).x, floaters.get(i).y, floaters.get(i).s, floaters.get(i).s);
      frameCounter++;
      if (frameCounter > 8) {
        frameCounter=0;
        frameCounteri++;
      }
    
      if (frameCounteri == 3) frameCounteri = 0;
   }
   
   
   
   
  
  
  
  
  
} 
  