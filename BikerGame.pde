import java.util.*;
import processing.serial.*; 
import ddf.minim.*;

import javax.media.opengl.*;
import processing.opengl.*;

AudioSample bell;
Minim minim;
PImage Backgrounds[] = new PImage[4] ;//Inneholder bakgrunnsbilder
int BackgroundYs[] = new int[4]; //Inneholder Y posisjonen til bakgrunnene

PImage[] flames = new PImage[4];
PImage[] bushes = new PImage[3];
PImage largeRock;
PImage dirtCrack;
PImage longRock;
PImage smallRock;
PImage tree;
PImage water;
PImage pump;
PImage frost;
PImage jumpImage;//Bilde av hoppet
PFont pointFont;//Fonten til poeng
PFont textFont; //Font til resten
PImage[] burningBush = new PImage[11];

HighScore highScore = new HighScore();
Menu menu = new Menu();

ArrayList<PImage> BackgroundList = new ArrayList<PImage>();//Liste over alle mulige bakgrunnsbilder
Random r = new Random();

ArrayList<Jump> jumps = new ArrayList<Jump>(); //Alle hoppene
ArrayList<Solid> solids = new ArrayList<Solid>();
ArrayList<Supersonic> sonics = new ArrayList<Supersonic>();
ArrayList<ScoreText> texts = new ArrayList<ScoreText>();
ArrayList<Pump> pumps = new ArrayList<Pump>();
ArrayList<Enemy> enemys = new ArrayList<Enemy>();

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

long start, end;
boolean flame = false;
int flameFrame = 0;

public void reset() {
  jumps = new ArrayList<Jump>(); //Alle hoppene
  solids = new ArrayList<Solid>();
  sonics = new ArrayList<Supersonic>();
  texts = new ArrayList<ScoreText>();
  pumps = new ArrayList<Pump>();
  enemys = new ArrayList<Enemy>();
  player = new Player();
}


void setup() {
  frost          = loadImage("Images/FrostEnemy.png");
  pump           = loadImage("Images/Pump.png");
  burningBush[0] = loadImage("Images/burningbush.png");
  burningBush[1] = loadImage("Images/Bush_Flame_01.png");
  burningBush[2] = loadImage("Images/Bush_Flame_02.png");
  burningBush[3] = loadImage("Images/Bush_Flame_03.png");
  burningBush[4] = loadImage("Images/SmokePile.png");
  burningBush[5] = loadImage("Images/SmokePile02.png");
  burningBush[6] = loadImage("Images/SmokePile03.png");
  burningBush[7] = loadImage("Images/SmokePile04.png");
  burningBush[8] = loadImage("Images/SmokePile05.png");
  burningBush[9] = loadImage("Images/SmokePile06.png");
  burningBush[10] = loadImage("Images/SmokePile07.png");
  bushes[0]      = loadImage("Images/Bush.png");
  bushes[1]      = loadImage("Images/Bush02.png");
  bushes[2]      = loadImage("Images/Bush03.png");
  flames[0]      = loadImage("Images/1_FlameThrower_04.png");
  flames[1]      = loadImage("Images/2_FlameThrower_02.png");
  flames[2]      = loadImage("Images/3_FlameThrower_03.png");
  flames[3]      = loadImage("Images/4_FlameThrower_01.png");
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

  highScore.ReadScores();


  player = new Player();//oppretter spilleren
  tv = new Tv(this);//oppretter tven
  frameRate(40);//Setter framerate til 30, sånn at det blir stabilt

  textFont(pointFont, 48);//Setter hovedtekstfonten
  size(1280, 720, OPENGL);//Setter oppløsning og grafikkmotor
  try {
    myPort = new Serial(this, Serial.list()[0], 9600);
    myPort.clear();
  }
  catch(Exception e) {
  }
  smooth();
}

void serialEvent(Serial p) { 
  try {
    input = p.readStringUntil(10);
    if (input!=null) {
      if (input.contains("x")) {
        input = input.replace("x", "");
        input = trim(input);
        int inX = Integer.parseInt(input);
        inX = map(inX, -100, 100, -10, 10);
        player.turn = true;
        player.dist = inX;
      }
      else if (input.contains("s")) {
        if (gamestate == 0) {
          gamestate = 1;
          reset();
        }
        else if (gamestate == 1) {
          sonics.add(new Supersonic(player.x + (player.w / 2), player.y + 20));
          bell.trigger();
        }
      }
      else if (input.contains("z")) {
        if (input.contains("1")) {
          //SKYT FLAMME
          if (player.flames >50) {
            flame = true;
          }
        }
        else if (input.contains("0")) {
          //STANS FLAMME
          flame = false;
        }
      }
    }
  }
  catch(Exception e) {
  }
}

