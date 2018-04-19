void avizBarSpectrum(float x, float y, float w, float h, AvizData avizData) {
  rect(x, y, w, h);
  pushMatrix();
  translate(x, y);
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize; i++) {
    float rawAmplitude = avizData.getSpectrumData(i);
    float displayAmplitude = avizData.getDisplayAmplitude(rawAmplitude);
    rect(i * (w / avgSize), h, (w / avgSize), -h * displayAmplitude);
  }
  popMatrix();
}

void avizLineSpectrum(float x, float y, float w, float h, AvizData avizData) {
  rect(x, y, w, h);
  pushMatrix();
  translate(x, y);
  beginShape(LINES);
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize - 1; i++) {
    float rawAmplitudeA = avizData.getSpectrumData(i);
    float rawAmplitudeB = avizData.getSpectrumData(i + 1);
    vertex(i * (w / avgSize), -h * avizData.getDisplayAmplitude(rawAmplitudeA) + h);
    vertex((i + 1) * (w / avgSize), -h * avizData.getDisplayAmplitude(rawAmplitudeB) + h);
  }
  endShape();
  popMatrix();
}