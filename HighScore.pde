public class HighScore {
  BufferedReader reader;
  String line;
  ArrayList<String> scores = new ArrayList<String>();


  public HighScore() {
    try {
      while ( (line = reader.readLine ()) != null) {
        scores.add(line);
      }
    }
    catch(Exception e) {
    }
    Collections.sort(scores);
  }


  public void addScore(double s) {
    scores.add(""+s); 
    Collections.sort(scores);
  }
}

