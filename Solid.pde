

abstract class Solid{
 int x = 0, y = 0, w = 0, h = 0; 
  
  PImage image;
  public Solid(PImage image){
   this.image = image; 
  }
  
  
 abstract void draw();
  

}
