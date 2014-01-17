import processing.video.*;


public class Tv {
  Capture cam;
  PImage tv, tv2;
  int i = 0;  
  public Tv(BikerGame b) {
    tv = loadImage("Images/TV.png");
    tv2 = loadImage("Images/TVn.png");


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


  void draw() {
    //if (i == 25) {
    //  if (cam.available() == true) {
    //    cam.read();
    //  }
    // i = 0;
   //}
    i++;
    image(tv, 0, height-(tv.height/1.5), tv.width/1.5, tv.height/1.5);
    //image(cam, 25, 585, 165, 107);
    //set(0,0,cam);
    fill(#000000);
    rect(width - (tv.width/1.5) + 20, height-(tv.height/1.5) +13, (tv.width/1.5) -40, (tv.height/1.5) - 40);
    image(tv, width - tv.width/1.5, height-(tv.height/1.5), tv.width/1.5, tv.height/1.5);
    
    rect(width - (tv.width/1.5) + 20, 30, (tv.width/1.5) -40, (tv.height/1.5) - 40);
    image(tv2, width - tv.width/1.5, 0, tv.width/1.5, tv.height/1.5);
  }
}

