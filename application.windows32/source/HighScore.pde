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
    fill(#FFFFFF);
    text("High Score", 1080, 80);
    for (int i = 0; i < scores.size() && i < 10; i++) {
      if (lastHighscore-1 == i) {
        fill(#FF0000);
      }
      else {
        fill(#FFFFFF);
      }
      text(""+(i+1) + ". " + scores.get(i), 1090, 120 + (40*(1+i)) );
    }
  }
}

