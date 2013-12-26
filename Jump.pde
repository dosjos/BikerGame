

public class Jump{
 
 PImage image;
  
  int x, y; //koordinater
  int w, h;//bredde høyde
 public Jump(int x, PImage image){
  
  this.x = x;
  this.image = image; 
  y = -100;
  
  w = image.width;
  h = image.height;
  
 } 
  
  
  
 void draw(){
   image(image, x,y);
   y += scrollSpeed;
 } 
  
  
}
