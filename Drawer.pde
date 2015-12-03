import ddf.minim.*;




class Drawer{
    
  
  //array of floaters
  ArrayList<Floater> floaters = new ArrayList<Floater>();
  
  int flappingRate;
  
  //background image
  PImage bg;
  
  //bird frames
  PImage[] frms;
  
  //background music
  AudioPlayer player;
  Minim minim;//audio context
  
  boolean open_frame;
  


  
  
   
  
  
  
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
    //draw floaters
    //connect consequent floaters  
    ConnectFloaters();
    
    //draw each floater
    for (int i = 0; i < floaters.size(); i++) {
     //Drawbird(floaters.get(i));
     Drawboid(floaters.get(i));
    }
  }
  
  void Frame(Floater f){
    if(open_frame){
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
  
  void ConnectFloaters(){//connects consequent floaters with lines
    fill(0);
    strokeWeight(2); 
    for (int i = 1; i < floaters.size(); i++) {
      line(floaters.get(i-1).x+floaters.get(i-1).s/2, floaters.get(i-1).y+floaters.get(i-1).s/2, floaters.get(i).x+floaters.get(i).s/2, floaters.get(i).y+floaters.get(i).s/2);
    }
  }
  
  



  void Drawbird(Floater f) {
    Frame(f);
    //draw a flapping bird
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
   
   
   
   
   void Drawboid(Floater f) {
      Frame(f);
      //draw a boid with velocity vector
      //rotate
      pushMatrix();
      translate(f.x + f.s/2, f.y + f.s/2);
      
      strokeWeight(2); 
      //line(0, 0, f.vx*10, f.vy*10);
      ellipseMode(CENTER); 
      fill(0);
      //ellipse(f.vx*10, f.vy*10, 6, 6);
      
      fill(255);
      ellipseMode(CENTER); 
      ellipse(0, 0, f.s/2, f.s/2);
      //line(-f.head.x*20, -f.head.y*20, f.head.x*20, f.head.y*20);
      //ellipseMode(CENTER); 
      //ellipse(f.head.x*20, f.head.y*20, 10, 10);
      //ellipseMode(CENTER); 
      //ellipse(-f.head.x*20, -f.head.y*20, 10, 10);
      
      popMatrix();
   }
   
   
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
   
  
  
  
   
  
  
} 
  