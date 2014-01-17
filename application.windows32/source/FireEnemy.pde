

public class FireEnemy extends Enemy{
  int fireTeller = 0;
  int imgTeller = 0;
  PImage[] eimage;
  PImage[] fimage;
  public FireEnemy(PImage[] eimage, PImage[] fimage){
   super(eimage[0]);
   this.eimage = eimage;
   this.fimage = fimage;
  }
  
  public void draw(){
    if(!dying){
      image(fimage[fireTeller], x, y);
      image(eimage[imgTeller],x, y);
    }else{
      image(happy, x,y);
    }
    y+= scrollSpeed;
    x += -6 + r.nextInt(13);
    if(y % 4 == 0){
    fireTeller++;
    imgTeller++;
    if(fireTeller == 3){
     fireTeller = 0; 
    }
    if(imgTeller == 4){
      imgTeller = 0;
    }
    }
  }
  
}
