import ddf.minim.*;




class Drawer{
    
  
  int[][] matrix;
  void SetMatrix(int[][] matrix){
    this.matrix=matrix;
  }
  
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  void SetFloaters(ArrayList<Floater> floaters){
    this.floaters=floaters;
  }
  
  int flappingRate;
  
  //background image
  PImage bg;
  
  //bird frames
  PImage[] frms;
  
  //background music
  AudioPlayer player;
  Minim minim;//audio context
  
  //if true frame of the the window is open and looped
  boolean open_frame;
  
  float sensitivity = 0; 
  void SetSensitivity(float sens){
    this.sensitivity = sens;
  }

  
  
   
  
  
  
  Drawer(ArrayList<Floater> floaters, int flappingRate, boolean open_frame, java.lang.Object object){
    this.floaters = floaters;
    this.flappingRate = flappingRate;
    this.open_frame=open_frame;
    
    
    LoadImages();
    LoadSound(object);
  }
  
  void LoadImages(){
    //background
    bg = loadImage("bg1.jpg");
    bg.resize(width, height);
    
    
    //flapping birds
    frms = new PImage[4];
    frms[0] = loadImage("f1.png");
    frms[1] = loadImage("f2.png");
    frms[2] = loadImage("f3.png");
    frms[3] = loadImage("f4.png");
  }
  
  void LoadSound(java.lang.Object object){
    //for music 
    minim = new Minim(object);
    player = minim.loadFile("bm.mp3", 2048);
    player.loop();
  }
  
  
 
  
  void draw() {
    //draw each floater
    for (Floater f:floaters) {
      //if(f.isabird) Drawbird(f);
      //else Drawboid(f);
      Drawboid(f);
      //Drawbird(f);
    }
  }
  
  //changes boundary values of coordinates of floaters depending on the type of the frame(open-looped or closed) 
  void FrameType(Floater f){
    //if(open_frame){
    if(f.isabird){
      //to make a looping border of the frame
      if(f.x<=-f.s/2)     f.x = width-1;
      if(f.x>=width+f.s/2) f.x = 0;
      if(f.y<=-f.s/2)     f.y = height-1;
      if(f.y>=height+f.s/2)f.y = 0;
    }
    else{
      //to make a closed border of the frame(with effect of bouncing)
      if(f.x<=0)       f.vx *= -1;
      if(f.x>=width-f.s) f.vx *= -1;
      if(f.y<=0)       f.vy *= -1;
      if(f.y>=height-f.s)f.vy *= -1;
    }
  }
  
  //connects consequent floaters with lines
  //connects consequent floaters with lines
  void Connect(){
    fill(0);
    strokeWeight(2); 
    for (int i = 0; i < floaters.size(); i++) {
      for (int j = i; j < floaters.size(); j++) {
        if(matrix[i][j] > 0){
          //strokeWeight((int)(matrix[i][j]/3 )+1);
          line(floaters.get(i).x, floaters.get(i).y, floaters.get(j).x, floaters.get(j).y);
         }
      }
    }
  }
  
  



  void Drawbird(Floater f) {
    FrameType(f);
    
    //rotate
    pushMatrix();
    translate(f.x + f.s/2, f.y + f.s/2);
    rotate(DirectionAngle(f));
    image(frms[f.frameCounteri], -f.s/2, -f.s/2, f.s, f.s);
    popMatrix();
    
    f.frameCounter++;
    if (f.frameCounter > flappingRate) {
     f.frameCounter=0;
     f.frameCounteri++;
    }
  
    if (f.frameCounteri >= 3) f.frameCounteri = 0;
   }
   
   //to direct the bird in a flying direction
   float DirectionAngle(Floater f){
     //find out the cos between the head vector of a bird and its velocity vector
     float cos = (float)((f.head.x*f.vx + f.vy*f.head.y) / (Math.sqrt((f.vx*f.vx + f.vy*f.vy)) * Math.sqrt((f.head.x*f.head.x + f.head.y*f.head.y))));
     
     //a1 = cos;
     //if (a1 != a0){
     //  println("cos=", a1);
     //  a0=a1;
     //}
     
     //check if the end point of the velocity vector is to the left or to the right from the head vector of the bird
     //float x = f.x + f.vx;
     //float y = f.y + f.vy;
     //float vpoint = y - x*f.head.y/f.head.x + f.x*f.head.y/f.head.x - f.y;
     
     //(simplified check) the location of the bird doesn't matter for the relative position of its head and velocity vectors
     float x = f.vx;
     float y = f.vy;
     float vpoint = y - x*f.head.y/f.head.x;
     
     if(vpoint >= 0) return -acos(cos);
     else return acos(cos);
   }
   
   
   
   void Drawboid(Floater f) {
      FrameType(f);
      
      pushMatrix();
      translate(f.x, f.y);
      strokeWeight(2);
      if(f.isabird) fill(255);
      else fill(0);
      //fill(255);
      ellipseMode(CENTER); 
      ellipse(0, 0, f.s, f.s);
      //draw its velocity vector
      line(0, 0, f.vx, f.vy);
      ellipseMode(CENTER); 
      ellipse(f.vx, f.vy, f.s/4, f.s/4);
      //draw a floaters number      
      PFont pf = createFont("Arial",f.s,true);
      textFont(pf,f.s);
      //text(f.number, -f.s/2, -f.s/2);
      //
      //line(-f.head.x*20, -f.head.y*20, f.head.x*20, f.head.y*20);
      //ellipseMode(CENTER); 
      //ellipse(f.head.x*20, f.head.y*20, 10, 10);
      //ellipseMode(CENTER); 
      //ellipse(-f.head.x*20, -f.head.y*20, 10, 10);
      //     
      popMatrix();
   }
   
   
   // void Drawduck(Floater f) {
   //   FrameType(f);
      
   //   pushMatrix();
   //   translate(f.x, f.y);
   //   strokeWeight(2);
   //   fill(255);
   //   ellipseMode(CENTER); 
   //   ellipse(0, 0, f.s, f.s);
   //   //draw its velocity vector
   //   line(0, 0, f.vx, f.vy);
   //   ellipseMode(CENTER); 
   //   ellipse(f.vx, f.vy, f.s/4, f.s/4);
   //   //draw a floaters number      
   //   PFont pf = createFont("Arial",f.s,true);
   //   textFont(pf,f.s);
   //   //text(f.number, -f.s/2, -f.s/2);
   //   //
   //   //line(-f.head.x*20, -f.head.y*20, f.head.x*20, f.head.y*20);
   //   //ellipseMode(CENTER); 
   //   //ellipse(f.head.x*20, f.head.y*20, 10, 10);
   //   //ellipseMode(CENTER); 
   //   //ellipse(-f.head.x*20, -f.head.y*20, 10, 10);
   //   //     
   //   popMatrix();
   //}
   
   //void Draebullet(Bullet b){
     
   //}
   
  
  
  
   
  
  
} 
  