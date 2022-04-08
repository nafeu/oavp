int modDistance = 100;

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

String[] ITERATION_FIELDS = {
  "xIter",
  "xrIter",
  "yIter",
  "yrIter",
  "zIter",
  "zrIter",
  "wIter",
  "hIter",
  "lIter",
  "sIter",
  "strokeColorIter",
  "strokeWeightIter",
  "fillColorIter",
  "paramAIter",
  "paramBIter",
  "paramCIter",
  "paramDIter",
  "paramEIter"
};

String[] NON_MODIFIER_FIELDS = {
  "modDelay",
  "i"
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
  "sine",
  "square",
  "sawtooth",
  // "lows",
  // "mid-lows",
  // "mid-highs",
  // "highs",
  // "beat-pulser",
  // "beat-toggle-hard",
  // "beat-toggle-soft",
  // "beat-counter",
  // "quantized-pulser",
  // "quantized-toggle-hard",
  // "quantized-toggle-soft",
  // "quantized-counter",
  "mouse-x",
  "mouse-y"
};

void setupPreSketchIntervals() {
  entities.addInterval("spacebar-toggle-soft", modDistance, 1);
  entities.addInterval("spacebar-pulser", modDistance, 1);
  entities.addInterval("spacebar-toggle-hard", modDistance, 1);
  entities.addInterval("spacebar-toggle-soft", modDistance, 1);
  entities.addInterval("spacebar-counter", modDistance, 1);
  entities.addInterval("spacebar-counter-2", modDistance, 1);
  entities.addInterval("spacebar-counter-4", modDistance, 1);
  entities.addInterval("spacebar-counter-8", modDistance, 1);
  entities.addInterval("spacebar-rotator", modDistance, 1);
  entities.addInterval("spacebar-rotator-2", modDistance, 1);
  entities.addInterval("spacebar-rotator-4", modDistance, 1);
  entities.addInterval("spacebar-rotator-8", modDistance, 1);
  entities.addInterval("frame-count-0.01", modDistance, 1);
  entities.addInterval("analysis-get-level", modDistance, 1);
  entities.addInterval("oscillate-0.05", modDistance, 1);
  entities.addInterval("oscillate-0.01", modDistance, 1);
  entities.addInterval("oscillate-0.005", modDistance, 1);
  entities.addInterval("sine", modDistance, 1);
  entities.addInterval("square", modDistance, 1);
  entities.addInterval("sawtooth", modDistance, 1);
  // TODO: Re-enable uncommon modifiers
  // entities.addInterval("analysis-spectrum-chunk-0", 100, 1);
  // entities.addInterval("analysis-spectrum-chunk-1", 100, 1);
  // entities.addInterval("analysis-spectrum-chunk-2", 100, 1);
  // entities.addInterval("analysis-spectrum-chunk-3", 100, 1);
  // entities.addInterval("beat-pulser", 100, 1);
  // entities.addInterval("beat-toggle-hard", 100, 1);
  // entities.addInterval("beat-toggle-soft", 100, 1);
  // entities.addInterval("beat-counter", 100, 1);
  // entities.addInterval("quantized-pulser", 100, 1);
  // entities.addInterval("quantized-toggle-hard", 100, 1);
  // entities.addInterval("quantized-toggle-soft", 100, 1);
  // entities.addInterval("quantized-counter", 100, 1);
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
  entities.getInterval("sine").updateRaw(modifierSine(globalSpeed));
  entities.getInterval("square").updateRaw(modifierSquare(globalSpeed));
  entities.getInterval("sawtooth").updateRaw(modifierSawtooth(globalSpeed));
  // TODO: Re-enable uncommon modifiers
  // entities.getInterval("analysis-spectrum-chunk-0").updateRaw(map(analysis.getSpectrumChunkAvg(0), -20, 20, 0, 1));
  // entities.getInterval("analysis-spectrum-chunk-1").updateRaw(map(analysis.getSpectrumChunkAvg(1), -20, 20, 0, 1));
  // entities.getInterval("analysis-spectrum-chunk-2").updateRaw(map(analysis.getSpectrumChunkAvg(2), -25, 15, 0, 1));
  // entities.getInterval("analysis-spectrum-chunk-3").updateRaw(map(analysis.getSpectrumChunkAvg(3), -30, 10, 0, 1));
  // entities.getInterval("beat-pulser").updateRaw(entities.getPulser("beat-pulser").getValue());
  // entities.getInterval("beat-toggle-hard").updateRaw(entities.getToggle("beat-toggle-hard").getValue());
  // entities.getInterval("beat-toggle-soft").updateRaw(entities.getToggle("beat-toggle-soft").getValue());
  // entities.getInterval("beat-counter").updateRaw(entities.getCounter("beat-counter").getValue());
  // entities.getInterval("quantized-pulser").updateRaw(entities.getPulser("quantized-pulser").getValue());
  // entities.getInterval("quantized-toggle-hard").updateRaw(entities.getToggle("quantized-toggle-hard").getValue());
  // entities.getInterval("quantized-toggle-soft").updateRaw(entities.getToggle("quantized-toggle-soft").getValue());
  // entities.getInterval("quantized-counter").updateRaw(entities.getCounter("quantized-counter").getValue());
  entities.getInterval("mouse-x").updateRaw(normalMouseX);
  entities.getInterval("mouse-y").updateRaw(normalMouseY);
}

