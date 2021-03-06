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
                                             4,  //elastic force      
                                             30+3,//still range        
                                             (float)Math.sqrt(width*width+height*height),  //attraction range    
                                             4,  //elastic force       
                                             7  //constraining velocity
                                             );
  
  
  //set Engin
  eng = new Engine( 0,          //number of created birds
                    3,          //number of floaters
                    15,         //size of a floater 
                    elasticity, //slastic force 
                    flocking,   //flocking force
                    0.4           //friction coefficient
                    );  
  
  //set Drawer
  drawer = new Drawer( null,        //eng.floaters,                  
                       2,           //flapping rate    
                       false,       //the frame is open  
                       true,        //connect floaters
                       this         //for Minim
                       );
  
  
  background(drawer.bg);
  frameRate(30);
  noFill(); 
  stroke(0);
  strokeWeight(1);
}




void draw() {
  background(drawer.bg);
  
  eng.IterateFrame();
  eng.IncrementFramCounters();
  
  //draw floaters
  drawer.SetFloaters(eng.agents);
  drawer.SetMatrix(eng.GetConnectionMatrix());  
  drawer.draw();
  

  
  //to test the IsInDashAreaOf() function
  // for (int i = 1; i < eng.floaters.size(); i++) {
  //  //float xx = eng.floaters.get(i-1).x + (eng.floaters.get(i).x - eng.floaters.get(i-1).x)/2 -eng.floaters.get(i-1).s*2;
  //  //float yy = eng.floaters.get(i-1).y + (eng.floaters.get(i).y - eng.floaters.get(i-1).y)/2 +eng.floaters.get(i-1).s/3;
  //  //ellipse(xx, yy, 10, 10);
  //  eng.IsOnTheLineBetween( eng.floaters.get(i-1),   eng.floaters.get(i-1),    eng.floaters.get(i) );
  // }
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








  