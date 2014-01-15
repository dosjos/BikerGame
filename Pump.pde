public class Pump{
 PImage img;
 int x, y, h, w;
  public Pump(PImage image){
  img = image;
  w = image.width;
  h = image.height;
  y = - 100;
  x = 220 + r.nextInt(1060);
 }

  public void draw(){
   y+=scrollSpeed;
   image(img,x,y);
  } 
  
}
