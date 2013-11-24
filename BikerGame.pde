import java.util.*;

PImage Backgrounds[] = new PImage[4] ;
PImage jumpImage;
PFont pointFont;
PFont textFont;
int BackgroundYs[] = new int[4];
ArrayList<PImage> BackgroundList = new ArrayList<PImage>();
Random r = new Random();

ArrayList<Jump> jumps = new ArrayList<Jump>();


static int scrollSpeed = 0;
int scrollCount;

int bakgroundY = 0;
int imageHeight = 720;

Player player;
Tv tv;



void setup() {

  jumpImage      = loadImage("Images/Ramp.png");
  ; 
  Backgrounds[0] = loadImage("Images/Bakgrunn_Bridge.png");
  Backgrounds[1] = loadImage("Images/Bakgrunn.png");
  Backgrounds[2] = Backgrounds[0];
  Backgrounds[3] = Backgrounds[1];

  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[0]);
  BackgroundList.add(Backgrounds[0]);

  BackgroundYs[0] = 0;
  BackgroundYs[1] = -720;
  BackgroundYs[2] = -1440;
  BackgroundYs[3] = -2160;

  pointFont = loadFont("Algerian-48.vlw");
  textFont = loadFont("Aharoni-Bold-32.vlw");

  player = new Player();
  tv = new Tv(this);
  frameRate(30);

  textFont(pointFont, 48);
  size(1280, 720, P3D);
}



void draw() {
  /** Tegning og oppdatering av bakgrunn**/
  background(0, 0, 0);
  for (int i = 0; i < Backgrounds.length; i++) {
    image(Backgrounds[i], 0, BackgroundYs[i]);
    BackgroundYs[i] += scrollSpeed;

    if (BackgroundYs[i] >= imageHeight) {
      BackgroundYs[i] -= imageHeight*3;
      Backgrounds[i] = BackgroundList.get(r.nextInt(BackgroundList.size()));
    }
  }

  /** Diverse spilltekniske skjekker, krasj, hopp, osv**/


  checkForJumps();

  /** Beregning av poeng **/
  if (scrollSpeed > 0 ) {
    scrollCount++;
  }
  if (frameCount % 10 == 0) {
    player.addScore(scrollSpeed/5.0);
  }

  /**Her kan vi spawne nye entiteter**/
  if (scrollSpeed != 0) {
    if (r.nextInt(40) == 10) {
      jumps.add(new Jump(r.nextInt(780) + 220, jumpImage));
    }
  }


  /** Gjør all tegning**/
  for (int i = 0; i < jumps.size(); i++) {
    jumps.get(i).draw();
  }

  player.draw();
  tv.draw();





  textFont(pointFont);
  text("" + (int)player.score, width - 160, 50);
  text("" + scrollSpeed, width - 160, height-50);
  textFont(textFont);
   text("km/t", width - 100, height-50);
  /** Rydder opp og sletter entiteter**/
  cleanUp();
}

/** Lytter på knapper, brukes under utvikling på pc**/
void keyReleased() {
  if (key == CODED)
  {
    if (keyCode == LEFT)
    {
      player.goLeft = false;
    }
    if (keyCode == RIGHT)
    {
      player.goRight = false;
    }
  }
}

void keyPressed()
{
  if (key == CODED)
  {
    if (keyCode == LEFT)
    {
      player.goLeft = true;
    }
    if (keyCode == RIGHT)
    {
      player.goRight = true;
    }

    if (keyCode == UP)
    {

      scrollSpeed++;
      if (scrollSpeed > 30) scrollSpeed = 30;
    }
    if (keyCode == DOWN)
    {
      scrollSpeed--;
      if (scrollSpeed < 0) scrollSpeed = 0;
    }
  }
}



void cleanUp() {
  for (int i = 0; i < jumps.size(); i++) {
    if (jumps.get(i).y > height +100) {
      jumps.remove(i);
    }
  }
}


void checkForJumps() {
  for (int i = 0; i < jumps.size(); i++) {
    Jump j = jumps.get(i);
    if (j.x +50 < player.x + player.w && j.x + j.w -50 > player.x) {
      if (j.y < player.y + player.h && j.y + j.h > player.y) {

        player.jump();
      }
    }
  }
}

