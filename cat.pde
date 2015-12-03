import ddf.minim.*;
 
 
 float w=640;
 float h=480;
 




Params parameters;
Engine eng;
Drawer drawer;





void setup() {
  size(640, 480);
  
  //set parameters
  parameters = new Params();
  
  //Engine(        int number_of_birds, float size, Params parameters){...}
  eng = new Engine(1,                   30,         parameters);
  
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








  