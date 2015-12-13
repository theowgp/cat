
class Engine {
  
  
  
  

  
  //array of floaters
  ArrayList<Floater> birds = new ArrayList<Floater>();
      
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  //number of floaters
  int n; 
  
  //array of floaters and birds
  ArrayList<Floater> agents = new ArrayList<Floater>();
  //number of birds
  int m;
  
  //array of floaters and agents in the net
  ArrayList<Integer> net = new ArrayList<Integer>();
  
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
  
  float sensitivity = 2;
  
 
 
  
    
  
  
  
  
  Engine(int m, int n, float s, Elasticity elst, Flocking flk, float frct){
    this.s=s;
    this.friction=frct;
    
    this.elasticity=elst;
    this.flocking=flk;
    this.n=n;
    this.m=m;
    
    
    
    //create initial floater
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(elasticity.floater_vr, s, false));
      floaters.get(i).number = m + i;
      
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
      birds.add(new Floater(flocking.floater_vr, s, true));
      birds.get(i).left  = null;
      birds.get(i).right = null;
      birds.get(i).number = i;
    }
    
    //create agents
    agents.addAll(birds);
    agents.addAll(floaters);
    
    
    //add floaters to the net 
    for (int i = 0; i < n; i++) {
      net.add(m + i);
    }
    
    
 
    
    flocking.SetFloaters(birds);
    flocking.CreateMatrix();
    
    elasticity.SetFloaters(agents);
    //create incidency matrix for elasticity
    int [][] matrix = new int[m+n][m+n];
    for(int i = 0; i < m + n; i++){
      for(int j = 0; j < m + n; j++){
        if(i >= m && j >= m && Math.abs(i-j) == 1) matrix[i][j] = 1;
        else  matrix[i][j] = 0;
         
      }
    }
    elasticity.SetMatrix(matrix);
  
 }
  
  
  

  
  
  
  
  void IterateFrame(){
    //collide
    Collisions();
      
    //enable interactions with the last edge
    for (int i = 0; i < m+n; i++) {
      if(!agents.get(i).ilr){
        if(agents.get(i).left != null && agents.get(i).right != null){
          if( DistancePointLine(agents.get(i), agents.get(i).left, agents.get(i).right) > agents.get(i).s ){//dminf1f2){
            agents.get(i).ilr = true;
            //if(i==1)println("WTF1");
          }
          else{
            agents.get(i).ilr = false;
          }
        }
        else{
          agents.get(i).ilr = true;
          //if(i==1)println("WTF2");
        }
      }
    }
    //println(agents.get(1).ilr);
    //println(DistancePointLine(agents.get(1), agents.get(agents.get(1).left), agents.get(agents.get(1).right)));


    for (int i = 0; i < m+n; i++) {
      //PlugIn(i);
      //ThrowOut(i);
      if(!PlugIn(i))ThrowOut(i);
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
    //if(Allow(f)){
      f.x += f.vx * friction;
      f.y += f.vy * friction;
    //}
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
  
  
  
  //Apply forces
  void DetermineVelocities(){
    flocking.Apply();//for birds    
    elasticity.Apply();//for floaters
  }
  
 

 
  //<>// //<>// //<>// //<>//
 
 //go through all the edges of the representative graph and 
 //plug the floater if it is "positioned" on line segment between a pair of floaters representing an edge in the representative graph
 boolean PlugIn(int k){
   boolean res = false;
   for ( Integer[] edge:GetEdges() ) {
     if( k!=edge[0] && k!=edge[1] && IsOnTheLineBetween(agents.get(k), agents.get(edge[0]), agents.get(edge[1])) ){
       //println("IN");
       //println(edge[0], k, edge[1]);
       //println(agents.get(k).left , k, agents.get(k).right);
       //println(agents.get(k).ilr);
       if( (agents.get(k).left != null && agents.get(k).right != null) && ((agents.get(k).left == agents.get(edge[0]) && agents.get(k).right == agents.get(edge[1]))||((agents.get(k).left == agents.get(edge[1]) && agents.get(k).right == agents.get(edge[0])))) ){
         //println("0: ", agents.get(k).ilr);
         if(agents.get(k).ilr){
           AddToNet(k, edge[0], edge[1]);  
         
           res = true;
         }
       }
       else{
         AddToNet(k, edge[0], edge[1]); 
         
         res = true;
       }
       
     }
   }
   UpdateMatrix();
   if(res==true){println("in");println("net size: ",net.size());}
   //if(res)agents.get(k).ilr = false;
   //if(res)println("1: ", agents.get(k).ilr);
   //if(res)println();
   return res;
 }
 
 void AddToNet(int f, int f1, int f2){
   for(int i = 1; i < net.size(); i++){
     if( (net.get(i-1) == f1 && net.get(i) == f2) || (net.get(i-1) == f2 && net.get(i) == f1) ){
       net.add(i, f);
       agents.get(net.get(i)).left = agents.get(net.get(i-1)); 
       agents.get(net.get(i)).right = agents.get(net.get(i+1));
       agents.get(net.get(i-1)).right = agents.get(net.get(i));
       agents.get(net.get(i+1)).left = agents.get(net.get(i));
     }
   }
   agents.get(f).ilr = false;
   //agents.get(f).ilr = true;
 }
 

 ArrayList<Integer[]> GetEdges(){
   ArrayList<Integer[]> edges = new ArrayList<Integer[]>();
   for (int i = 0; i < m+n; i++) {
      for (int j = i; j < m+n; j++) {
        if(elasticity.matrix[i][j] > 0) edges.add( new Integer[]{i, j} );
      }
    } 
    return edges;
 }





 //get all incident floaters to the given floater and 
 //check if it is "positioned" on the line segment between any two of its incident floaters 
 boolean ThrowOut(int k){
   
   boolean res = false;
   ArrayList<Integer> incdc = GetIncidentFloaters(k);  
   for (int i = 0; i < incdc.size(); i++) {
     for (int j = i+1; j < incdc.size(); j++) {
       if( IsOnTheLineBetween(agents.get(k), agents.get(incdc.get(i)), agents.get(incdc.get(j))) ){
         //println("OUT");
         //println(incdc.get(i), k, incdc.get(j));
         //println(agents.get(k).left , k, agents.get(k).right);
         //println(agents.get(k).ilr);
         if( (agents.get(k).left != null && agents.get(k).right != null) && ((agents.get(k).left == agents.get(incdc.get(i)) && agents.get(k).right == agents.get(incdc.get(j)))||((agents.get(k).left == agents.get(incdc.get(j)) && agents.get(k).right == agents.get(incdc.get(i))))) ){
            //println("0: ", agents.get(k).ilr);
            if(agents.get(k).ilr){
              RemoveFromNet(k, incdc.get(i), incdc.get(j));
               
         
              res = true;
            }
          }
          else{
            RemoveFromNet(k, incdc.get(i), incdc.get(j));
            
            res = true;
          }
       }
     }
   }
   UpdateMatrix();
   //if(res==true){println("out");println("net size: ",net.size());}
   //if(res)agents.get(k).ilr = false;
   //if(res)println("1: ", agents.get(k).ilr);
   //if(res)println();
   return res;
 }
 
 void RemoveFromNet(int f, int f1, int f2){
   for(int i = 1; i < net.size()-1; i++){
     if(   ((net.get(i-1) == f1 && net.get(i+1) == f2) || (net.get(i-1) == f2 && net.get(i+1) == f1))  &&  net.get(i) == f   ){
       net.remove(i);
       agents.get(net.get(i-1)).right = agents.get(net.get(i));
       agents.get(net.get(i)).left = agents.get(net.get(i-1));
     }
   }
   agents.get(f).ilr = false;
   //agents.get(f).ilr = true;
 }

 ArrayList<Integer> GetIncidentFloaters(int k){
   ArrayList<Integer> incdc = new ArrayList<Integer> ();
   for (int j = 0; j < m+n; j++) {
        if(elasticity.matrix[k][j] > 0) incdc.add(j);
   } 
    return incdc;
 }
 
 
 
 void UpdateMatrix(){
   for(int i=0; i < m + n; i++){
      for(int j=0; j < m + n; j++){
        elasticity.matrix[i][j] = 0;
      }
   }
   for(int i = 1; i < net.size(); i++){
     elasticity.matrix[net.get(i-1)][net.get(i)]++;
     elasticity.matrix[net.get(i)][net.get(i-1)]++;
   }
 }
 
 
 
 
 //the same as below but with normalized velocity vector
 boolean IsOnTheLineBetween(Floater f, Floater f1, Floater f2){
   if(f.vx == 0 && f.vy == 0) return false;  
    
   float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
   float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
   float nx = ndx/ndy;
   float ny = -1;
   nx = (float)(nx/Math.sqrt(nx*nx+ny*ny));
   ny = (float)(ny/Math.sqrt(nx*nx+ny*ny));
   float cos = (float)((nx*f.vx+ny*f.vy)/Math.sqrt(f.vx*f.vx+f.vy*f.vy));
   //float angle = min(acos(cos), PI-acos(cos));
   if(acos(cos) > PI-acos(cos)){
    nx=-nx;
    ny=-ny;
   }
    
   float nvx = (float)(nx*Math.sqrt(f.vx*f.vx+f.vy*f.vy));  
   float nvy = (float)(ny*Math.sqrt(f.vx*f.vx+f.vy*f.vy));
    
   //pushMatrix();
   //translate(f.x, f.y);
   //strokeWeight(2);
   //line(0, 0, nvx*sensitivity, nvy*sensitivity);
   //ellipseMode(CENTER); 
   //ellipse(nvx*sensitivity, nvy*sensitivity, f.s/4, f.s/4);
   //popMatrix();
    
   float x1 = f1.x - ndx*f1.s;
   float x2 = f2.x + ndx*f2.s;
   float x3 = f.x;
   float x4 = f.x + nvx;// * sensitivity;
      
   float y1 = f1.y - ndy*f1.s;
   float y2 = f2.y + ndy*f2.s;
   float y3 = f.y;
   float y4 = f.y + nvy;// * sensitivity;
      
   float a1 = (y1-y2)/(x1-x2);
   float a2 = (y3-y4)/(x3-x4);
   float b1 = y1-a1*x1;
   float b2 = y3-a2*x3;
      
   float xa = (b2 - b1) / (a1 - a2);
   //float ya = a1 * xa + b1;
      
      
     if ( (xa < max( min(x1,x2), min(x3,x4) )) || (xa > min( max(x1,x2), max(x3,x4) )) )
       return false; // intersection is out of bound
     else
       return true;
 }

  //checks for intersection of the velocity vector of the a floater with and edge
  //boolean IsOnTheLineBetween(Floater f, Floater f1, Floater f2){
  //  if(f.vx == 0 && f.vy == 0) return false;  
    
  //  float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
  //  float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
    
  //  float x1 = f1.x - ndx*f1.s;
  //  float x2 = f2.x + ndx*f2.s;
  //  float x3 = f.x;
  //  float x4 = f.x + f.vx;
      
  //  float y1 = f1.y - ndy*f1.s;
  //  float y2 = f2.y + ndy*f2.s;
  //  float y3 = f.y;
  //  float y4 = f.y + f.vy;
      
  //  float a1 = (y1-y2)/(x1-x2);
  //  float a2 = (y3-y4)/(x3-x4);
  //  float b1 = y1-a1*x1;
  //  float b2 = y3-a2*x3;
      
  //  float xa = (b2 - b1) / (a1 - a2);
  //  //float ya = a1 * xa + b1;
      
      
  //    if ( (xa < max( min(x1,x2), min(x3,x4) )) || (xa > min( max(x1,x2), max(x3,x4) )) )
  //      return false; // intersection is out of bound
  //    else
  //      return true;
  //}

  //checks if an edge intersects the ball of radius f.s/2 in the center f.x f.y of a floater f
  //this function requires check with f.left and f.right
  //boolean IsOnTheLineBetween(Floater f, Floater f1, Floater f2){
  //  float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
  //  float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
    
  //  float x1 = f1.x - ndx*f1.s  - f.x;
  //  float x2 = f2.x + ndx*f2.s  - f.x;
  //  float y1 = f1.y - ndy*f1.s  - f.y;
  //  float y2 = f2.y + ndy*f2.s  - f.y;
    
  //  //fill(0);
  //  //strokeWeight(5); 
  //  //line(x1+ f.x,y1+f.y,x2+f.x,y2+f.y);
  //  //ellipseMode(CENTER);
  //  ////ellipse(f.x,f.y, 30, 30);
    
  //  float s = ((f.s/2)* sensitivity)*((f.s/2)* sensitivity);
  //  float a = x1*x1 - 2*x1*x2 + x2*x2 + y1*y1 - 2*y1*y2 + y2*y2;
  //  float b = 2*x1*x2 - 2*x2*x2 + 2*y1*y2 - 2*y2*y2;
  //  float c = x2*x2 + y2*y2 - s;
    
  //  float d = b*b - 4*a*c;
  //  if (d<0) return false;
    
  //  float t1 = (float)( (-b - Math.sqrt(d)) / (2*a) );
  //  float t2 = (float)( (-b + Math.sqrt(d)) / (2*a) );
    
  //  if(0<=t1 && t1<=1) return true;
  //  if(0<=t2 && t2<=1) return true;
    
  //  return false;    
  //}
   
   
  boolean IsInRectangle(float x, float y, float rx, float ry, float rl, float rw){
    if(x > rx && x < rx+rl && y > ry && y < ry + rw){
      return true;
    }
    return false;
  }
  
  
  
  
  
  
  
  int[][] GetConnectionMatrix(){
    int[][] mtrx = new int[agents.size()][agents.size()];
    
    for (int i = 0; i < agents.size(); i++) {
      for (int j = 0; j < agents.size(); j++) {
        mtrx[i][j] = elasticity.matrix[i][j];
      }
    }
    return mtrx;
  }
  
  void PrintMatrix(int[][] m){
    for (int i = 0; i < agents.size(); i++) {
      for (int j = 0; j < agents.size(); j++) {
        print(m[i][j],"  ");
      }
      println();
    }
    println();
  }
  
  
  void ShowFloaters(ArrayList<Floater> fs){
     //println("size = ", net.size());
     for (int i = 0; i < fs.size(); i++) {
       print(fs.get(i).number, " ");
     }
  }
  
  
  
  
  
  //spawn a floater
  //void mouseClicked()  {
  // if(mouseButton == RIGHT){
  //   floaters.add(new Floater(flocking.floater_vr, s, mouseX-s/2, mouseY-s/2));
  // }
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
   

   
   
   
   
  
  
  
  
  
  