public float getMod(String type, int modDelay) {
  float out;

  int delayIndex = abs(modDelay % modDistance);

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
    case "sine":
      out = entities.getInterval("sine").getOneDimensionalData(delayIndex);
      break;
    case "square":
      out = entities.getInterval("square").getOneDimensionalData(delayIndex);
      break;
    case "sawtooth":
      out = entities.getInterval("sawtooth").getOneDimensionalData(delayIndex);
      break;
    // TODO: Re-enable uncommon modifiers
    // case "lows":
    //   out = entities.getInterval("analysis-spectrum-chunk-0").getOneDimensionalData(delayIndex);
    //   break;
    // case "mid-lows":
    //   out = entities.getInterval("analysis-spectrum-chunk-1").getOneDimensionalData(delayIndex);
    //   break;
    // case "mid-highs":
    //   out = entities.getInterval("analysis-spectrum-chunk-2").getOneDimensionalData(delayIndex);
    //   break;
    // case "highs":
    //   out = entities.getInterval("analysis-spectrum-chunk-3").getOneDimensionalData(delayIndex);
    //   break;
    // case "beat-pulser":
    //   out = entities.getInterval("beat-pulser").getOneDimensionalData(delayIndex);
    //   break;
    // case "beat-toggle-hard":
    //   out = entities.getInterval("beat-toggle-hard").getOneDimensionalData(delayIndex);
    //   break;
    // case "beat-toggle-soft":
    //   out = entities.getInterval("beat-toggle-soft").getOneDimensionalData(delayIndex);
    //   break;
    // case "beat-counter":
    //   out = entities.getInterval("beat-counter").getOneDimensionalData(delayIndex);
    //   break;
    // case "quantized-pulser":
    //   out = entities.getInterval("quantized-pulser").getOneDimensionalData(delayIndex);
    //   break;
    // case "quantized-toggle-hard":
    //   out = entities.getInterval("quantized-toggle-hard").getOneDimensionalData(delayIndex);
    //   break;
    // case "quantized-toggle-soft":
    //   out = entities.getInterval("quantized-toggle-soft").getOneDimensionalData(delayIndex);
    //   break;
    // case "quantized-counter":
    //   out = entities.getInterval("quantized-counter").getOneDimensionalData(delayIndex);
    //   break;
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

String[] ITERATION_FUNCS = {
  "none",
  "fib 20",
  "sin(x)",
  "sqrt(x)",
  "2x",
  "x/2",
  "x/3",
  "x/4",
  "x*(x/10)",
  "1/x",
  "x^2",
  "mod 3",
  "floor(x/3)",
  "mod 5",
  "floor(x/5)",
  "mod 10",
  "floor(x/10)",
  "mod 25",
  "floor(x/25)",
  "random 100"
};

int[] FIRST_TWENTY_FIB = {
  0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89,
  144, 233, 377, 610, 987, 1597, 2584, 4181
};

float[] getRandomNumbers(int n) {
  float[] output = new float[n];

  for (int i = 0; i < n; i++) {
    output[i] = random(1.0);
  }

  return output;
}

float[] RANDOM_HUNDRED = getRandomNumbers(100);

public float getFunc(String type, int iteration) {
  float out;

  switch(type) {
    case "fib 20":
      out = float(FIRST_TWENTY_FIB[iteration % 20]);
      break;
    case "sin(x)":
      out = sin(iteration);
      break;
    case "sqrt(x)":
      out = sqrt(iteration);
      break;
    case "2x":
      out = 2 * iteration;
      break;
    case "x/2":
      out = iteration/2;
      break;
    case "x/3":
      out = iteration/3;
      break;
    case "x/4":
      out = iteration/4;
      break;
    case "x*(x/10)":
      out = iteration * (iteration / 10);
      break;
    case "1/x":
      out = iteration > 0 ? 1/iteration : 0;
      break;
    case "x^2":
      out = iteration * iteration;
      break;
    case "mod 3":
      out = iteration % 3;
      break;
    case "floor(x/3)":
      out = floor(iteration/3);
      break;
    case "mod 5":
      out = iteration % 5;
      break;
    case "floor(x/5)":
      out = floor(iteration/5);
      break;
    case "mod 10":
      out = iteration % 10;
      break;
    case "floor(x/10)":
      out = floor(iteration/10);
      break;
    case "mod 25":
      out = iteration % 25;
      break;
    case "floor(x/25)":
      out = floor(iteration/25);
      break;
    case "random 100":
      out = RANDOM_HUNDRED[iteration % 100];
      break;
    default:
      out = iteration;
  }
  return out;
}