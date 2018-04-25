float filterByThreshold(float dataPoint, float threshold, float a, float b) {
  if (dataPoint >= threshold) {
    return b;
  }
  return a;
}

float filterByCondition(boolean condition, float a, float b) {
  if (condition) {
    return b;
  }
  return a;
}