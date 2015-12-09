
class Engine {
  
  
  
  
    
  //array of agents: birds and floaters altogether
  ArrayList<Floater> agents = new ArrayList<Floater>();
  
  
  //array of floaters
  ArrayList<Floater> birds = new ArrayList<Floater>();
  
    
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
  
  //force of interaction between floaters and birds
  Force force;
  
  
  
 
 
  
    
  
  
  
  
  Engine(int m, int n, float s, Elasticity elst, Flocking flk, float frct){
    this.s=s;
    this.friction=frct;
    
    //this.elasticity=elst;
    this.elasticity=null;
    this.flocking=flk;
    
    
    
    //create initial floater
    for (int i = 0; i < n; i++) {
      floaters.add(new Floater(flocking.floater_vr, s));
    }
    
    //creating birds
    for (int i = 0; i < m; i++) {
      birds.add(new Floater(flocking.floater_vr, s));
    }
    
    //create agents
    agents = new ArrayList<Floater>();
    agents.addAll(birds);
    agents.addAll(floaters);
    
    
    //elasticity.SetFloaters(floaters);
    //elasticity.CreateMatrix();
        
    flocking.SetFloaters(birds);
    flocking.CreateMatrix();
        
    force = new Force(elst);
    force.SetFloaters(agents);
    force.CreateMatrix();
    //force.CreateMatrixZeros();
    
    
    //for (int i = 0; i < floaters.size(); i++) {
    //  for (int j = 0; j < floaters.size(); j++) {
    //    print(elasticity.matrix[i][j], "  ");
    //  }
    //  println();
    //}
 }
  
  
  
  // boolean justfortest=true;
  void IterateFrame(){
    //collide
    for (int i = 0; i < agents.size(); i++) {
      for (int j = 0; j < agents.size(); j++) {
        if( i!=j && dist(agents.get(i).x, agents.get(i).y, agents.get(j).x, agents.get(j).y) < (agents.get(i).s + agents.get(j).s)/2 ){//eps)){
          Collide(agents.get(i), agents.get(j));
        }
      }
    }
    
    
    DetermineVelocities();
    
    for (int i = 0; i < floaters.size(); i++) {
      Move(floaters.get(i));
    }
    
    for (int i = 0; i < birds.size(); i++) {
      Move(birds.get(i));
    }


    
    //ThrowOut();
    //PlugIn();
    //for(Floater f:floaters){print("x=",(int)f.x," y=", (int)f.y, " | ");}
    //println();

    // if(justfortest){
    //   ArrayList<Floater> ints = new ArrayList<Floater>();
    // ints.add(new Floater(10, 1));
    // ints.add(new Floater(10, 3));
    // ints.add(1, new Floater(10, 2));
    //   ints.remove(0);
    //   ints.add(0, ints.get(1));
    //   for(Floater f:ints){print(f.s, " ");}
    //   println();
    //   ints.get(0).s -= 3;
    //   for(Floater f:ints){print(f.s, " ");}
    //   justfortest = false;

    // }
  }



