
class Engine {
  
  
  
  
    
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //size of a bird
  float s;
  //minimal allowed distance between birds
  float eps=4;
  
  //for throwing a boid
  int pbk=-1;//pressed boid k
  
  //two fundamental forces
  Elasticity elasticity;
  Flocking flocking;
 
  
    
  
  
  
  
  
  
  
  Engine(int n, float s, Elasticity elst, Flocking flk){
    this.s=s;
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
    //close borders   
    //if ( f.x + f.vx > f.s && f.x  + f.vx < w - f.s) f.x +=  f.vx;
    //if ( f.y + f.vy > f.s && f.y  + f.vy < h - f.s) f.y +=  f.vy;
    
    if(Allow(f)){
      f.x += f.vx;// * p.friction;
      f.y += f.vy;// * p.friction;
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
    //flocking.Act();    
    elasticity.Act();
  }
  
 

 
 
 
  
 
  
  
  
  
  
  void mouseClicked()  {
    if(mouseButton == RIGHT){
      floaters.add(new Floater(flocking.floater_vr, s, mouseX-s/2, mouseY-s/2));
    }
  }
  
 
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
 
 
  void mouseReleased()  {
    if(mouseButton == LEFT){
      if(pbk>=0){
         //floaters.get(pbk).x = mouseX - floaters.get(pbk).s/2;
         //floaters.get(pbk).y = mouseY - floaters.get(pbk).s/2;
         
         //determine the velocity at which to throw the ball
         //new velocity
         float newvx = (mouseX-pmouseX);
         float newvy = (mouseY-pmouseY);
         
         //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
         float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
         if(dnewv > elasticity.floater_vr)
         {
          newvx /= dnewv/elasticity.floater_vr;
           
          newvy /= dnewv/elasticity.floater_vr;
         }
         
         floaters.get(pbk).vx = newvx;
         floaters.get(pbk).vy = newvy;
         floaters.get(pbk).still = false;
         pbk=-1;
      }
    }
    
  }

 
 
 
}   
   

   
   
   
   
  
  
  
  
  
  