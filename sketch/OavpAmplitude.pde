public class OavpAmplitude {
  float easing;
  float min;
  float max;
  float value;

  OavpAmplitude(float min, float max, float easing) {
    this.min = min;
    this.max = max;
    this.easing = easing;
  }

  float getValue() {
    return value;
  }

  void setValue(float value) {
    this.value = value;
  }

  void update(OavpData oavpData) {
    if (oavpData.isBeatOnset()) {
      value = max;
    } else {
      float dv = value - min;
      value -= dv * easing;
    }
    if (value <= min) {
      value = min;
    }
  }
}