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
  fill(50,50,230, 1.0);
  ellipse(x,y,h,h);
  h+=50;
  strokeWeight(1);
 } 
}
