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
      fill(#29FF00);
    }else{
      fill(#F54D58);
    }
    location.add(velocity); 
    text(""+p, (int)location.x, (int)location.y);
  }
}

