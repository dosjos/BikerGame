import java.util.*;
import processing.serial.*; 
import ddf.minim.*;

AudioSample bell;
Minim minim;
PImage Backgrounds[] = new PImage[4] ;//Inneholder bakgrunnsbilder
int BackgroundYs[] = new int[4]; //Inneholder Y posisjonen til bakgrunnene

PImage largeRock;
PImage dirtCrack;
PImage longRock;
PImage smallRock;
PImage tree;
PImage water;
PImage jumpImage;//Bilde av hoppet
PFont pointFont;//Fonten til poeng
PFont textFont; //Font til resten

Menu menu = new Menu();

ArrayList<PImage> BackgroundList = new ArrayList<PImage>();//Liste over alle mulige bakgrunnsbilder
Random r = new Random();

ArrayList<Jump> jumps = new ArrayList<Jump>(); //Alle hoppene
ArrayList<Solid> solids = new ArrayList<Solid>();
ArrayList<Supersonic> sonics = new ArrayList<Supersonic>();

static int scrollSpeed = 0;//Hvor fort bakgrunnen scroller
int scrollCount;

int bakgroundY = 0;
int imageHeight = 720;//Høyden på en bakgrunn

int time;

Player player; //Spilleren
Tv tv;        //Tven nede til venstre

int gamestate = 0;

Serial myPort; 
int val; 
String input;
Fullscreen f = new Fullscreen();


void setup() {

  jumpImage      = loadImage("Images/Ramp.png");
  largeRock      = loadImage("Images/Rock_Large.png");
  dirtCrack      = loadImage("Images/DirtCrack.png");
  longRock       = loadImage("Images/Rock_Long.png"); 
  smallRock      = loadImage("Images/Rock_Small.png");
  tree           = loadImage("Images/TreeBroken.png"); 
  water          = loadImage("Images/Waterpool.png");
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

  minim = new Minim(this);
  bell = minim.loadSample("Sounds/bell.wav", 2048);
  pointFont = loadFont("Algerian-48.vlw");//Laster inn fonter
  textFont = loadFont("Aharoni-Bold-32.vlw");

  player = new Player();//oppretter spilleren
  tv = new Tv(this);//oppretter tven
  frameRate(30);//Setter framerate til 30, sånn at det blir stabilt

  textFont(pointFont, 48);//Setter hovedtekstfonten
  size(1280, 720, P3D);//Setter oppløsning og grafikkmotor
try{
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.clear();
}catch(Exception e){}
}



void draw() {
  if(gamestate == 0){
    background(0, 0, 0);
    image(Backgrounds[1], 0, 0);
    menu.draw();
  }
  
  if(gamestate == 1){
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

try {
  if ( myPort.available() > 0) {
    
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
  }
  catch(Exception e) {}
    
  /** Diverse spilltekniske skjekker, krasj, hopp, osv**/

  checkForSolidChrash();


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

    if (r.nextInt(200) == 37) {
      solids.add(new LargeRock(largeRock));
    }  

    if (r.nextInt(200) == 37) {
      solids.add(new RockSmall(smallRock));
    }  
    if (r.nextInt(200) == 37) {
      solids.add(new RockLong(longRock));
    }  
    if (r.nextInt(200) == 37) {
      solids.add(new DirtCrack(dirtCrack));
    }  
    if (r.nextInt(200) == 37) {
      solids.add(new Water(water));
    } 
    if (r.nextInt(200) == 37) {
      solids.add(new Tree(tree));
    }
  }




  //TODO spawn fiender, spawn hindringer osv

  /** Gjør all tegning**/
  for (int i = 0; i < jumps.size(); i++) {
    jumps.get(i).draw();//tegner alle hopp
  }

  //TODO tegn fiender, hindringer osv

  for (int i= 0; i < solids.size(); i++) {
    solids.get(i).draw();
  }








  //Skriver vi score, text osv
  fill(255);
  stroke(0);
  textFont(pointFont);
  text("" + (int)player.score, width - 160, 50);
  text("" + scrollSpeed, width - 160, height-50);
  textFont(textFont);
  text("km/t", width - 100, height-50);
  
  //DRAW SHOTS
  for (int i= 0; i < sonics.size(); i++) {
    sonics.get(i).draw();
  }

  player.draw();//Tegner spiller
  tv.draw();
  if(player.life <= 0){
   gamestate = 2;
   time = millis();
  }  
  
  /** Rydder opp og sletter entiteter**/
  cleanUp();
  }//END GAMESTATE == 1
  if(gamestate == 2){
image(Backgrounds[1], 0, 0);
    
    text("" + (time - (millis() - 5000)),550,300);
    if(millis() > time + 5000){
     gamestate = 0;
    } 
  }
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
      if(gamestate == 0){
       gamestate = 1; 
       player = new Player();
       solids = new ArrayList<Solid>();
       jumps = new ArrayList<Jump>();
       sonics = new ArrayList<Supersonic>();
      }
      if (player.isJumping()) return;
      speedUp();
    }
    if (keyCode == DOWN)
    {
      if (player.isJumping()) return;
      speedDown();
    }
    
    
    
  }
  if(key == ' '){
   sonics.add(new Supersonic(player.x + (player.w / 2), player.y + 20));
   bell.trigger();
  }
  if (key == 'f') {
    f.toggle(this);
  }
  if (key == 'g') {
    player.images = player.girlImages;
  }
  if (key == 'b') {
    player.images = player.boyImages;
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
  for (int i = 0; i < solids.size(); i++) { //Fjerner alle hopp som er utenfor
    if (solids.get(i).y > height +solids.get(i).h+50) {
      solids.remove(i);
    }
  }
  for (int i = 0; i < sonics.size(); i++) { //Fjerner alle hopp som er utenfor
    if (sonics.get(i).h > width*2 ) {
      sonics.remove(i);
    }
  }
  
  //TODO fjern fiender, hindringer osv

}


//sjekker om spillern skal hoppe
void checkForJumps() {
  for (int i = 0; i < jumps.size(); i++) {
    Jump j = jumps.get(i);
    if (j.x +50 < player.x + player.w && j.x + j.w -50 > player.x) {
      if (j.y < player.y + player.h && j.y + (j.h/2) > player.y) {

        player.jump();
      }
    }
  }
}


int map(int x, int in_min, int in_max, int out_min, int out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


void checkForSolidChrash() {
  for (int i = 0; i < solids.size(); i++) { //Fjerner alle hopp som er utenfor
    if (solids.get(i).y + 50 < player.y + player.h &&  solids.get(i).y + solids.get(i).h -50 > player.y) {
      if (solids.get(i).x < player.x + player.w && solids.get(i).x + solids.get(i).w > player.x) {
        if (!player.safe && !player.isJumping()) {
          player.life--;
          player.safeleft  = 80;
          player.safe = true;
          player.safedraw = false;
          scrollSpeed = 5;
          player.score -= 50;
        }
      }
    }
  }
}

