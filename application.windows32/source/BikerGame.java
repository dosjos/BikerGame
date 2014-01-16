import processing.core.*; 
import processing.xml.*; 

import java.util.*; 
import processing.serial.*; 
import ddf.minim.*; 
import javax.media.opengl.*; 
import processing.opengl.*; 
import java.awt.Dimension; 
import java.awt.Toolkit; 
import processing.core.PApplet; 
import processing.video.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class BikerGame extends PApplet {


 





AudioSample bell;
Minim minim;
PImage Backgrounds[] = new PImage[4] ;//Inneholder bakgrunnsbilder
int BackgroundYs[] = new int[4]; //Inneholder Y posisjonen til bakgrunnene
PImage[] flamesEnemy = new PImage[4];
PImage[] fireEnemy = new PImage[5];
PImage[] flames = new PImage[4];
PImage[] bushes = new PImage[3];
PImage happy;
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
int imageHeight = 720;//H\u00f8yden p\u00e5 en bakgrunn

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


public void setup() {
  happy           = loadImage("Images/BurningEnemy_Friendly.png");
  flamesEnemy[0]  = loadImage("Images/BurningEnemy_Fire01.png");
  flamesEnemy[1]  = loadImage("Images/BurningEnemy_Fire02.png");
  flamesEnemy[2]  = loadImage("Images/BurningEnemy_Fire03.png");
  flamesEnemy[3]  = loadImage("Images/BurningEnemy_Fire04.png");
  fireEnemy[0]    = loadImage("Images/01_BurningEnemy.png");
  fireEnemy[1]    = loadImage("Images/02_BurningEnemy.png");
  fireEnemy[2]    = loadImage("Images/03_BurningEnemy.png");
  fireEnemy[3]    = loadImage("Images/04_BurningEnemy.png");
  fireEnemy[4]    = loadImage("Images/05_BurningEnemy.png");
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

  BackgroundYs[0] = 0;//Setter initiell posisjon p\u00e5 bakgrunnene
  BackgroundYs[1] = -720;
  BackgroundYs[2] = -1440;
  BackgroundYs[3] = -2180;

  minim = new Minim(this);
  bell = minim.loadSample("Sounds/bell.wav", 2048);
  pointFont = loadFont("Algerian-48.vlw");//Laster inn fonter
  textFont = loadFont("Aharoni-Bold-32.vlw");

  highScore.ReadScores();


  player = new Player();//oppretter spilleren
  tv = new Tv(this);//oppretter tven
  frameRate(40);//Setter framerate til 30, s\u00e5nn at det blir stabilt

  textFont(pointFont, 48);//Setter hovedtekstfonten
  size(1280, 720, OPENGL);//Setter oppl\u00f8sning og grafikkmotor
  try {
    myPort = new Serial(this, Serial.list()[0], 9600);
    myPort.clear();
  }
  catch(Exception e) {
  }
  smooth();
}

public void serialEvent(Serial p) { 
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
      }else if(input.contains("a")){
       input = input.replace("a", "");
        double speed = Double.parseDouble(input);
       if(speed > scrollSpeed + 2.0f){
        scrollSpeed += 1;
       //}else if(scrollSpeed < speed){
       // scrollSpeed = (int)speed;
       }else if (speed < scrollSpeed){
        scrollSpeed = (int)speed; 
      }
      }}
  }
  catch(Exception e) {
  }
}

