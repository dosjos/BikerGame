


public class Player {
  PImage playerImage;
  PImage lifeImage;
  boolean goLeft, goRight;
  int x, y;
  int life;
  int w, h;
  
  double score;
  
  private boolean jump = false;
  private int jumpdir = 1;   
  private int jumpScale = 1;
  public Player() {
    playerImage = loadImage("Images/Character.png");
    lifeImage = loadImage("Images/Helmet.png");
    x = 740  - (playerImage.width);

    y = 700 - (int)(playerImage.height);

    w = playerImage.width;
    h = playerImage.height;

    life = 3;
    
    
  }

  public void draw() {
    
    int dist = 2 * (scrollSpeed/2);
    if(!jump){
      if (goRight) {
       
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
      }
    }
    if (jump) {
      image(playerImage, x, y, (playerImage.width+jumpScale), (playerImage.height+jumpScale));
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
      image(playerImage, x, y, playerImage.width, playerImage.height);
    }
    for (int i = 1; i <= life; i++) {
      image(lifeImage, (70 * i) - 60, 20);
    }
  }

  boolean isJumping() {
    return jump;
  }

  void addScore(double a){
   score += a; 
  }

  void jump() {
    if (jump == false) {
      jump = true;       
      addScore(50.0);
    }
  }
}

