public class OavpRhythm {
  AudioOutput out;
  BeatDetect beat;
  boolean isPlaying;
  float rhythm;
  Minim minim;

  OavpRhythm(Minim minim, float tempo, float rhythm) {
    this.minim = minim;
    this.rhythm = rhythm;
    beat = new BeatDetect();
    beat.setSensitivity(100);
    start(tempo);
  }

  void start(float tempo) {
    out = minim.getLineOut();
    out.setTempo( tempo );
    out.pauseNotes();
    for (int i = 0; i < 400; ++i) {
      out.playNote(i * rhythm, 0.25, "C3");
    }
    out.resumeNotes();
    isPlaying = true;
    out.mute();
  }

  void update() {
    beat.detect(out.mix);
  }

  void toggleNotes() {
    if (isPlaying) {
      out.pauseNotes();
      isPlaying = false;
    } else {
      out.resumeNotes();
      isPlaying = true;
    }
  }

  void setTempo(float tempo) {
    out = null;
    start(tempo);
  }

  boolean onRhythm() {
    return beat.isOnset();
  }

  void toggleMute() {
    if (out.isMuted()) {
      out.unmute();
    } else {
      out.mute();
    }
  }
}