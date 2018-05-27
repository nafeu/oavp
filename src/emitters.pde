public class OavpEmitter {

  OavpAnalysis analysis;
  OavpEntityManager entities;
  OavpAmplitude currAmplitude;
  OavpInterval currInterval;
  OavpGridInterval currGridInterval;
  List currTrackers;
  float duration = 1;
  Easing easing = Ani.LINEAR;

  OavpEmitter(OavpAnalysis analysis, OavpEntityManager entities) {
    this.analysis = analysis;
    this.entities = entities;
  }

  OavpEmitter duration(float duration) {
    this.duration = duration;
    return this;
  }

  OavpEmitter easing(Easing easing) {
    this.easing = easing;
    return this;
  }

  OavpEmitter useAmplitude(String name) {
    currAmplitude = entities.getAmplitude(name);
    return this;
  }

  OavpEmitter useInterval(String name) {
    currInterval = entities.getInterval(name);
    return this;
  }

  OavpEmitter useGridInterval(String name) {
    currGridInterval = entities.getGridInterval(name);
    return this;
  }

  OavpEmitter useTrackers(String name) {
    currTrackers = entities.getTrackers(name);
    return this;
  }

  OavpEmitter emit(boolean trigger) {
    if (trigger) {
      currTrackers.add(new OavpTracker(duration, easing));
    }
    return this;
  }

  OavpEmitter emitAngles(int count, float angleIncrement, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count];
      for (int i = 0; i < count; i++) {
        payload[i] = i * angleIncrement;
      }
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }

  OavpEmitter emitColorAngles(color inputColor, int count, float angleIncrement, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count + 1];
      for (int i = 0; i < count - 1; i++) {
        payload[i] = i * angleIncrement;
      }
      payload[count] = inputColor;
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }

  OavpEmitter emitRandomAngles(int count, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count];
      for (int i = 0; i < count; i++) {
        payload[i] = random(0, 360);
      }
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }

  OavpEmitter emitRandomColorAngles(color inputColor, int count, boolean trigger) {
    if (trigger) {
      float[] payload = new float[count + 1];
      for (int i = 0; i < count - 1; i++) {
        payload[i] = random(0, 360);
      }
      payload[count] = inputColor;
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }


  OavpEmitter emitColor(color inputColor, boolean trigger) {
    if (trigger) {
      float[] payload = new float[]{ inputColor };
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }

  OavpEmitter emitSpectrum(boolean trigger) {
    float[] payload = new float[analysis.getSpectrum().length];
    for (int i = 0; i < analysis.getSpectrum().length; i++) {
      payload[i] = analysis.getSpectrumVal(i);
    }
    if (trigger) {
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }
}
