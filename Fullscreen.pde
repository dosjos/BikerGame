import java.awt.Dimension;
import java.awt.Toolkit;
import processing.core.PApplet;

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
 
