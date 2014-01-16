

public class Enemy{
  
  PImage img;
  Random r = new Random();
  int x,y,w,h;
  boolean dying;
  boolean diestate; //is- true smelte false smuldre
  boolean dead;
  public Enemy(PImage image){
    img = image;
    x = 220 + r.nextInt(800);
    y = -100;
    w = img.width;
    h = img.height;
  }
  
 public void draw(){
  
 } 
  
}
