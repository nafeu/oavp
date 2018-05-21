public class OavpTracker {
  float value = 0;
  float target = 1;
  float[] payload;
  boolean isDead = false;

  OavpTracker(float duration, Easing easing) {
    start(duration, easing);
  }

  OavpTracker(float duration, Easing easing, float[] payload) {
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