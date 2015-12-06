import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class cat extends PApplet {


 
 


Engine eng;
Drawer drawer;



  



public void setup() {
  
  //set main forces  
  Flocking     flocking = new Flocking(      30, //repulsion range
                                             4,  //repulsion force    
                                             50, //allignment range     
                                             250,//attraction range       
                                             2,  //attraction force     
                                             10 //constraining velocity      
                                             );
  
  Elasticity elasticity = new Elasticity(    30-3,//repulsion range
                                             10,  //elastic force      
                                             30+3,//still range        
                                             (float)Math.sqrt(width*width+height*height),  //attraction range    
                                             10,  //elastic force       
                                             10  //constraining velocity      
                                             );
  
  
  //set Engin
  eng = new Engine( 1,          //number of floaters
                    30,         //size of a floater 
                    elasticity, //slastic force 
                    flocking,   //flocking force
                    1           //friction coefficient
                    );  
  
  //set Drawer
  drawer = new Drawer( eng.floaters,                  
                       2,           //flapping rate    
                       false,        //the frame is open       
                       this         //for Minim
                       );
  
  
  background(drawer.bg);
  frameRate(25);
  noFill(); 
  stroke(0);
  strokeWeight(1);
}




public void draw() {
  background(drawer.bg);
  
  eng.IterateFrame(); 
  drawer.draw();
}



public void mouseDragged()  {
  eng.mouseDragged();
}


public void mouseClicked()  {
  eng.mouseClicked();
}

public void mousePressed(){
  eng.mousePressed(); 
}

public void mouseReleased(){
  eng.mouseReleased(); 
}








  





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
  
  //if true frame of the the window is open and looped
  boolean open_frame;
  


  
  
   
  
  
  
  Drawer(ArrayList<Floater> floaters, int flappingRate, boolean open_frame, java.lang.Object object){
    this.floaters = floaters;
    this.flappingRate = flappingRate;
    this.open_frame=open_frame;
    
    LoadImages();
    LoadSound(object);
  }
  
  public void LoadImages(){
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
  
  public void LoadSound(java.lang.Object object){
    //for music 
    minim = new Minim(object);
    player = minim.loadFile("bm.mp3", 2048);
    player.loop();
  }
  
  
 
  
  public void draw() {
    ConnectFloaters();
    
    //draw each floater
    for (int i = 0; i < floaters.size(); i++) {
      //Drawbird(floaters.get(i));
      Drawboid(floaters.get(i));
    }
  }
  
  //changes boundary values of coordinates of floaters depending on the type of the frame(open-looped or closed) 
  public void FrameType(Floater f){
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
  
  //connects consequent floaters with lines
  public void ConnectFloaters(){
    fill(0);
    strokeWeight(2); 
    for (int i = 1; i < floaters.size(); i++) {
      line(floaters.get(i-1).x+floaters.get(i-1).s/2, floaters.get(i-1).y+floaters.get(i-1).s/2, floaters.get(i).x+floaters.get(i).s/2, floaters.get(i).y+floaters.get(i).s/2);
    }
  }
  
  



  public void Drawbird(Floater f) {
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
   
   //do direct the bird in a fkying direction
   public float DirectionAngle(Floater f){
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
   
   
   
   public void Drawboid(Floaterk f) {
      FrameType(f);
      
      pushMatrix();
      translate(f.x + f.s/2, f.y + f.s/2);
      strokeWeight(2); 
      fill(255);
      ellipseMode(CENTER); 
      ellipse(0, 0, f.s/2, f.s/2);
      //
      //line(-f.head.x*20, -f.head.y*20, f.head.x*20, f.head.y*20);
      //ellipseMode(CENTER); 
      //ellipse(f.head.x*20, f.head.y*20, 10, 10);
      //ellipseMode(CENTER); 
      //ellipse(-f.head.x*20, -f.head.y*20, 10, 10);
      //     
      popMatrix();
   }
   
   
   
   
  
  
  
   
  
  
} 
  
class Elasticity extends Force {
  
 
  Elasticity(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
  }
  
  
  
  
  
  
  public void Apply(){
    for (int i = 1; i < floaters.size(); i++) {
      Interract(floaters.get(i-1), floaters.get(i));
      Interract(floaters.get(floaters.size()-i), floaters.get(floaters.size()-i-1));
    }
  }
 
 
}   
   

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
  
  
  
  
  public void IterateFrame(){
    DetermineVelocities();
    for (int i = 0; i < floaters.size(); i++) {
      Move(floaters.get(i));
    }
  }
  
  
  
  
  
  public void Move(Floater f) {
    if(Allow(f)){
      f.x += f.vx * friction;
      f.y += f.vy * friction;
    }
  }
  
  //does not allow floaters to move to close
  public boolean Allow(Floater f){
   for (int i = 0; i < floaters.size(); i++) {
     if((f != floaters.get(i))&&(dist(f.x+f.vx, f.y+f.vy, floaters.get(i).x, floaters.get(i).y) < eps)){
       return false;                
     }
   }
   return true;
  }
  
  
  
  
  
  public void DetermineVelocities(){
    //flocking.Apply();    
    elasticity.Apply();
  }
  
 

 
 
 
  
 
  
  
  
  
  //spawn a floater
  public void mouseClicked()  {
    if(mouseButton == RIGHT){
      floaters.add(new Floater(flocking.floater_vr, s, mouseX-s/2, mouseY-s/2));
    }
  }
  
 //drag a seazed pbk-th floater 
 public void mouseDragged()  {
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
  public void mousePressed()  {
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
  public void mouseReleased()  {
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
   

   
   
   
   
  
  
  
  
  
  

class Floater {
  
  // location
  float x; 
  float y;
  
  //velocities
  float vx; 
  float vy;
  
  // size
  float s;
  
  //direction in which points a bitd's head on the picture
  PVector head= new PVector(-1, -1);
  //do not allow add velocity if true
  boolean still=false; 
  
  //for flapping 
  int frameCounteri;
  int frameCounter;
  
  
  Floater(float floater_vr, float s) {
    //initialize random positions and random velocities
    x = (int)random(100, width-100);
    y = (int)random(100, height-100);
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
    
    frameCounteri = (int)random(3.999f);
    frameCounter = 0;
  }
  
  Floater(float floater_vr, float s, float x, float y) {
    this.x = x;
    this.y = y;
    vx = random(-floater_vr, floater_vr);
    vy = random(-floater_vr, floater_vr);
    this.s=s;
  }
  
  
}  
  
  
  
  

class Flocking extends Force {
  
  Flocking(float rr, float fr, float rs, float ra, float fa, float fvr){
    super(rr, fr, rs, ra, fa, fvr);
  }
  
  
  
  
  
  public void Apply(){
    for (int j = 0; j < floaters.size(); j++) {
      //determine relative velocities
      for (int i = 0; i < floaters.size(); i++) {
        if (i!=j){//doesn't consider itself
          float d = dist(floaters.get(i).x, floaters.get(i).y, floaters.get(j).x, floaters.get(j).y);
          //allignment
          if(r_repulsion <=d && d <= r_still){
            floaters.get(j).vx = (floaters.get(j).vx + floaters.get(i).vx)/2;    
            floaters.get(j).vy = (floaters.get(j).vy + floaters.get(i).vy)/2;
          }
          //repulsion or attraction
          else{
            Interract(floaters.get(j), floaters.get(i));
          }
        }
      }
    }
  }
 

 
 
}   
   

   
   
   
   
  
  
  
  
  
  

class Force {
  
  
  //array of floaters
  ArrayList<Floater> floaters;
  public void SetFloaters(ArrayList<Floater> floaters){
    this.floaters=floaters;
  }
  
  
  
  
  //independent movement's laws
  float r_repulsion=30;//repulsion range
  float f_repulsion=4;//repulsion force
  float r_still=50;//allignment range
  float r_attraction= 250;//attraction range
  float f_attraction=2;//attraction force
  //public float bird_sigh1=250 ;
  
  // constraining the range(and velocitfloaters[j].y range) at which birds can move at a time
  float floater_vr=10;
  
  
  
  
  
  Force(float rr, float fr, float rs, float ra, float fa, float fvr){
    //independent movement's laws
    r_repulsion=rr;
    f_repulsion=fr;
    r_still=rs;
    r_attraction= ra;
    f_attraction=fa;
    
    
    floater_vr=fvr;
 }
  
  
  
  
  
   //virtuall   
   public void Apply(){}
  



  
  //interaction with each other
  public void Interract(Floater fj, Floater fi){
     //velocity change
     float df = dist(fi.x, fi.y, fj.x, fj.y);
     float dvx = ((fi.x-fj.x)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction); 
     float dvy = ((fi.y-fj.y)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction);
     
     AddVelocity(fj, dvx, dvy);
  }
  
  //outer influence (with a mouse currently 02.12.15)
  public void Interract(Floater fj, float x, float y){
     //velocity change
     float df = dist(x, y, fj.x, fj.y);
     float dvx = ((x-fj.x)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction); 
     float dvy = ((y-fj.y)/df) * RelativeForce(df, r_repulsion, f_repulsion, r_still, r_attraction, f_attraction);

     AddVelocity(fj, dvx, dvy);
  }
  
  //if the velocity is too large normilize it
  public void AddVelocity(Floater f, float vx, float vy){
    //new velocity
     float newvx = f.vx + vx;
     float newvy = f.vy + vy;
     
     //if the new velocity exceeds allowed limits normilize it to the maximum  allowed speed
     float dnewv  = (float)Math.sqrt(newvx*newvx + newvy*newvy);
     if(dnewv > floater_vr)
     {
       newvx /= dnewv/floater_vr;
       
       newvy /= dnewv/floater_vr;
     }
     
     if(!f.still){
       f.vx=newvx;
       f.vy=newvy;
     }
  }
  
  //Force depending on the relative distance d between birds and force parameters such as repulsion force p.floater_crf and attraction force p.floater_caf
  public float RelativeForce(float d, float fcr, float frf, float fcal, float fca, float faf){// d in [0, floater_cr] DForce in [p.floater_crf, 0]; d in  (floater_cr, floater_ca] DForce in (0, p.floater_caf];  
    if(d<=fcr){
      return -frf *(-d/fcr + 1); //thr smaller the distance d the stronger the repulsion
    }
    else
    if( d <= fcal){
      return 0;
    }
    else
    if(d <= fca){
      return (float)(   faf * ( (d-fcal)/(fca - fcal) )    );//the bigger the distance d the stronger the repulsion
    }
    return 0;
  }
 
  
  
  
  
  
  
  
  

 
 
 
}   
   

   
   
   
   
  
  
  
  
  
  
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "cat" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