  int[][] GetConnectionMatrix(){
    int[][] mtrx = new int[agents.size()][agents.size()];
    
    for (int i = 0; i < agents.size(); i++) {
      for (int j = 0; j < agents.size(); j++) {
        if(birds.size()<=i && birds.size()<=j && Math.abs(i-j)==1) mtrx[i][j] = force.matrix[i][j];//1;
        else mtrx[i][j] = force.matrix[i][j];
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
  
  
  
  
  void Move(Floater f) {
    //if(Allow(f)){
      f.x += f.vx * friction;
      f.y += f.vy * friction;
    //}
  }
  
  //does not allow floaters to move to close
  boolean Allow(Floater f){
   for (int i = 0; i < floaters.size(); i++) {
     if((f != floaters.get(i))&&(dist(f.x+f.vx, f.y+f.vy, floaters.get(i).x, floaters.get(i).y) < f.s)){//eps)){
       return false;                
     }
   }
   return true;
  }
  
  void Collide(Floater f1, Floater f2){
    //float teta1 = atan(Math.abs(f1.vy/f1.vx));
    //float teta2 = atan(Math.abs(f2.vy/f2.vx));
    float v1 = (float)Math.sqrt(f1.vx*f1.vx + f1.vy*f1.vy);
    float v2 = (float)Math.sqrt(f2.vx*f2.vx + f2.vy*f2.vy);
    float av = (v1+v2)/2;
    
    float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
    float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
    
    
    
    force.AddVelocity(f1, ndy*av, ndx*av); 
  } 
  
  
  
  
  
  
  
  
  void DetermineVelocities(){
    for (int i = 0; i < agents.size(); i++) {
      //ThrowOut(i);
      //PlugIn(i);
    }
    // println("+++++++++++++++++++++++++++++++++");
    // PrintMatrix(GetConnectionMatrix());
    // RenewChainConnection();
    // PrintMatrix(GetConnectionMatrix());
    // println("+++++++++++++++++++++++++++++++++");

    
    
    //flocking.Apply(); //for birds    
    /////////////////elasticity.Apply();//for floaters//included in force now!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    force.Apply();
  }

  //void RenewChainConnection(){
  //  for (int i = birds.size()+1; i < agents.size(); i++) {
  //    force.matrix[i-1][i]=1;
  //    force.matrix[i][i-1]=1;
  //  }
  //}
  
  
 
 
 //go through all the edges of the representative graph and 
 //plug the floater if it is "positioned" on line segment between a pair of floaters representing an edge in the representative graph
 void PlugIn(int k){
   //println("start PlugIn");
   //for ( Integer[] edge:GetEdges() ) {println("edge[",edge[0],", ", edge[1], "]"); }
   for ( Integer[] edge:GetEdges() ) {
     //println("floater ", k," is on edge[",edge[0],", ", edge[1],"]: ", ( k!=edge[0] && k!=edge[1] && IsOnTheLineBetween(agents.get(k), agents.get(edge[0]), agents.get(edge[1])) ));
     if( k!=edge[0] && k!=edge[1] && IsOnTheLineBetween(agents.get(k), agents.get(edge[0]), agents.get(edge[1])) ){
       println("floater ", k," is on edge[",edge[0],", ", edge[1],"]: ", ( k!=edge[0] && k!=edge[1] && IsOnTheLineBetween(agents.get(k), agents.get(edge[0]), agents.get(edge[1])) ));
       //remove edge [edge[0]] [edge[1]]
       PrintMatrix(GetConnectionMatrix());
       force.matrix [edge[0]] [edge[1]] = 0;
       force.matrix [edge[1]] [edge[0]] = 0;
       //add edge [edge[0]] [k] and [edge[1]] [k]
       force.matrix [edge[0]] [k]       = 1;
       force.matrix [k]       [edge[0]] = 1;
       force.matrix [edge[1]] [k]       = 1;
       force.matrix [k]       [edge[1]] = 1;
       //println("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadd");
       PrintMatrix(GetConnectionMatrix());
     }
   }
 }

 ArrayList<Integer[]> GetEdges(){
   ArrayList<Integer[]> edges = new ArrayList<Integer[]>();
   for (int i = 0; i < agents.size(); i++) {
      for (int j = i; j < agents.size(); j++) {
        if(force.matrix[i][j] == 1) edges.add( new Integer[]{i, j} );
      }
    } 
    return edges;
 }

 //get all incident floaters to the given floater and 
 //check if it is "positioned" on the line segment between any two of its incident floaters 
 void ThrowOut(int k){
   ArrayList<Integer> incdc = GetIncidentFloaters(k);  
   for (int i = 0; i < incdc.size(); i++) {
      for (int j = 0; j < incdc.size(); j++) {
        if( IsOnTheLineBetween(agents.get(k), agents.get(incdc.get(i)), agents.get(incdc.get(j))) ){
          //floater k is no more incident to incdc[i] and floater ncdc[i] is no more incident to k
          force.matrix [k]            [incdc.get(i)] = 0;
          force.matrix [incdc.get(i)] [k]            = 0;
          //floater k is no more incident to incdc[j] and floater ncdc[j] is no more incident to k      
          force.matrix [k]            [incdc.get(j)] = 0;
          force.matrix [incdc.get(j)] [k]            = 0;
          //floater [incdc[i]] is incident to [incdc[j]] and floater [incdc[j]] is incident to [incdc[i]]
          force.matrix [incdc.get(i)] [incdc.get(j)] = 1;      
          force.matrix [incdc.get(j)] [incdc.get(i)] = 1;      
       }
     }
   }
 }

 ArrayList<Integer> GetIncidentFloaters(int k){
   ArrayList<Integer> incdc = new ArrayList<Integer> ();
   for (int j = 0; j < agents.size(); j++) {
        if(force.matrix[k][j] == 1) incdc.add(j);
   } 
    return incdc;
 }


 


  boolean IsOnTheLineBetween(Floater f, Floater f1, Floater f2){
     float ndx = (float)((f1.x - f2.x)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y))); 
     float ndy = (float)((f1.y - f2.y)/Math.sqrt((f1.x - f2.x)*(f1.x - f2.x) + (f1.y - f2.y)*(f1.y - f2.y)));
    
      float x1 = f1.x - ndx*f1.s;
      float x2 = f2.x + ndx*f2.s;
      float x3 = f.x;
      float x4 = f.x + f.vx;
      
      float y1 = f1.y - ndx*f1.s;
      float y2 = f2.y + ndx*f2.s;
      float y3 = f.y;
      float y4 = f.y + f.vy;
      
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
  
 //boolean IsOnTheLineBetween(Floater f, Floater f1, Floater f2){
 //     float eps=f.s/8;
 //     float xx = f.x;
 //     float yy = f.y;
      
 //     float x = f2.x - f1.x;
 //     float y = f2.y - f1.y;
 //     float angle;
 //     float cos = (float)( x / Math.sqrt(x*x + y*y) );
         
 //     //println("y=",y, " acs=", acos(cos));
 //     if(y >= 0) angle= acos(cos);
 //     else angle = -acos(cos);
      
 //     pushMatrix();
      
 //     translate(f1.x, f1.y);
 //     xx-=f1.x;
 //     yy-=f1.y;
      
      
 //     rotate(angle);
 //     xx = (float)( xx*Math.cos(angle) - yy*Math.sin(angle) );
 //     yy = (float)( xx*Math.sin(angle) + yy*Math.cos(angle) );
 //     float cosphi=(float)(xx/Math.sqrt(xx*xx + yy*yy));
 //     float sinphi=(float)(yy/Math.sqrt(xx*xx + yy*yy));
 //     xx = ( xx/cosphi)*(float)Math.cos((acos(cosphi)-acos(cos)));
 //     yy = ( yy/sinphi)*(float)Math.sin((acos(cosphi)-acos(cos)));
      
      
 //     translate(f1.s/2, -eps);
 //     xx-=f1.s/2;
 //     yy-=-eps;
 //     //
 //     //strokeWeight(2); 
 //     //fill(255);
 //     //rect(0, 0, dist(f1.x, f1.y, f2.x, f2.y)-f1.s, 2*eps);
 //     //ellipseMode(CENTER);
 //     //ellipse(xx, yy, 10, 10);
 //     //
 //     //println(IsInRectangle(xx, yy, 0, 0, dist(f1.x, f1.y, f2.x, f2.y)-f1.s/2, f1.s));
 //     boolean res = IsInRectangle(xx, yy, 0, 0, dist(f1.x, f1.y, f2.x, f2.y)-f1.s/2, 2*eps);
      
 //     popMatrix();
 //     return res;
 // }




  
   
   
 boolean IsInRectangle(float x, float y, float rx, float ry, float rl, float rw){
    if(x >= rx && x <= rx+rl && y >= ry && y <= ry + rw){
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
         force.AddVelocity(floaters.get(pbk), mouseX-pmouseX,  mouseY-pmouseY);
         //make a floater movable again
         floaters.get(pbk).still = false;
         pbk=-1;
      }
    }
    
  }

 
 
 
}   
   

   
   
   
   
  
  
  
  
  
  