void draw() {


  if (gamestate == 0) {
    background(0, 0, 0);
    image(Backgrounds[1], 0, 0, 1280, 720);
    menu.draw();
    highScore.draw();
  }

  else if (gamestate == 1) {
    /** Tegning og oppdatering av bakgrunn**/
    background(0, 0, 0);
    for (int i = 0; i < Backgrounds.length; i++) {
      if (BackgroundYs[i] > -imageHeight && BackgroundYs[i] < imageHeight) {
        //   println(BackgroundYs[i]);
        image(Backgrounds[i], 0, BackgroundYs[i], 1280, 720);
      }
      BackgroundYs[i] += scrollSpeed;

      if (BackgroundYs[i] >= imageHeight) {
        BackgroundYs[i] -= imageHeight*3;
        Backgrounds[i] = BackgroundList.get(r.nextInt(BackgroundList.size()));
      }
    }


    //try {
    //  if ( myPort.available() > 0) {

    //    }
    //  }
    //  catch(Exception e) {}

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

      if (r.nextInt(400) == 37) {
        solids.add(new LargeRock(largeRock));
      }  

      if (r.nextInt(400) == 37) {
        solids.add(new RockSmall(smallRock));
      }  
      if (r.nextInt(400) == 37) {
        solids.add(new RockLong(longRock));
      }  
      if (r.nextInt(400) == 37) {
        solids.add(new DirtCrack(dirtCrack));
      }  
      if (r.nextInt(400) == 37) {
        solids.add(new Water(water));
      } 
      if (r.nextInt(400) == 37) {
        solids.add(new Tree(tree));
      }
      if (r.nextInt(38) == 37) {
        solids.add(new Bush(bushes[r.nextInt(3)]));
      }
      if (r.nextInt(600) == 37) {
        pumps.add(new Pump(pump));
      }
       if (r.nextInt(38) == 37) {
        enemys.add(new FrostEnemy(frost));
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
    for (int i= 0; i < pumps.size(); i++) {
      pumps.get(i).draw();
    }
    for (int i= 0; i < texts.size(); i++) {
      texts.get(i).draw();
    }
    for (int i= 0; i < enemys.size(); i++) {
      enemys.get(i).draw();
    }







    //Skriver vi score, text osv
    fill(255);
    stroke(0);
    textFont(pointFont);
    text("" + (int)player.score, width - 160, 50);
    text("" + scrollSpeed, width - 160, height-50);
    textFont(textFont);
    text("km/t", width - 100, height-50);
    text(frameRate + "fps", 75, height -50);

    //TEGNER FLAMMEMENGDE
    fill(#FF0000);
    rect(30, 100, 55, 450, 25, 12, 12, 25);
    fill(#FFA824);
    rect(30, 550 - map(player.flames, 800, 0, 450, 0), 55, map(player.flames, 800, 0, 450, 0), 25, 12, 12, 25);
    //DRAW SHOTS
    fill(#FFFFFF);
    for (int i= 0; i < sonics.size(); i++) {
      sonics.get(i).draw();
    }
    if (flame && player.flames > 50) {
      player.flames--;
      image(flames[flameFrame], (player.x + (player.w/2)) - (flames[flameFrame].width/2)-3, player.y - flames[flameFrame].height+10);
      flameFrame++;
      if (flameFrame == 4) {
        flameFrame = 0;
      }
    }
    else {
      flame = false;
    }

    player.draw();//Tegner spiller
    tv.draw();


    if (player.life <= 0) {
      gamestate = 2;
      highScore.addScore(player.score);
      time = millis();
    }  

    /** Rydder opp og sletter entiteter**/
    cleanUp();
  }//END GAMESTATE == 1
  else if (gamestate == 2) {
    fill(#FFFFFF);
    image(Backgrounds[1], 0, 0, 1280, 720);

    textFont(pointFont);
    text("GAME OVER", width/2 - 150, 150);
    text("" + (int)player.score + " poeng", width/2 - 150, 250);

    int plass;
    plass = highScore.scores.indexOf((int)player.score)+1;
    if (plass <= 10) {
      text("Gratulerer med " + plass + ". plass", (width/2) - 350, 350); 
      highScore.lastHighscore = plass;
    }
    else {
      highScore.lastHighscore = -1;
    }

    text("Restarter om " + ((time - (millis() - 8000)))/1000 + " sekunder", 300, 550);
    if (millis() > time + 7000) {
      gamestate = 0;
      player = new Player();
      reset();
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
      if (gamestate == 0) {
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
  if (key == ' ') {
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

  if (key == 'o') {
    flame = false;
  }
  if (key == 'i') {
    if (player.flames > 50) {
      flame = true;
    }
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
  for (int i = 0; i < texts.size(); i++) { //Fjerner alle hopp som er utenfor
    if (texts.get(i).location.x > width - 100 || texts.get(i).location.y < 50) {
      player.score += texts.get(i).p;
      texts.remove(i);
    }
  }

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
    if (sonics.get(i).h > width*1.5 ) {
      sonics.remove(i);
    }
  }
  
  for (int i = 0; i < enemys.size(); i++) { //Fjerner alle hopp som er utenfor
    if(enemys.get(i).dead){
      enemys.remove(i);
      i--;
    }
    else if (enemys.get(i).y > height ) {
      texts.add(new ScoreText(-100, false, enemys.get(i).x, enemys.get(i).y));
      enemys.remove(i);
      i--;
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
      if (solids.get(i).x < player.x + player.w-25 && solids.get(i).x + solids.get(i).w > player.x+25) {
        if (!player.safe && !player.isJumping() && 
          (   (solids.get(i).isBush && !solids.get(i).isBurning) || !solids.get(i).isBush)) {
          player.life--;
          player.safeleft  = 80;
          player.safe = true;
          player.safedraw = false;
          scrollSpeed = 5;
          texts.add(new ScoreText(-50, false, player.x, player.y));
        }
      }
    }

    //Skjekk for flammeburn på busk
    if (flame && solids.get(i).isBush && !solids.get(i).isBurning) {
      if (solids.get(i).y < player.y - flames[0].height+10 + flames[0].height &&  solids.get(i).y + solids.get(i).h > player.y - flames[0].height+10) {
        if (solids.get(i).x < (player.x + (player.w/2)) - (flames[0].width/2)-3 + flames[0].width && solids.get(i).x + solids.get(i).w > (player.x + (player.w/2)) - (flames[0].width/2)-3) {
          solids.get(i).isBurning = true;
          //TODO sett brennende bilde
          solids.get(i).image = burningBush[0];
          texts.add(new ScoreText(35, true, solids.get(i).x, solids.get(i).y));
        }
      }
    }
  }
  //Sjekk for fiendetreff med flammer
  for (int i = 0; i < enemys.size(); i++) { //Fjerner alle hopp som er utenfor
      if (flame && !enemys.get(i).dying && !enemys.get(i).dead) {
      if (enemys.get(i).y < player.y - flames[0].height+10 + flames[0].height &&  enemys.get(i).y + enemys.get(i).h > player.y - flames[0].height+10) {
        if (enemys.get(i).x < (player.x + (player.w/2)) - (flames[0].width/2)-3 + flames[0].width && enemys.get(i).x + enemys.get(i).w > (player.x + (player.w/2)) - (flames[0].width/2)-3) {
          enemys.get(i).dying = true;
          enemys.get(i).diestate = true;
          texts.add(new ScoreText(100, true, enemys.get(i).x, enemys.get(i).y));
        }
      }
    }
  }
  
  for(int i = 0; i < sonics.size(); i++){
    for(int j = 0; j < enemys.size(); j++){
      float d = dist(sonics.get(i).x,sonics.get(i).y, enemys.get(j).x, enemys.get(j).y );
      if(enemys.get(j) instanceof FrostEnemy &&  d <= sonics.get(i).h + 50 && !enemys.get(j).dying){
        enemys.get(j).dying = true;
        enemys.get(j).diestate = false;
        texts.add(new ScoreText(100, true, enemys.get(j).x, enemys.get(j).y));
      } 
    }
  }
  
  //sjekk for pumper
  for (int i = 0; i < pumps.size(); i++) { //Fjerner alle hopp som er utenfor
    if (pumps.get(i).y + 50 < player.y + player.h &&  pumps.get(i).y + pumps.get(i).h -50 > player.y) {
      if (pumps.get(i).x < player.x + player.w-25 && pumps.get(i).x + pumps.get(i).w > player.x+25) {
        if (!player.isJumping()){
          texts.add(new ScoreText(75, true, pumps.get(i).x, pumps.get(i).y));
          player.life++;
          if(player.life > 6){
            player.life = 6;
          }
          player.flames += 100;
          if (player.flames > 800){
           player.flames = 800; 
          }
          pumps.remove(i);
          i--;
        }
      }
    }
  }
}

