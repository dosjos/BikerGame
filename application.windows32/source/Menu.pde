public class Menu
{
  PFont head = createFont("Algerian", 92);
  PFont text = createFont("Algerian", 48);
 
 public void draw(){
  textFont(head);
  fill(#FFFFFF);
  text("Biker Game", 350.0, 100);
  textFont(text);
  text("    Sykkle så langt du kan,", 250, 200);
  text("        pass deg for hindere", 250, 250);
  text("     Knus isfiender med den ",250, 300);
  text("  supersoniske ringeklokken,", 250, 350);
  text("eller slukk brennende vampyrer.", 220, 400);
  text("Brenn busker og smelt isfiender",220,470);
  text("      med brennhete flammer", 250, 520);
  
    text("Ring med bjellen for å starte", 250, 600);
 } 
  
  
}
