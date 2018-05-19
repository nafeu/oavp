public class OavpTracker {
  float value;
  float target;
  float[] payload;
  boolean isDead = false;

  OavpTracker(float start, float end, float duration, Easing easing) {
    this.value = start;
    this.target = end;
    start(duration, easing);
  }

  OavpTracker(float start, float end, float duration, Easing easing, float[] payload) {
    this.value = start;
    this.target = end;
    this.payload = payload;
    start(duration, easing);
  }

  void start(float duration, Easing easing) {
    Ani.to(this, duration, "value", target, easing);
  }

  void update() {
    if (value == target) {
      isDead = true;
    }
  }
}