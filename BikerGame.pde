import java.util.*;
import processing.serial.*; 

PImage Backgrounds[] = new PImage[4] ;//Inneholder bakgrunnsbilder
int BackgroundYs[] = new int[4]; //Inneholder Y posisjonen til bakgrunnene

PImage jumpImage;//Bilde av hoppet
PFont pointFont;//Fonten til poeng
PFont textFont; //Font til resten

ArrayList<PImage> BackgroundList = new ArrayList<PImage>();//Liste over alle mulige bakgrunnsbilder
Random r = new Random();

ArrayList<Jump> jumps = new ArrayList<Jump>(); //Alle hoppene


static int scrollSpeed = 0;//Hvor fort bakgrunnen scroller
int scrollCount;

int bakgroundY = 0;
int imageHeight = 720;//Høyden på en bakgrunn

Player player; //Spilleren
Tv tv;        //Tven nede til venstre

Serial myPort; 
int val; 
String input;
Fullscreen f = new Fullscreen();

void setup() {

  jumpImage      = loadImage("Images/Ramp.png");

  Backgrounds[0] = loadImage("Images/Bakgrunn_Bridge.png");
  Backgrounds[1] = loadImage("Images/Bakgrunn.png");
  Backgrounds[2] = Backgrounds[0];
  Backgrounds[3] = Backgrounds[1];

  BackgroundList.add(Backgrounds[1]);//Fyller bakgrunnslista
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[1]);
  BackgroundList.add(Backgrounds[0]);
  BackgroundList.add(Backgrounds[0]);

  BackgroundYs[0] = 0;//Setter initiell posisjon på bakgrunnene
  BackgroundYs[1] = -720;
  BackgroundYs[2] = -1440;
  BackgroundYs[3] = -2160;

  pointFont = loadFont("Algerian-48.vlw");//Laster inn fonter
  textFont = loadFont("Aharoni-Bold-32.vlw");

  player = new Player();//oppretter spilleren
  tv = new Tv(this);//oppretter tven
  frameRate(30);//Setter framerate til 30, sånn at det blir stabilt

  textFont(pointFont, 48);//Setter hovedtekstfonten
  size(1280, 720, P3D);//Setter oppløsning og grafikkmotor

  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
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


  if ( myPort.available() > 0) {
    try {
      input = myPort.readStringUntil(10);
      if (input!=null) {
        if (input.contains("x")) {
          input = input.replace("x", "");
          input = trim(input);
          int inX = Integer.parseInt(input);
          inX = map(inX, -100, 100, -10, 10);
          player.turn = true;
          player.dist = inX;
        }
      }
    }
    catch(Exception e) {
    }
  }
  /** Diverse spilltekniske skjekker, krasj, hopp, osv**/


  checkForJumps();//Sjekker om spillern skal hoppe
  //TODO legg til checker for alt, enemies, collisions, osv


  /** Beregning av poeng **/
  /*if (scrollSpeed > 0 ) {
   scrollCount++;  //Hadde ingen innvirkning, vet ikke hva den er til....
   }*/
  if (frameCount % 10 == 0) {
    player.addScore(scrollSpeed/5.0);
  }

  /**Her kan vi spawne nye entiteter**/
  if (scrollSpeed >= 3) {// Spawner kun hopp derson hastigheten er over 3
    if (r.nextInt(80) == 10) {//Spavenr kun hopp med 1/80 dels sansynelighet
      jumps.add(new Jump(r.nextInt(780) + 220, jumpImage));//x posisjonen til hoppet blir valgt random (innenfor kjørbart område)
    }
  }


  //TODO spawn fiender, spawn hindringer osv

  /** Gjør all tegning**/
  for (int i = 0; i < jumps.size(); i++) {
    jumps.get(i).draw();//tegner alle hopp
  }

  //TODO tegn fiender, hindringer osv

  player.draw();//Tegner spiller
  tv.draw();






  //Skriver vi score, text osv
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
      if (player.isJumping()) return;
      speedUp();
    }
    if (keyCode == DOWN)
    {
      if (player.isJumping()) return;
      speedDown();
    }
  }
  if(key == 'f'){
    
    f.toggle(this);
  }
}

void speedDown() {
  scrollSpeed--; 
  if (scrollSpeed < 0) scrollSpeed = 0;
}

void speedUp() {
  scrollSpeed++; 
  if (scrollSpeed > 30) scrollSpeed = 30;
}

void cleanUp() {
  for (int i = 0; i < jumps.size(); i++) { //Fjerner alle hopp som er utenfor
    if (jumps.get(i).y > height +100) {
      jumps.remove(i);
    }
  }

  //TODO fjern fiender, hindringer osv
}


//sjekker om spillern skal hoppe
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


int map(int x, int in_min, int in_max, int out_min, int out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}