public void draw() {


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


    /** Diverse spilltekniske skjekker, krasj, hopp, osv**/

    checkForSolidChrash();


    checkForJumps();//Sjekker om spillern skal hoppe
    //TODO legg til checker for alt, enemies, collisions, osv


    /** Beregning av poeng **/
    /*if (scrollSpeed > 0 ) {
     scrollCount++;  //Hadde ingen innvirkning, vet ikke hva den er til....
     }*/
    if (frameCount % 10 == 0) {
      player.addScore(scrollSpeed/5.0f);
    }

    /**Her kan vi spawne nye entiteter**/
    if (scrollSpeed >= 3) {// Spawner kun hopp derson hastigheten er over 3
      if (r.nextInt(80) == 10) {//Spavenr kun hopp med 1/80 dels sansynelighet
        jumps.add(new Jump(r.nextInt(780) + 220, jumpImage));//x posisjonen til hoppet blir valgt random (innenfor kj\u00f8rbart omr\u00e5de)
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
      if (r.nextInt(100) == 37) {
        solids.add(new Bush(bushes[r.nextInt(3)]));
      }
      if (r.nextInt(600) == 37) {
        pumps.add(new Pump(pump));
      }
       if (r.nextInt(400) == 37) {
        enemys.add(new FrostEnemy(frost));
      }
      if (r.nextInt(400) == 37) {
        enemys.add(new FireEnemy(fireEnemy,flamesEnemy));
      }
    }




    //TODO spawn fiender, spawn hindringer osv

    /** Gj\u00f8r all tegning**/
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
    fill(0xffFF0000);
    rect(30, 100, 55, 450, 25, 12, 12, 25);
    fill(0xffFFA824);
    rect(30, 550 - map(player.flames, 800, 0, 450, 0), 55, map(player.flames, 800, 0, 450, 0), 25, 12, 12, 25);
    //DRAW SHOTS
    fill(0xffFFFFFF);
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
    fill(0xffFFFFFF);
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

/** Lytter p\u00e5 knapper, brukes under utvikling p\u00e5 pc**/
public void keyReleased() {
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

public void keyPressed()
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

public void speedDown() {
  scrollSpeed--; 
  if (scrollSpeed < 0) scrollSpeed = 0;
}

public void speedUp() {
  scrollSpeed++; 
  if (scrollSpeed > 30) scrollSpeed = 30;
}

public void cleanUp() {
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
    if (sonics.get(i).h > width*1.5f ) {
      sonics.remove(i);
    }
  }
  
  for (int i = 0; i < enemys.size(); i++) { //Fjerner alle hopp som er utenfor
    if(enemys.get(i).dead){
      enemys.remove(i);
      i--;
    }
    else if (enemys.get(i).y > height && !enemys.get(i).dying && !enemys.get(i).dead) {
      texts.add(new ScoreText(-100, false, enemys.get(i).x, enemys.get(i).y));
      enemys.remove(i);
      i--;
    }
  }

  //TODO fjern fiender, hindringer osv
}


//sjekker om spillern skal hoppe
public void checkForJumps() {
  for (int i = 0; i < jumps.size(); i++) {
    Jump j = jumps.get(i);
    if (j.x +50 < player.x + player.w && j.x + j.w -50 > player.x) {
      if (j.y < player.y + player.h && j.y + (j.h/2) > player.y) {

        player.jump();
      }
    }
  }
}


public int map(int x, int in_min, int in_max, int out_min, int out_max)
{
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}


public void checkForSolidChrash() {
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

    //Skjekk for flammeburn p\u00e5 busk
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
      if (flame  && !enemys.get(i).dead) {
      if (enemys.get(i).y < player.y - flames[0].height+10 + flames[0].height &&  enemys.get(i).y + enemys.get(i).h > player.y - flames[0].height+10) {
        if (enemys.get(i).x < (player.x + (player.w/2)) - (flames[0].width/2)-3 + flames[0].width && enemys.get(i).x + enemys.get(i).w > (player.x + (player.w/2)) - (flames[0].width/2)-3) {
         if(enemys.get(i) instanceof FireEnemy ){
           if(enemys.get(i).dying){
            enemys.get(i).dying = false;
            texts.add(new ScoreText(150, false, enemys.get(i).x, enemys.get(i).y));
           }
         }else if (enemys.get(i) instanceof FrostEnemy && !enemys.get(i).dying){
          enemys.get(i).dying = true;
          enemys.get(i).diestate = true;
          texts.add(new ScoreText(100, true, enemys.get(i).x, enemys.get(i).y));
         }//
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
      }else if(enemys.get(j) instanceof FireEnemy &&  d <= sonics.get(i).h + 50 && !enemys.get(j).dying){
       enemys.get(j).dying = true;
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

public class Bush extends Solid{
 
 public Bush(PImage image){
  super(image);
  isBush = true;
 } 
}
public class DirtCrack extends Solid{
  public DirtCrack(PImage img){
   super(img); 
  }
}


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
      y++;
    }else{
      image(happy, x,y);
      y+= scrollSpeed;
    }
    
    
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


public class FrostEnemy extends Enemy {
  int cellsize = 4; // Dimensions of each cell in the grid
  int columns, rows; 
  int ma = 0;
  int w, s;
  public FrostEnemy(PImage image) {
    super(image);
    columns = img.width / cellsize;  // Calculate # of columns
    rows = img.height / cellsize;  //
  }

  public void draw() {
    y += scrollSpeed;

    if (dying && !dead) {
      if (diestate) {//Smelte
        image(water, x + (img.width/2) -w/2, y+img.height-20, w, w);
        image(img, x, y+ s, img.width, img.height - s);

        s +=2;
        w++;
        if (s >= img.height) {
          dead = true;
        }
      }
      else {//Smuldre
        for ( int i = 0; i < columns; i++) {
          // Begin loop for rows
          for ( int j = 0; j < rows; j++) {
            int xx = i*cellsize + cellsize/2;  // x position
            int yy = j*cellsize + cellsize/2;  // y position
            int loc = xx + yy*img.width;  // Pixel array location
            int c = img.pixels[loc];  // Grab the color
            // Calculate a z position as a function of mouseX and pixel brightness
            //img.pixels[loc]
            float z = (ma / PApplet.parseFloat(520)) * brightness(r.nextInt(600));
            // Translate to the location, set fill and stroke, and draw the rect
            pushMatrix();
            translate(xx+x, yy + y, z);
            fill(c, 204);
            noStroke();
            rectMode(CENTER);
            rect(0, 0, cellsize, cellsize);
            popMatrix();
            rectMode(CORNER);
          }
        }
        ma += 14;
        if (ma > 400) {
          ma = 0;
          dead = true;
        }
      }
    }
    else {
      image(img, x, y);
    }
  }
}





public class Fullscreen {
  private  boolean FULL_SCREEN = false;
  public  Dimension APP_SIZE = new Dimension(1280, 720);
  
  private  void setChrome(PApplet papplet, boolean full) {
    papplet.frame.setUndecorated(full);
  }

  private  void setLocation(PApplet papplet, boolean full) {
    papplet.frame.setLocation(0, 0);      
  }

  private  void setSize(PApplet papplet, boolean full) {
    if (full) {
      papplet.frame.setSize(Toolkit.getDefaultToolkit().getScreenSize());
    } else {
      papplet.frame.setSize(APP_SIZE);
    }    
  }
    
  public  void toggle(PApplet papplet) {
    FULL_SCREEN = !FULL_SCREEN; 
    papplet.frame.dispose();
    papplet.frame.setResizable(!FULL_SCREEN);
    setSize(papplet, FULL_SCREEN);
    setChrome(papplet, FULL_SCREEN);
    setLocation(papplet, FULL_SCREEN);
    papplet.frame.setVisible(true);
  }
}
 
public class HighScore {
  BufferedReader reader;
  String line;
  ArrayList<Integer> scores = new ArrayList<Integer>();
  PrintWriter output;
  int lastHighscore;

  public void ReadScores() {
    scores = new ArrayList<Integer>();
    try {
      reader = createReader(dataPath("score.txt"));    
      while ( (line = reader.readLine ()) != null) {
        scores.add(Integer.parseInt(line));
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
    Collections.sort(scores);
    Collections.reverse(scores);
  }

  public void addScore(double s) {
    scores.add((int)s); 
    Collections.sort(scores);
    Collections.reverse(scores);
    output = createWriter(dataPath("score.txt"));
    for (int i = 0; i < scores.size(); i++) {

      output.println(scores.get(i));
    }
    output.flush();
    output.close();
  }

  public void draw() {
    PFont s = createFont("Georgia", 38);
    textFont(s);
    fill(0xffFFFFFF);
    text("High Score", 1080, 80);
    for (int i = 0; i < scores.size() && i < 10; i++) {
      if (lastHighscore-1 == i) {
        fill(0xffFF0000);
      }
      else {
        fill(0xffFFFFFF);
      }
      text(""+(i+1) + ". " + scores.get(i), 1090, 120 + (40*(1+i)) );
    }
  }
}

public class Jump{
 PImage image;
  int x, y; //koordinater
  int w, h;//bredde h\u00f8yde
 public Jump(int x, PImage image){
  
  this.x = x;
  this.image = image; 
  y = -100;
  
  w = image.width;
  h = image.height;
 } 
  
 public void draw(){
   image(image, x,y);
   y += scrollSpeed;
 }   
}
public class LargeRock extends Solid{  
 public LargeRock(PImage image){//Utvides til \u00e5 ta imot og sende videre x posisjon
  super(image);
 }
}
public class Menu
{
  PFont head = createFont("Algerian", 92);
  PFont text = createFont("Algerian", 48);
 
 public void draw(){
  textFont(head);
  text("Biker Game", 350.0f, 100);
  textFont(text);
  text("    Sykkle s\u00e5 langt du kan,", 250, 250);
  text("        pass deg for hindere", 250, 300);
  text("     Knus isfiender med den ",250, 350);
  text("  supersoniske ringeklokken,", 250, 400);
  text("    Brenn vampyrer og busker",250,450);
  text("      med brennhete flammer", 250, 500);
  
    text("Ring med bjellen for \u00e5 starte", 250, 600);
 } 
  
  
}
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
  int flames;
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
    flames = 800;
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
try{
      if (goRight) {       
        x += 5;
        if (dist == 0 && scrollSpeed > 0) {
          x+= 1;
        }
        if (x > 1060 - (playerImage.width)) {
          x = 1060 - (playerImage.width);
        }
      }
      else if (goLeft) {
        x -= 5;
        if (dist == 0 && scrollSpeed > 0) {
          x-= 1;
        }
        if (x < 220) {
          x = 220;
        }
      }
          }catch(Exception e){}
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
      image(lifeImage, 120, 50 + (70*i));
    }
  }




  public boolean isJumping() {
    return jump;
  }

  public void addScore(double a) {
    score += a;
  }

  public void jump() {
    if (jump == false && scrollSpeed >= 4) {
      jump = true;    
      jumpSpeeder = 0;   
      texts.add(new ScoreText(50, true, player.x, player.y));
      //addScore(50.0);
    }
  }
}

public class Pump{
 PImage img;
 int x, y, h, w;
  public Pump(PImage image){
  img = image;
  w = image.width;
  h = image.height;
  y = - 100;
  x = 220 + r.nextInt(1060);
 }

  public void draw(){
   y+=scrollSpeed;
   image(img,x,y);
  } 
  
}
public class RockLong extends Solid{
 public RockLong(PImage image){
   super(image);
 }
}
public class RockSmall extends Solid{
 public RockSmall(PImage image){
   super(image);
 }
}
public class ScoreText {
  int p;
  boolean co;

  PVector location;
  PVector velocity;
  float x, y;
  public ScoreText(int points, boolean isGood, int xx, int yy) {
    p = points;
    co = isGood;
    location = new PVector(xx, yy);

    float angle = atan2(50 - yy, width - 160 - xx);

    x = cos(angle)*15;
    y = sin(angle)*15;

    velocity = new PVector(x, y);
    //width - 160, 50
  } 

  public void draw() {
    if(co){
      fill(0xff29FF00);
    }else{
      fill(0xffF54D58);
    }
    location.add(velocity); 
    text(""+p, (int)location.x, (int)location.y);
  }
}

class Solid{
 int x = 0, y = 0, w = 0, h = 0; 
  Random r = new Random();
  public PImage image;
  boolean isBush;
  boolean isBurning;
  int burnimage = 0;
  int burnimageChange;
  public Solid(PImage image){//Utvides til \u00e5 ta imot x posisjon
   this.image = image; 
   w = image.width;
   h = image.height;
   y = -50;
   x = 220 + r.nextInt(800 - w);
}
  
 public void draw(){
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
public class Supersonic{
  int x,y,h;
 public Supersonic(int x, int y){
  this.x = x;
 this.y = y;
  h = 0; 
 }
 
 public void draw(){
   stroke(50,50,230);
   strokeWeight(5);
  fill(50,50,230, 1.0f);
  ellipse(x,y,h,h);
  h+=50;
  strokeWeight(1);
 } 
}
public class Tree extends Solid{
 public Tree(PImage image){
   super(image);
 }
}



public class Tv {
  Capture cam;
  PImage tv;
  int i = 0;  
  public Tv(BikerGame b) {
    tv = loadImage("Images/TV.png");


    /*String[] cameras = Capture.list();

    if (cameras == null) {
      println("Failed to retrieve the list of available cameras, will try the default...");
      cam = new Capture(b, 640, 480);
    } 
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } 
    else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }
      cam = new Capture(b, 640, 480);
      cam.start();
    }*/
    
  } 


  public void draw() {
    //if (i == 25) {
    //  if (cam.available() == true) {
    //    cam.read();
    //  }
    // i = 0;
   //}
    i++;
    image(tv, 0, height-(tv.height/1.5f), tv.width/1.5f, tv.height/1.5f);
    //image(cam, 25, 585, 165, 107);
    //set(0,0,cam);
  }
}

public class Water extends Solid{
 public Water(PImage image){
   super(image);
 }
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--present", "--bgcolor=#666666", "--stop-color=#cccccc", "BikerGame" });
  }
}
