import ddf.minim.*;
 
 
 float w=640;
 float h=480;
 




Params parameters;
Engine eng;
Drawer drawer;





void setup() {
  size(640, 480);
  //set forces  
  //                               Force(float rr, float fr, float rs, float ra, float fa, float fvr);
  Flocking     flocking = new Flocking(        30,        4,       50,      250,        2,        10);
  //                             Force(float rr, float fr, float rs, float ra,                                     float fa, float fvr);
  Elasticity elasticity = new Elasticity(  30-3,       10,     30+3,       (float)Math.sqrt(width*width+height*height),  10,        10);
  
  
  //set main Engin
  //Engine(        int number_of_birds, float size, Elasticity, Flocking){...}
  eng = new Engine(1,                   30,         elasticity, flocking);
  
  //set Drawer
  //Drawer(           ArrayList<Floater> floaters, int flappingRate, boolean open_frame, java.lang.Object object){
  drawer = new Drawer(eng.floaters,                 2,               false,              this); 
  
  
  background(drawer.bg);
  frameRate(25);
  noFill(); 
  stroke(0);
  strokeWeight(1);
}




void draw() {
  background(drawer.bg);
  
  eng.IterateFrame(); 
  drawer.draw();
}



void mouseDragged()  {
  eng.mouseDragged();
}


void mouseClicked()  {
  eng.mouseClicked();
}

void mousePressed(){
  eng.mousePressed(); 
}

void mouseReleased(){
  eng.mouseReleased(); 
}








  