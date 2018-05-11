public class OavpTracker {
  float start;
  float value;
  float target;
  float easing;
  float[] payload;
  boolean isDead = false;

  OavpTracker(float start, float end, float easing) {
    this.start = start;
    this.value = start;
    this.target = end;
    this.easing = easing;
  }

  OavpTracker(float start, float end, float easing, float[] payload) {
    this.start = start;
    this.value = start;
    this.target = end;
    this.easing = easing;
    this.payload = payload;
  }

  void update() {
    float dt = target - value;
    value += dt * easing;
    if (abs(dt) < abs(target - start) * 0.1) {
      isDead = true;
    }
  }
}