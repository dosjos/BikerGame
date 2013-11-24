import processing.video.*;


public class Tv {
 // Capture cam;
  PImage tv;
  int i = 0;  
  public Tv(BikerGame b) {
    tv = loadImage("Images/TV.png");

/*
    String[] cameras = Capture.list();

    if (cameras == null) {
      println("Failed to retrieve the list of available cameras, will try the default...");
      cam = new Capture(b, 320, 240);
    } 
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } 
    else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println(cameras[i]);
      }*/

      // The camera can be initialized directly using an element
      // from the array returned by list():
     // cam = new Capture(b, cameras[1]);
      // Or, the settings can be defined based on the text in the list
      //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

      // Start capturing the images from the camera
    //  cam.start();
  //  }
    
  } 


  void draw() {
 //   if (i == 25) {
 //     if (cam.available() == true) {
 //       cam.read();
 //     }
 //     i = 0;
 //   }
    i++;
    image(tv, 0, height-(tv.height/1.5), tv.width/1.5, tv.height/1.5);
//    image(cam, 25, 585, 165, 107);
    //set(0,0,cam);
  }
}

