
class Engine {
  
  
  
  
    
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //size of a bird
  float s;
  //minimal allowed distance between birds
  float eps=4;
  
  //for throwing a boid
  int pbk=-1;//pressed boid k
  
  //three fundamental forces: flocking, elasticity and friction
  Elasticity elasticity;
  Flocking flocking;
  float friction;
  
 
 
  
    
  
  
  
  
  Engine(int n, float s, Elasticity elst, Flocking flk, float frct){
    this.s=s;
    this.friction=frct;
    
    this.elasticity=elst;
    this.flocking=flk;
    
    
    
    //creating floaters
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(flocking.floater_vr, s));
    }
    //Pass the floaters to the Forces
    elasticity.SetFloaters(floaters);
    flocking.SetFloaters(floaters);
 }
  
  
  
  
  void IterateFrame(){
    DetermineVelocities();
    for (int i = 0; i < floaters.size(); i++) {
      Move(floaters.get(i));
    }
  }
  
  
  
  
  
  void Move(Floater f) {
    if(Allow(f)){
      f.x += f.vx * friction;
      f.y += f.vy * friction;
    }
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
    //flocking.Apply();    
    elasticity.Apply();
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
         floaters.get(pbk).x=mouseX-floaters.get(pbk).s/2;
         floaters.get(pbk).y=mouseY-floaters.get(pbk).s/2;
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
          if(pmouseX > floaters.get(i).x && pmouseX < floaters.get(i).x+floaters.get(i).s && pmouseY > floaters.get(i).y && pmouseY < floaters.get(i).y + floaters.get(i).s){
            pbk=i;
          }
      }
      if(pbk>=0){
        floaters.get(pbk).x=mouseX-floaters.get(pbk).s/2;
        floaters.get(pbk).y=mouseY-floaters.get(pbk).s/2;
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
   

   
   
   
   
  
  
  
  
  
  