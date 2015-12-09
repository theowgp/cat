
class Engine {
  
  
  
  
    
  
  //array of floaters
  ArrayList<Floater> birds = new ArrayList<Floater>();
  //size of a bird
    
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //size of a foater
  float s;
  //minimal allowed distance between birds
  float eps=4;
  
  //for throwing a boid
  int pbk=-1;//pressed boid k
  
  //three fundamental forces: flocking, elasticity and friction
  Elasticity elasticity;
  Flocking flocking;
  float friction;
  
  float sensitivity =0.4;
  
 
 
  
    
  
  
  
  
  Engine(int n, float s, Elasticity elst, Flocking flk, float frct){
    this.s=s;
    this.friction=frct;
    
    this.elasticity=elst;
    this.flocking=flk;
    
    
    
    //create initial floater
    floaters.add(new Floater(flocking.floater_vr, s));
    
    //creating birds
    for (int i = 0; i < n; i++) {
      birds.add(new Floater(flocking.floater_vr, s));
    }
    
    
    elasticity.SetFloaters(floaters);
    
    
    flocking.SetFloaters(birds);
 }
  
  
  
  
  void IterateFrame(){
    DetermineVelocities();
    
    for (int i = 0; i < floaters.size(); i++) {
      Move(floaters.get(i));
    }
    
    for (int i = 0; i < birds.size(); i++) {
      //Move(floaters.get(i));
      Move(birds.get(i));
    }
    
    for (int i = 0; i < floaters.size(); i++) {
      //if(!ThrowOut(i))PlugIn(i);
      //ThrowOut(i);
      PlugIn(i);
    }
      
    
  }
  
  
  
  
  
  void Move(Floater f) {
    //if(Allow(f)){
      f.x += f.vx * friction;
      f.y += f.vy * friction;
    //}
  }
  
  //does not allow floaters to move to close
  boolean Allow(Floater f){
   for (int i = 0; i < floaters.size(); i++) {
     if((f != floaters.get(i))&&(dist(f.x+f.vx, f.y+f.vy, floaters.get(i).x, floaters.get(i).y) < eps)){
       return false;                
     }
   }
   return true;
  }
  
  
  
  
  
  void DetermineVelocities(){
    flocking.Apply();//for birds    
    //elasticity.Apply();//for floaters
  }
  
 

 
 
 

 boolean PlugIn(int k){
  boolean res = false; 
  for (int i = 1; i < floaters.size(); i++) {
     if(k != i && k != i-1 && IsOnTheLineBetween(floaters.get(k), floaters.get(i-1), floaters.get(i)) ){
        floaters.add(i, new Floater(floaters.get(k)));
        res = true;
     }
  }
  return res;
 }
 
 boolean ThrowOut(int k){
  boolean res = false; 
  for (int i = 1; i < floaters.size()-1; i++) {
      if(floaters.get(k) == floaters.get(i)){
        if( k != i-1 && k != i+1 &&  IsOnTheLineBetween(floaters.get(k), floaters.get(i-1), floaters.get(i+1)) ){
          floaters.remove(k);
          floaters.trimToSize();
          res = true;
          println("Out");
          
        }
      }
    } 
   return res;
 }
 

 
 
 
 

    boolean IsOnTheLineBetween(Floater f, Floater f1, Floater f2){
    float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
    float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
    
    float x1 = f1.x - ndx*f1.s  - f.x;
    float x2 = f2.x + ndx*f2.s  - f.x;
    float y1 = f1.y - ndy*f1.s  - f.y;
    float y2 = f2.y + ndy*f2.s  - f.y;
    
    float s = ((f.s/2)* sensitivity)*((f.s/2)* sensitivity);
    float a = x1*x1 - 2*x1*x2 + x2*x2 + y1*y1 - 2*y1*y2 + y2*y2;
    float b = 2*x1*x2 - 2*x2*x2 + 2*y1*y2 - 2*y2*y2;
    float c = x2*x2 + y2*y2 - s;
    
    float d = b*b - 4*a*c;
    if (d<0) return false;
    
    float t1 = (float)( (-b - Math.sqrt(d)) / (2*a) );
    float t2 = (float)( (-b + Math.sqrt(d)) / (2*a) );
    
    if(0<=t1 && t1<=1) return true;
    if(0<=t2 && t2<=1) return true;
    
    return false;    
  }
   
   
  boolean IsInRectangle(float x, float y, float rx, float ry, float rl, float rw){
    if(x > rx && x < rx+rl && y > ry && y < ry + rw){
      return true;
    }
    return false;
  }
  
  
  
  //spawn a floater
  void mouseClicked()  {
    if(mouseButton == RIGHT){
      floaters.add(new Floater(flocking.floater_vr, s, mouseX-s/2, mouseY-s/2));
    }
  }
  
 //drag a seazed pbk-th floater 
 void mouseDragged()  {
    if(pbk>=0){
         floaters.get(pbk).x = mouseX;
         floaters.get(pbk).y = mouseY;
         floaters.get(pbk).vx = 0;
         floaters.get(pbk).vy = 0;
    }
    else{
      for (int i = 0; i < floaters.size(); i++) {
        flocking.Interract(floaters.get(i), mouseX, mouseY);
      }
    }
  }
 
  
  //if a floater is pressed then grab it and drag it othervise induce flocking force
  //pbk - indeks of the siezed floater
  void mousePressed()  {
    if(mouseButton == LEFT){
      //find out which boid is pressed, if it is pressed
      for (int i = 0; i < floaters.size(); i++) {
          //check if the pointer is in the square surrounding a boid
          //if(pmouseX > floaters.get(i).x && pmouseX < floaters.get(i).x+floaters.get(i).s && pmouseY > floaters.get(i).y && pmouseY < floaters.get(i).y + floaters.get(i).s){
          //  pbk=i;
          //}
          if (IsInRectangle(mouseX, mouseY, floaters.get(i).x - floaters.get(i).s/2, floaters.get(i).y - floaters.get(i).s/2, floaters.get(i).s, floaters.get(i).s)){
            pbk=i;
          }
          
      }
      if(pbk>=0){
        floaters.get(pbk).x = mouseX;
        floaters.get(pbk).y = mouseY;
        floaters.get(pbk).vx = 0;
        floaters.get(pbk).vy = 0;
        floaters.get(pbk).still = true; 
      }
      // if no boid has been pressed then (flocking)Interract
      else{
        for (int i = 0; i < floaters.size(); i++) {
          flocking.Interract(floaters.get(i), mouseX, mouseY);
        }
      }
    }
  }
 
 
  //to release the floater from the grip
  void mouseReleased()  {
    if(mouseButton == LEFT){
      if(pbk>=0){
         //determine the velocity at which to throw the ball
         elasticity.AddVelocity(floaters.get(pbk), mouseX-pmouseX,  mouseY-pmouseY);
         //make a floater movable again
         floaters.get(pbk).still = false;
         pbk=-1;
      }
    }
    
  }

 
 
 
}   
   

   
   
   
   
  
  
  
  
  
  