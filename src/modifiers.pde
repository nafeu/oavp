String[] MODIFIER_FIELDS = {
  "xMod",
  "xrMod",
  "yMod",
  "yrMod",
  "zMod",
  "zrMod",
  "wMod",
  "hMod",
  "lMod",
  "sMod",
  "strokeColorMod",
  "strokeWeightMod",
  "fillColorMod",
  "paramAMod",
  "paramBMod",
  "paramCMod",
  "paramDMod",
  "paramEMod"
};

String[] NON_MODIFIER_FIELDS = {
  "modDelay"
};

String[] MODIFIER_TYPES = {
  "none",
  "spacebar-pulser",
  "spacebar-toggle-hard",
  "spacebar-toggle-soft",
  "spacebar-counter",
  "spacebar-counter-2",
  "spacebar-counter-4",
  "spacebar-counter-8",
  "spacebar-rotator",
  "spacebar-rotator-2",
  "spacebar-rotator-4",
  "spacebar-rotator-8",
  "framecount",
  "level",
  "osc-fast",
  "osc-normal",
  "osc-slow",
  "lows",
  "mid-lows",
  "mid-highs",
  "highs",
  "beat-pulser",
  "beat-toggle-hard",
  "beat-toggle-soft",
  "beat-counter",
  "quantized-pulser",
  "quantized-toggle-hard",
  "quantized-toggle-soft",
  "quantized-counter",
  "mouse-x",
  "mouse-y"
};

/*

entities.getPulser("spacebar-pulser").getValue();
entities.getToggle("spacebar-toggle-hard").getValue();
entities.getInterval("spacebar-toggle-soft").getOneDimensionalData(delayIndex);
entities.getCounter("spacebar-counter").getValue();
entities.getCounter("spacebar-counter-2").getValue();
entities.getCounter("spacebar-counter-4").getValue();
entities.getCounter("spacebar-counter-8").getValue();
entities.getRotator("spacebar-rotator").getX();
entities.getRotator("spacebar-rotator-2").getX();
entities.getRotator("spacebar-rotator-4").getX();
entities.getRotator("spacebar-rotator-8").getX();
frameCount(0.01);
analysis.getLevel();
oscillate(-1, 1, 0.05);
oscillate(-1, 1, 0.01);
oscillate(-1, 1, 0.005);
map(analysis.getSpectrumChunkAvg(0), -20, 20, 0, 1);
map(analysis.getSpectrumChunkAvg(1), -20, 20, 0, 1);
map(analysis.getSpectrumChunkAvg(2), -25, 15, 0, 1);
map(analysis.getSpectrumChunkAvg(3), -30, 10, 0, 1);
entities.getPulser("beat-pulser").getValue();
entities.getToggle("beat-toggle-hard").getValue();
entities.getToggle("beat-toggle-soft").getValue();
entities.getCounter("beat-counter").getValue();
entities.getPulser("quantized-pulser").getValue();
entities.getToggle("quantized-toggle-hard").getValue();
entities.getToggle("quantized-toggle-soft").getValue();
entities.getCounter("quantized-counter").getValue();

*/

