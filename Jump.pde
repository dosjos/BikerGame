

public class Jump{
 
 PImage image;
  
  int x, y;
  int w, h;
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
