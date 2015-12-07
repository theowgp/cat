
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
    
    for (Floater f : floaters) {
      ArrayList<Floater[]> dashedlines = DashedLines(f);
      for(Floater[] dl : dashedlines){
        //println("in the loop");
        if(!ThrowOut(f, dl[0], dl[1])){
          PlugIn(f, dl[0], dl[1]);
          println("Go in PlugIn");
        }
      }
            
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
    flocking.Apply();//for birds    
    elasticity.Apply();//for floaters
  }
  
 
 
 ArrayList<Floater[]> DashedLines(Floater f){
   ArrayList<Floater[]> dashedlines = new ArrayList<Floater[]>(); 
    
   for (int i = 1; i < floaters.size(); i++) {
     if(f != floaters.get(i-1) && f != floaters.get(i)){
       if( IsInDashedAreaOf(f, floaters.get(i-1), floaters.get(i)) ){
         dashedlines.add( new Floater[]{floaters.get(i-1), floaters.get(i)} );
         //Floater[] dl = new Floater[2];
         //dl[0]=floaters.get(i-1);
         //dl[1]=floaters.get(i);
         //dashedlines.add(dl);
         //println("Is in DA");
       }
     }
   }
   return dashedlines;
 }
 
 
 
 

 boolean ThrowOut(Floater f, Floater f1, Floater f2){
  boolean res = false; //<>//
  for (int i = 1; i < floaters.size()-1; i++) {
    if(f == floaters.get(i)){
      if(floaters.get(i-1) == f1 && floaters.get(i+1) == f2){
        floaters.remove(i);
        floaters.trimToSize();
        res = true;
        println("Out");
      }
    }
  }
  return res;
 }
 
 void PlugIn(Floater f, Floater f1, Floater f2){
  for (int i = 1; i < floaters.size(); i++) {//can be optimized if return is in the loop
      if(floaters.get(i-1) == f1 && floaters.get(i) == f2){
        floaters.add(i, f);
        println("In");
      }
    }
 }
 

 
 
 
 

   boolean IsInDashedAreaOf(Floater f, Floater f1, Floater f2){
      float xx = f.x;
      float yy = f.y;
      
      float x = f2.x - f1.x;
      float y = f2.y - f1.y;
      float angle;
      float cos = (float)( x / Math.sqrt(x*x + y*y) );
         
      //println("y=",y, " acs=", acos(cos));
      if(y >= 0) angle= acos(cos);
      else angle = -acos(cos);
      
      pushMatrix();
      
      translate(f1.x, f1.y);
      xx-=f1.x;
      yy-=f1.y;
      
      
      rotate(angle);
      //xx = (float)( xx*Math.cos(angle) - yy*Math.sin(angle) );
      //yy = (float)( xx*Math.sin(angle) + yy*Math.cos(angle) );
      float cosphi=(float)(xx/Math.sqrt(xx*xx + yy*yy));
      float sinphi=(float)(yy/Math.sqrt(xx*xx + yy*yy));
      xx = ( xx/cosphi)*(float)Math.cos((acos(cosphi)-acos(cos)));
      yy = ( yy/sinphi)*(float)Math.sin((acos(cosphi)-acos(cos)));
      
      
      translate(f1.s/2, -f1.s/2);
      xx-=f1.s/2;
      yy-=-f1.s/2;
      //
      //strokeWeight(2); 
      //fill(255);
      //rect(0, 0, dist(f1.x, f1.y, f2.x, f2.y)-f1.s, f1.s);
      //ellipseMode(CENTER);
      //ellipse(xx, yy, 10, 10);
      //
      //println(IsInRectangle(xx, yy, 0, 0, dist(f1.x, f1.y, f2.x, f2.y)-f1.s/2, f1.s));
      boolean res = IsInRectangle(xx, yy, 0, 0, dist(f1.x, f1.y, f2.x, f2.y)-f1.s/2, f1.s);
      
      popMatrix();
      return res;
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
   

   
   
   
   
  
  
  
  
  
  