void setupPreSketchIntervals() {
  entities.addInterval("spacebar-toggle-soft", 100, 1);
  entities.addInterval("spacebar-pulser", 100, 1);
  entities.addInterval("spacebar-toggle-hard", 100, 1);
  entities.addInterval("spacebar-toggle-soft", 100, 1);
  entities.addInterval("spacebar-counter", 100, 1);
  entities.addInterval("spacebar-counter-2", 100, 1);
  entities.addInterval("spacebar-counter-4", 100, 1);
  entities.addInterval("spacebar-counter-8", 100, 1);
  entities.addInterval("spacebar-rotator", 100, 1);
  entities.addInterval("spacebar-rotator-2", 100, 1);
  entities.addInterval("spacebar-rotator-4", 100, 1);
  entities.addInterval("spacebar-rotator-8", 100, 1);
  entities.addInterval("frame-count-0.01", 100, 1);
  entities.addInterval("analysis-get-level", 100, 1);
  entities.addInterval("oscillate-0.05", 100, 1);
  entities.addInterval("oscillate-0.01", 100, 1);
  entities.addInterval("oscillate-0.005", 100, 1);
  entities.addInterval("analysis-spectrum-chunk-0", 100, 1);
  entities.addInterval("analysis-spectrum-chunk-1", 100, 1);
  entities.addInterval("analysis-spectrum-chunk-2", 100, 1);
  entities.addInterval("analysis-spectrum-chunk-3", 100, 1);
  entities.addInterval("beat-pulser", 100, 1);
  entities.addInterval("beat-toggle-hard", 100, 1);
  entities.addInterval("beat-toggle-soft", 100, 1);
  entities.addInterval("beat-counter", 100, 1);
  entities.addInterval("quantized-pulser", 100, 1);
  entities.addInterval("quantized-toggle-hard", 100, 1);
  entities.addInterval("quantized-toggle-soft", 100, 1);
  entities.addInterval("quantized-counter", 100, 1);
  entities.addInterval("mouse-x", 100, 1);
  entities.addInterval("mouse-y", 100, 1);
}

void updateDefaultIntervals() {
  entities.getInterval("spacebar-pulser").updateRaw(entities.getPulser("spacebar-pulser").getValue());
  entities.getInterval("spacebar-toggle-hard").updateRaw(entities.getToggle("spacebar-toggle-hard").getValue());
  entities.getInterval("spacebar-toggle-soft").updateRaw(entities.getToggle("spacebar-toggle-soft").getValue());
  entities.getInterval("spacebar-counter").updateRaw(entities.getCounter("spacebar-counter").getValue());
  entities.getInterval("spacebar-counter-2").updateRaw(entities.getCounter("spacebar-counter-2").getValue());
  entities.getInterval("spacebar-counter-4").updateRaw(entities.getCounter("spacebar-counter-4").getValue());
  entities.getInterval("spacebar-counter-8").updateRaw(entities.getCounter("spacebar-counter-8").getValue());
  entities.getInterval("spacebar-rotator").updateRaw(entities.getRotator("spacebar-rotator").getX());
  entities.getInterval("spacebar-rotator-2").updateRaw(entities.getRotator("spacebar-rotator-2").getX());
  entities.getInterval("spacebar-rotator-4").updateRaw(entities.getRotator("spacebar-rotator-4").getX());
  entities.getInterval("spacebar-rotator-8").updateRaw(entities.getRotator("spacebar-rotator-8").getX());
  entities.getInterval("frame-count-0.01").updateRaw(frameCount(0.01));
  entities.getInterval("analysis-get-level").updateRaw(analysis.getLevel());
  entities.getInterval("oscillate-0.05").updateRaw(oscillate(-1, 1, 0.05));
  entities.getInterval("oscillate-0.01").updateRaw(oscillate(-1, 1, 0.01));
  entities.getInterval("oscillate-0.005").updateRaw(oscillate(-1, 1, 0.005));
  entities.getInterval("analysis-spectrum-chunk-0").updateRaw(map(analysis.getSpectrumChunkAvg(0), -20, 20, 0, 1));
  entities.getInterval("analysis-spectrum-chunk-1").updateRaw(map(analysis.getSpectrumChunkAvg(1), -20, 20, 0, 1));
  entities.getInterval("analysis-spectrum-chunk-2").updateRaw(map(analysis.getSpectrumChunkAvg(2), -25, 15, 0, 1));
  entities.getInterval("analysis-spectrum-chunk-3").updateRaw(map(analysis.getSpectrumChunkAvg(3), -30, 10, 0, 1));
  entities.getInterval("beat-pulser").updateRaw(entities.getPulser("beat-pulser").getValue());
  entities.getInterval("beat-toggle-hard").updateRaw(entities.getToggle("beat-toggle-hard").getValue());
  entities.getInterval("beat-toggle-soft").updateRaw(entities.getToggle("beat-toggle-soft").getValue());
  entities.getInterval("beat-counter").updateRaw(entities.getCounter("beat-counter").getValue());
  entities.getInterval("quantized-pulser").updateRaw(entities.getPulser("quantized-pulser").getValue());
  entities.getInterval("quantized-toggle-hard").updateRaw(entities.getToggle("quantized-toggle-hard").getValue());
  entities.getInterval("quantized-toggle-soft").updateRaw(entities.getToggle("quantized-toggle-soft").getValue());
  entities.getInterval("quantized-counter").updateRaw(entities.getCounter("quantized-counter").getValue());
  entities.getInterval("mouse-x").updateRaw(normalMouseX);
  entities.getInterval("mouse-y").updateRaw(normalMouseY);
}

