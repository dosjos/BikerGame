public class Menu
{
  PFont head = createFont("Algerian", 92);
  PFont text = createFont("Algerian", 48);
 
 public void draw(){
  textFont(head);
  text("Biker Game", 350.0, 100);
  textFont(text);
  text("    Sykkle så langt du kan,", 250, 250);
  text("        pass deg for hindre", 250, 300);
  text("     Knus isfiender med den ",250, 350);
  text("  supersoniske ringeklokken,", 250, 400);
  text("    Brenn vampyrer og busker",250,450);
  text("      med brennhete flammer", 250, 500);
  
    text("Ring med bjellen for å starte", 250, 600);
 } 
  
  
}
