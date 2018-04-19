void avizBarSpectrum(float x, float y, float w, float h, float[] data, AvizData avizData) {
  rect(x, y, w, h);
  pushMatrix();
  translate(x, y);
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize; i++) {
    float displayAmplitude = avizData.getDisplayAmplitude(data[i]);
    rect(i * (w / avgSize), h, (w / avgSize), -h * displayAmplitude);
  }
  popMatrix();
}

void avizLineSpectrum(float x, float y, float w, float h, float[] data, AvizData avizData) {
  rect(x, y, w, h);
  pushMatrix();
  translate(x, y);
  beginShape(LINES);
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize - 1; i++) {
    vertex(i * (w / avgSize), -h * avizData.getDisplayAmplitude(data[i]) + h);
    vertex((i + 1) * (w / avgSize), -h * avizData.getDisplayAmplitude(data[i + 1]) + h);
  }
  endShape();
  popMatrix();
}