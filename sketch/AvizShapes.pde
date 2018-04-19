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

void avizLineWaveform(float x, float y, float w, float h, AvizData avizData) {
  rect(x, y, w, h);
  pushMatrix();
  translate(x, y);
  int audioBufferSize = avizData.getBufferSize();
  for (int i = 0; i < audioBufferSize - 1; i++) {
    float x1 = map( i, 0, audioBufferSize, 0, w);
    float x2 = map( i + 1, 0, audioBufferSize, 0, w);
    float leftLevelScale = (h / 4);
    float rightLevelScale = (h / 4) * 3;
    float waveformScale = (h / 4);
    line(x1, leftLevelScale + avizData.getLeftBuffer(i) * waveformScale, x2, leftLevelScale + avizData.getLeftBuffer(i + 1) * waveformScale);
    line(x1, rightLevelScale + avizData.getRightBuffer(i) * waveformScale, x2, rightLevelScale + avizData.getRightBuffer(i + 1) * waveformScale);
  }
  endShape();
  popMatrix();
}

void avizBarLevels(float x, float y, float w, float h, AvizData avizData) {
  rect(x, y, w, h);
  pushMatrix();
  translate(x, y);
  rect(0, 0, avizData.getLeftLevel() * w, h / 2);
  rect(0, h / 2, avizData.getRightLevel() * w, h / 2);
  endShape();
  popMatrix();
}