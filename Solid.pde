class Solid{
 int x = 0, y = 0, w = 0, h = 0; 
  Random r = new Random();
  public PImage image;
  boolean isBush;
  boolean isBurning;
  int burnimage = 0;
  int burnimageChange;
  public Solid(PImage image){//Utvides til å ta imot x posisjon
   this.image = image; 
   w = image.width;
   h = image.height;
   y = -50;
   x = 220 + r.nextInt(800 - w);
}
  
 void draw(){
    y+=scrollSpeed;
    if(isBush && isBurning && burnimage < 10){
      burnimageChange++;
      if(burnimageChange == 5){
       burnimageChange = 0; 
      burnimage++; 
     image = burningBush[burnimage] ;
    }
      
    }
    image(image, x,y);
 }
}
