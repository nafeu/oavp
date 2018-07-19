public class OavpEmitter {

  private OavpAnalysis analysis;
  private OavpEntityManager entities;
  private OavpPulser currPulser;
  private OavpInterval currInterval;
  private OavpGridInterval currGridInterval;
  private List currEmissions;
  private float duration = 1;
  private Easing easing = Ani.LINEAR;

  OavpEmitter(OavpAnalysis analysis, OavpEntityManager entities) {
    this.analysis = analysis;
    this.entities = entities;
  }

  public OavpEmitter duration(float duration) {
    this.duration = duration;
    return this;
  }

  public OavpEmitter easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  public OavpEmitter usePulser(String name) {
    currPulser = entities.getPulser(name);
    return this;
  }

  public OavpEmitter useInterval(String name) {
    currInterval = entities.getInterval(name);
    return this;
  }

  public OavpEmitter useGridInterval(String name) {
    currGridInterval = entities.getGridInterval(name);
    return this;
  }

  public OavpEmitter useEmissions(String name) {
    currEmissions = entities.getEmissions(name);
    return this;
  }

  public OavpEmitter emit() {
    currEmissions.add(new OavpEmission(duration, easing));
    return this;
  }

  public OavpEmitter emitIf(boolean trigger) {
    if (trigger) {
      currEmissions.add(new OavpEmission(duration, easing));
    }
    return this;
  }

  public OavpEmitter emitAngles(int count, float angleIncrement, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count];
      for (int i = 0; i < count; i++) {
        payload[i] = i * angleIncrement;
      }
      currEmissions.add(new OavpEmission(duration, easing, payload));
    }
    return this;
  }

  public OavpEmitter emitColorAngles(color inputColor, int count, float angleIncrement, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count + 1];
      for (int i = 0; i < count - 1; i++) {
        payload[i] = i * angleIncrement;
      }
      payload[count] = inputColor;
      currEmissions.add(new OavpEmission(duration, easing, payload));
    }
    return this;
  }

  public OavpEmitter emitRandomAngles(int count, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count];
      for (int i = 0; i < count; i++) {
        payload[i] = random(0, 360);
      }
      currEmissions.add(new OavpEmission(duration, easing, payload));
    }
    return this;
  }

  public OavpEmitter emitRandomColorAngles(color inputColor, int count, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count + 1];
      for (int i = 0; i < count - 1; i++) {
        payload[i] = random(0, 360);
      }
      payload[count] = inputColor;
      currEmissions.add(new OavpEmission(duration, easing, payload));
    }
    return this;
  }

  public OavpEmitter emitColor(color inputColor, boolean trigger) {
    if (trigger) {
      float[] payload = new float[]{ inputColor };
      currEmissions.add(new OavpEmission(duration, easing, payload));
    }
    return this;
  }

  public OavpEmitter emitSpectrum(boolean trigger) {
    if (trigger) {
      float[] payload = new float[analysis.getSpectrum().length];
      for (int i = 0; i < analysis.getSpectrum().length; i++) {
        payload[i] = analysis.getSpectrumVal(i);
      }
      currEmissions.add(new OavpEmission(duration, easing, payload));
    }
    return this;
  }
}
