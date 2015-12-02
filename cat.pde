/*
Lord of the flies
 Motion Detection from webcamera for interactive art
 
 Licensed under Creative Commons 2.0. https://creativecommons.org/licenses/by-sa/2.0/ca/
 Free to resuse as is or with modification in any non-commercial content.
 You must give appropriate credit, provide a link to the license  and indicate if changes were made. 
 
 Author: Marta Kryven
 Required libraries: Video for Processing
 */
 
 
 float w=640;
 float h=480;
 

import ddf.minim.*;

//background music
AudioPlayer player;
Minim minim;//audio context
 


//background picture
PImage bg;
PImage[] frms = new PImage[4];


Params p = new Params();

//Engine(int n, float s, int flappingRate,Params p, float w, float h, PImage[] frms){...}
Engine eng = new Engine(1, 50, 2, p, w, h, frms);



void setup() {
  //for music 
  minim = new Minim(this);
  player = minim.loadFile("bm.mp3", 2048);
  player.loop();
  
  //background
  bg = loadImage("bg1.jpg");
  bg.resize((int)w, (int)h);
  
  //flapping birds
  frms[0] = loadImage("f1.png");
  frms[1] = loadImage("f2.png");
  frms[2] = loadImage("f3.png");
  frms[3] = loadImage("f4.png");

  size(640, 480);
  background(bg);
  frameRate(25);
  noFill(); 
  stroke(0);
  strokeWeight(1);
}


//float i=0.0;

void draw() {
  background(bg);
  
   
   //pushMatrix();
   //translate(width/2, height/2);
   //rotate(i);
   //image(frms[0], -35, -35, 70, 70);
   //popMatrix();
   //i+=0.3;
   
   
   eng.draw();
   
}

//void draw() {
//  background(51);

//  // during even-numbered seconds (0, 2, 4, 6...)
  
//  translate(width/2, height/2);
//  rotate(PI/4);
//  rect(0, 0, 180, 180);   
//}






void mouseDragged()  {
  eng.mouseDragged();
}

void mouseClicked()  {
  eng.mouseClicked();
}







// ----------------------------------------------------------------



  