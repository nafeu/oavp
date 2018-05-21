public class OavpEmitter {

  OavpData oavpData;
  OavpEntityManager entities;
  OavpAmplitude currAmplitude;
  OavpInterval currInterval;
  OavpGridInterval currGridInterval;
  List currTrackers;
  OavpRhythm currRhythm;

  OavpEmitter(OavpData data, OavpEntityManager entities) {
    this.oavpData = data;
    this.entities = entities;
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

  OavpEmitter useRhythm(String name) {
    currRhythm = entities.getRhythm(name);
    return this;
  }


  OavpEmitter emitBeat(float duration, Easing easing) {
    if (oavpData.isBeatOnset()) {
      currTrackers.add(new OavpTracker(duration, easing));
    }
    return this;
  }

  OavpEmitter emitBeatAngles(float duration, Easing easing, int count) {
    if (oavpData.isBeatOnset()) {
      float[] payload = new float[count];
      for (int i = 0; i < count; i++) {
        payload[i] = random(0, 360);
      }
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }

  OavpEmitter emitFrameDelayed(float duration, Easing easing, int frameDelay) {
    if (frameCount % frameDelay == 0) {
      currTrackers.add(new OavpTracker(duration, easing));
    }
    return this;
  }

  OavpEmitter emitRhythm(float duration, Easing easing) {
    if (currRhythm.onRhythm()) {
      currTrackers.add(new OavpTracker(duration, easing));
    }
    return this;
  }

  OavpEmitter emitRhythmAngles(float duration, Easing easing, int count) {
    if (currRhythm.onRhythm()) {
      float[] payload = new float[count];
      for (int i = 0; i < count; i++) {
        payload[i] = random(0, 360);
      }
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }

  OavpEmitter emitRhythmSpectrum(float duration, Easing easing) {
    float[] payload = new float[oavpData.getSpectrum().length];
    for (int i = 0; i < oavpData.getSpectrum().length; i++) {
      payload[i] = oavpData.getSpectrumVal(i);
    }
    if (currRhythm.onRhythm()) {
      currTrackers.add(new OavpTracker(duration, easing, payload));
    }
    return this;
  }
}