public float getMod(String type, int modDelay) {
  float out;

  int delayIndex = abs(modDelay % 100);

  switch(type) {
    case "spacebar-pulser":
      out = entities.getInterval("spacebar-pulser").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-toggle-hard":
      out = entities.getInterval("spacebar-toggle-hard").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-toggle-soft":
      out = entities.getInterval("spacebar-toggle-soft").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-counter":
      out = entities.getInterval("spacebar-counter").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-counter-2":
      out = entities.getInterval("spacebar-counter-2").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-counter-4":
      out = entities.getInterval("spacebar-counter-4").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-counter-8":
      out = entities.getInterval("spacebar-counter-8").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-rotator":
      out = entities.getInterval("spacebar-rotator").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-rotator-2":
      out = entities.getInterval("spacebar-rotator-2").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-rotator-4":
      out = entities.getInterval("spacebar-rotator-4").getOneDimensionalData(delayIndex);
      break;
    case "spacebar-rotator-8":
      out = entities.getInterval("spacebar-rotator-8").getOneDimensionalData(delayIndex);
      break;
    case "framecount":
      out = entities.getInterval("frame-count-0.01").getOneDimensionalData(delayIndex);
      break;
    case "level":
      out = entities.getInterval("analysis-get-level").getOneDimensionalData(delayIndex);
      break;
    case "osc-fast":
      out = entities.getInterval("oscillate-0.05").getOneDimensionalData(delayIndex);
      break;
    case "osc-normal":
      out = entities.getInterval("oscillate-0.01").getOneDimensionalData(delayIndex);
      break;
    case "osc-slow":
      out = entities.getInterval("oscillate-0.005").getOneDimensionalData(delayIndex);
      break;
    case "lows":
      out = entities.getInterval("analysis-spectrum-chunk-0").getOneDimensionalData(delayIndex);
      break;
    case "mid-lows":
      out = entities.getInterval("analysis-spectrum-chunk-1").getOneDimensionalData(delayIndex);
      break;
    case "mid-highs":
      out = entities.getInterval("analysis-spectrum-chunk-2").getOneDimensionalData(delayIndex);
      break;
    case "highs":
      out = entities.getInterval("analysis-spectrum-chunk-3").getOneDimensionalData(delayIndex);
      break;
    case "beat-pulser":
      out = entities.getInterval("beat-pulser").getOneDimensionalData(delayIndex);
      break;
    case "beat-toggle-hard":
      out = entities.getInterval("beat-toggle-hard").getOneDimensionalData(delayIndex);
      break;
    case "beat-toggle-soft":
      out = entities.getInterval("beat-toggle-soft").getOneDimensionalData(delayIndex);
      break;
    case "beat-counter":
      out = entities.getInterval("beat-counter").getOneDimensionalData(delayIndex);
      break;
    case "quantized-pulser":
      out = entities.getInterval("quantized-pulser").getOneDimensionalData(delayIndex);
      break;
    case "quantized-toggle-hard":
      out = entities.getInterval("quantized-toggle-hard").getOneDimensionalData(delayIndex);
      break;
    case "quantized-toggle-soft":
      out = entities.getInterval("quantized-toggle-soft").getOneDimensionalData(delayIndex);
      break;
    case "quantized-counter":
      out = entities.getInterval("quantized-counter").getOneDimensionalData(delayIndex);
      break;
    case "mouse-x":
      out = entities.getInterval("mouse-x").getOneDimensionalData(delayIndex);
      break;
    case "mouse-y":
      out = entities.getInterval("mouse-y").getOneDimensionalData(delayIndex);
      break;
    default:
      out = 1.0;
  }
  return out;
}