

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
            color c = img.pixels[loc];  // Grab the color
            // Calculate a z position as a function of mouseX and pixel brightness
            //img.pixels[loc]
            float z = (ma / float(520)) * brightness(r.nextInt(600));
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

