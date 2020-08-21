float spacebarModTypeValue = 1.0;

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
  "sizeMod",
  "strokeColorMod",
  "strokeWeightMod",
  "fillColorMod",
  "paramAMod",
  "paramBMod",
  "paramCMod",
  "paramDMod",
  "paramEMod"
};

String[] MODIFIER_TYPES = {
  "none",
  "spacebar",
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
};

public float getMod(String type) {
  float out;
  switch(type) {
    case "spacebar":
      out = spacebarModTypeValue;
      break;
    case "framecount":
      out = frameCount(0.01);
      break;
    case "level":
      out = analysis.getLevel();
      break;
    case "osc-fast":
      out = oscillate(-1, 1, 0.05);
      break;
    case "osc-normal":
      out = oscillate(-1, 1, 0.01);
      break;
    case "osc-slow":
      out = oscillate(-1, 1, 0.005);
      break;
    case "lows":
      out = map(analysis.getSpectrumChunkAvg(0), -20, 20, 0, 1);
      break;
    case "mid-lows":
      out = map(analysis.getSpectrumChunkAvg(1), -20, 20, 0, 1);
      break;
    case "mid-highs":
      out = map(analysis.getSpectrumChunkAvg(2), -25, 15, 0, 1);
      break;
    case "highs":
      out = map(analysis.getSpectrumChunkAvg(3), -30, 10, 0, 1);
      break;
    case "beat-pulser":
      out = entities.getPulser("beat-pulser").getValue();
      break;
    case "beat-toggle-hard":
      out = entities.getToggle("beat-toggle-hard").getValue();
      break;
    case "beat-toggle-soft":
      out = entities.getToggle("beat-toggle-soft").getValue();
      break;
    case "beat-counter":
      out = entities.getCounter("beat-counter").getValue();
      break;
    case "quantized-pulser":
      out = entities.getPulser("quantized-pulser").getValue();
      break;
    case "quantized-toggle-hard":
      out = entities.getToggle("quantized-toggle-hard").getValue();
      break;
    case "quantized-toggle-soft":
      out = entities.getToggle("quantized-toggle-soft").getValue();
      break;
    case "quantized-counter":
      out = entities.getCounter("quantized-counter").getValue();
      break;
    default:
      out = 0;
  }
  return out;
}