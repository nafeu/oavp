public class OavpAmplitude {
  float value = 0;
  float duration;
  Easing easing;
  Ani ani;

  OavpAmplitude(float duration, Easing easing) {
    this.duration = duration;
    this.easing = easing;
  }

  float getValue() {
    return value;
  }

  void update(Boolean trigger) {
    if (trigger) {
      value = 1;
      ani = Ani.to(this, duration, "value", 0, easing);
    }
  }
}