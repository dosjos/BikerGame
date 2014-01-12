public class Player {
  PImage playerImage;
  PImage lifeImage;
  PImage[] images = new PImage[8];
  PImage[] boyImages = new PImage[8];
  PImage[] girlImages = new PImage[8];

  boolean goLeft, goRight, turn, safe, safedraw;
  int safeleft;
  int x, y;
  int life;
  int w, h;

  double score;

  private boolean jump = false;
  private int jumpdir = 1;   
  private int jumpScale = 1;
  private int jumpSpeeder;
  int dist = 0;

  int imageRot = 0;
  int imgAdder = 0;
  public Player() {
    //    playerImage = loadImage("Images/Character.png");
    lifeImage = loadImage("Images/Helmet.png");

    boyImages[0] = loadImage("Images/01_BoyAnim.png");
    boyImages[1] = loadImage("Images/02_BoyAnim.png");
    boyImages[2] = loadImage("Images/03_BoyAnim.png");
    boyImages[3] = loadImage("Images/04_BoyAnim.png");
    boyImages[4] = loadImage("Images/05_BoyAnim.png");
    boyImages[5] = loadImage("Images/06_BoyAnim.png");
    boyImages[6] = loadImage("Images/07_BoyAnim.png");
    boyImages[7] = loadImage("Images/08_BoyAnim.png");

    girlImages[0] = loadImage("Images/01_GirlAnim.png");
    girlImages[1] = loadImage("Images/02_GirlAnim.png");
    girlImages[2] = loadImage("Images/03_GirlAnim.png");
    girlImages[3] = loadImage("Images/04_GirlAnim.png");
    girlImages[4] = loadImage("Images/05_GirlAnim.png");
    girlImages[5] = loadImage("Images/06_GirlAnim.png");
    girlImages[6] = loadImage("Images/07_GirlAnim.png");
    girlImages[7] = loadImage("Images/08_GirlAnim.png");

    Random r = new Random();

    if (r.nextInt(50) > 25) {
      images = boyImages;
    }
    else {
      images = girlImages;
    }

    x = 740  - (images[0].width);

    y = 680 - (int)(images[0].height);

    w = images[0].width;
    h = images[0].height;

    life = 3;
  }

  public void draw() {

    //dist = 2 * (scrollSpeed/2);
    if (!jump) {
      if (turn) {
        if (scrollSpeed != 0) {

          x += dist * (scrollSpeed/4);
          if (x > 1060 - (images[0].width)) {
            x = 1060 - (images[0].width);
          }
          if (x < 220) {
            x = 220;
          }
        }
      }

     /* if (goRight) {       
        x += dist;
        if (dist == 0 && scrollSpeed > 0) {
          x+= 1;
        }
        if (x > 1060 - (playerImage.width)) {
          x = 1060 - (playerImage.width);
        }
      }
      else if (goLeft) {
        x -= dist;
        if (dist == 0 && scrollSpeed > 0) {
          x-= 1;
        }
        if (x < 220) {
          x = 220;
        }
      }*/
    }

    if (jump) {
      if (scrollSpeed > 5 && jumpSpeeder % 6 == 0) {
        speedDown();
      }
      jumpSpeeder++;
      image(images[imageRot], x, y, (images[0].width+jumpScale), (images[0].height+jumpScale));
      jumpScale += jumpdir;
      if (jumpScale == 30) {
        jumpdir = -1;
      }
      else if (jumpScale == 1) {
        jumpdir = 1;
        jump = false;
      }
    }
    else {
      imgAdder += scrollSpeed;
      if (imgAdder >= 40) {
        imageRot++;
        if (imageRot == 8) {
          imageRot = 0;
        }
        imgAdder = 0;
      }
      if(safe){
        safeleft--;
        if(safeleft % 8 == 0){
          safedraw = !safedraw;
        }
        if(safedraw){
          image(images[imageRot], x, y);
        }else{
        }
        if(safeleft <=0){
         safedraw = true;
        safe = false; 
        }
      }else{
        image(images[imageRot], x, y);
      }
    }

    for (int i = 1; i <= life; i++) {
      image(lifeImage, (70 * i) - 60, 20);
    }
  }




  boolean isJumping() {
    return jump;
  }

  void addScore(double a) {
    score += a;
  }

  void jump() {
    if (jump == false && scrollSpeed >= 4) {
      jump = true;    
      jumpSpeeder = 0;   
      addScore(50.0);
    }
  }
}

