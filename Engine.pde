
class Engine {
  
  
  
  
    
  
  
  //array of floaters
  ArrayList<Floater> birds = new ArrayList<Floater>();
      
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  
  //array of floaters and birds
  ArrayList<Floater> agents = new ArrayList<Floater>();
  
  //array of floaters and agents in the net
  ArrayList<Floater> net = new ArrayList<Floater>();
  
  //size of a foater
  float s;
  //minimal distace required for a floater to reach betwen an edge it has just interracted with    
  //to interract with it again
  float dminf1f2 = 5;
  
  //for throwing a boid
  int pbk=-1;//pressed boid k
  
  //three fundamental forces: flocking, elasticity and friction
  Elasticity elasticity;
  Flocking flocking;
  float friction;
  
  float sensitivity = 0.4;
  
 
 
  
    
  
  
  
  
  Engine(int m, int n, float s, Elasticity elst, Flocking flk, float frct){
    this.s=s;
    this.friction=frct;
    
    this.elasticity=elst;
    this.flocking=flk;
    
    
    
    //create initial floater
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(elasticity.floater_vr, s));
    }
    for (int i = 1; i < n-1; i++) {
      floaters.get(i).left  = floaters.get(i-1);
      floaters.get(i).right = floaters.get(i+1);
    }
    floaters.get(0).left = null;
    floaters.get(0).right = floaters.get(1);
    floaters.get(n-1).left = floaters.get(n-2);
    floaters.get(n-1).right = null;
    
    
    //creating birds
    for (int i = 0; i < m; i++) {
      birds.add(new Floater(flocking.floater_vr, s));
      birds.get(i).left  = null;
      birds.get(i).right = null;
    }
    
    //create agents
    agents.addAll(birds);
    agents.addAll(floaters);
    
    //create the net
    net.addAll(floaters);
    
 
    elasticity.SetFloaters(net);
    flocking.SetFloaters(birds);
    
    
 }
  
  
  
  
  void IterateFrame(){
    println(net.size());
    //collide
    Collisions();
    
    //enable interactions with the last edge
    for (int i = 1; i < net.size()-1; i++) {
      if(!net.get(i).ilr){
        if( DistancePointLine(net.get(i), net.get(i).left, net.get(i).right) > net.get(i).s+100 ){//dminf1f2){
          net.get(i).ilr = true;
        }
      }
    }
    
    
    for (int i = 0; i < agents.size(); i++) {
      PlugIn(i);
    }
    
    for (int i = 1; i < net.size()-1; i++) {
      //ThrowOut(i);
    }
    
    DetermineVelocities();
    
    for (Floater f:agents) {
      Move(f);
    }
    
  }
  
  
  
  float DistancePointLine(Floater f, Floater f1, Floater f2){
    float x1 = f1.x;
    float x2 = f2.x;
    float y1 = f1.y; 
    float y2 = f2.y;
    
    float x0 = f.x;
    float y0 = f.y;
    
    return (float)(Math.abs((y2 - y1)*x0 - (x2 - x1)*y0 + x2*y1 - y2*x1)/Math.sqrt((y2 - y1)*(y2 - y1) + (x2 - x1)*(x2 - x1)));
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
    if((f != floaters.get(i))&&(dist(f.x+f.vx, f.y+f.vy, floaters.get(i).x, floaters.get(i).y) < f.s+2)){//eps)){
      return false;                
    }
  }
  return true;
  }
  
  
  void Collisions(){
    for (int i = 0; i < agents.size(); i++) {
      for (int j = 0; j < agents.size(); j++) {
        if( i!=j && dist(agents.get(i).x, agents.get(i).y, agents.get(j).x, agents.get(j).y) < (agents.get(i).s + agents.get(j).s)/2 ){//eps)){
          Collide(agents.get(i), agents.get(j));
        }
      }
    }
  }
  void Collide(Floater f1, Floater f2){
    //float teta1 = atan(Math.abs(f1.vy/f1.vx));
    //float teta2 = atan(Math.abs(f2.vy/f2.vx));
    float v1 = (float)Math.sqrt(f1.vx*f1.vx + f1.vy*f1.vy);
    float v2 = (float)Math.sqrt(f2.vx*f2.vx + f2.vy*f2.vy);
    float av = (v1+v2)/2;
    
    float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
    float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
   
    elasticity.AddVelocity(f1, ndy*av, ndx*av); 
  } 
  
  
  
  
  void DetermineVelocities(){
    //flocking.Apply();//for birds    
    elasticity.Apply();//for floaters
  }
  
 

 
 
 

 boolean PlugIn(int k){
  boolean res = false; 
  for (int i = 1; i < net.size(); i++) {
     if(k != i && k != i-1 && IsOnTheLineBetween(agents.get(k), net.get(i-1), net.get(i)) ){
       //if( (agents.get(k).left != null && agents.get(k).right != null) && (agents.get(k).left == net.get(i-1) && agents.get(k).right == net.get(i)) ){
       //  if(agents.get(k).ilr){
       //    net.add(i, agents.get(k));
       //    agents.get(k).ilr = false;
       //    res = true;
       //  }
       //}
       //else{
         agents.get(k).ilr = false;
         net.get(i-1).right=agents.get(k);
         net.get(i).left=agents.get(k);
         
         net.add(i, agents.get(k));
         net.get(i).right = net.get(i+1);
         net.get(i).left = net.get(i-1);
         res = true;
       //}
     }
  }
  return res;
 }
 
 
 boolean ThrowOut(int k){
   boolean res = false; 
   if( IsOnTheLineBetween(net.get(k), net.get(k-1), net.get(k+1)) ){
          net.remove(k);
          net.trimToSize();
          res = true;
          println("Out");
   } 
   return res;
 }
 
//float Distff1f2(int k){
//  boolean res = false; 
//  for (int i = 1; i < floaters.size(); i++) {
//     if(k != i && k != i-1 && IsOnTheLineBetween(floaters.get(k), floaters.get(i-1), floaters.get(i)) ){
//        floaters.add(i, floaters.get(k));
//        res = true;
//     }
//  }
//  return res;
// }
 
 
 

 

  boolean IsOnTheLineBetween(Floater f, Floater f1, Floater f2){
    float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
    float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
    
    float x1 = f1.x - ndx*f1.s  - f.x;
    float x2 = f2.x + ndx*f2.s  - f.x;
    float y1 = f1.y - ndy*f1.s  - f.y;
    float y2 = f2.y + ndy*f2.s  - f.y;
    
    fill(0);
    strokeWeight(5); 
    line(x1+ f.x,y1+f.y,x2+f.x,y2+f.y);
    ellipseMode(CENTER);
    //ellipse(f.x,f.y, 30, 30);
    
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
  //void mouseClicked()  {
  //  if(mouseButton == RIGHT){
  //    floaters.add(new Floater(flocking.floater_vr, s, mouseX-s/2, mouseY-s/2));
  //  }
  //}
  
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
   

   
   
   
   
  
  
  
  
  
  