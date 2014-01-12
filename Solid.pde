class Solid{
 int x = 0, y = 0, w = 0, h = 0; 
  Random r = new Random();
  PImage image;
  public Solid(PImage image){//Utvides til å ta imot x posisjon
   this.image = image; 
   w = image.width;
   h = image.height;
   y = -50;
   x = 220 + r.nextInt(800 - w);
}
  
 void draw(){
    y+=scrollSpeed;
    image(image, x,y);
 }
}
