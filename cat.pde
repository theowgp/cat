import ddf.minim.*;
 
 


Engine eng;
Drawer drawer;



  



void setup() {
  size(640, 480);
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








  