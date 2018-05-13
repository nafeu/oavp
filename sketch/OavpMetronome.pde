public class OavpMetronome {
  int lastBeat = 0;
  int startingPoint = 0;
  int bpm;
  int beatCount = 0;
  int denominator = 4;
  boolean soundOn = false;
  boolean isBeat;
  AudioPlayer tack;
  AudioPlayer tick;
  OavpMetronome(Minim minim, String tack, String tick, int bpm){
    this.bpm = bpm;
    this.isBeat = true;
    this.tack = minim.loadFile(tack, 256);
    this.tick = minim.loadFile(tick, 256);
  }

  void update() {
    int currBeat = floor((millis() - startingPoint) / (60000 / bpm));
    if (currBeat != lastBeat) {
      isBeat = true;
      if (soundOn) {
        playSound();
      }
      beatCount++;
    } else {
      isBeat = false;
    }
    lastBeat = currBeat;
  }

  void playSound() {
    if (beatCount % denominator == 0) {
      tack.play(1);
    } else {
      tick.play(1);
    }
  }

  void reset() {
    startingPoint = millis();
    beatCount = 0;
  }

  void setBpm(int bpm) {
    this.bpm = bpm;
    startingPoint = millis();
    beatCount = 0;
  }

  void toggleSound() {
    soundOn = !soundOn;
  }
}