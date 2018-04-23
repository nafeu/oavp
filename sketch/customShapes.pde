void avizBarSpectrum(float x, float y, float w, float h, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize; i++) {
    float rawAmplitude = avizData.getSpectrumVal(i);
    float displayAmplitude = avizData.scaleSpectrumVal(rawAmplitude);
    rect(i * (w / avgSize), h, (w / avgSize), -h * displayAmplitude);
  }
  popMatrix();
}

void avizLineSpectrum(float x, float y, float w, float h, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  beginShape(LINES);
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize - 1; i++) {
    float rawSpectrumValA = avizData.getSpectrumVal(i);
    float rawSpectrumValB = avizData.getSpectrumVal(i + 1);
    vertex(i * (w / avgSize), -h * avizData.scaleSpectrumVal(rawSpectrumValA) + h);
    vertex((i + 1) * (w / avgSize), -h * avizData.scaleSpectrumVal(rawSpectrumValB) + h);
  }
  endShape();
  popMatrix();
}

void avizLineWaveform(float x, float y, float w, float h, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  int audioBufferSize = avizData.getBufferSize();
  for (int i = 0; i < audioBufferSize - 1; i++) {
    float x1 = map( i, 0, audioBufferSize, 0, w);
    float x2 = map( i + 1, 0, audioBufferSize, 0, w);
    float leftBufferScale = (h / 4);
    float rightBufferScale = (h / 4) * 3;
    float waveformScale = (h / 4);
    line(x1, leftBufferScale + avizData.getLeftBuffer(i) * waveformScale, x2, leftBufferScale + avizData.getLeftBuffer(i + 1) * waveformScale);
    line(x1, rightBufferScale + avizData.getRightBuffer(i) * waveformScale, x2, rightBufferScale + avizData.getRightBuffer(i + 1) * waveformScale);
  }
  endShape();
  popMatrix();
}

void avizBarLevels(float x, float y, float w, float h, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  float rawLeftLevel = avizData.getLeftLevel();
  float rawRightLevel = avizData.getRightLevel();
  rect(0, 0, avizData.scaleLeftLevel(rawLeftLevel) * w, h / 2);
  rect(0, h / 2, avizData.scaleRightLevel(rawRightLevel) * w, h / 2);
  endShape();
  popMatrix();
}

void avizRotatingBox(float x, float y, float scale, float rotation, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  rotateY(radians(rotation));
  rotateX(radians(rotation));
  float rawLeftLevel = avizData.getLeftLevel();
  float rawRightLevel = avizData.getRightLevel();
  float boxLevel = ((avizData.scaleLeftLevel(rawLeftLevel) + avizData.scaleRightLevel(rawRightLevel)) / 2) * scale;
  box(boxLevel, boxLevel, boxLevel);
  popMatrix();
}

void avizLogo(float x, float y, float scaleFactor, int origSize, PShape shape) {
  pushMatrix();
  translate(x - ((origSize / 2) * scaleFactor), y - ((origSize / 2) * scaleFactor));
  scale(scaleFactor);
  shape(shape, 0, 0);
  popMatrix();
}

void avizCircleBarSpectrum(float x, float y, float h, float rangeStart, float rangeEnd, float rotation, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  beginShape();
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize; i++) {
    float angle = map(i, 0, avgSize, 0, 360) - rotation;
    float r = map(avizData.getSpectrumVal(i), 0, 256, rangeStart, rangeEnd);
    float x1 = h * cos(radians(angle));
    float y1 = h * sin(radians(angle));
    float x2 = r * cos(radians(angle));
    float y2 = r * sin(radians(angle));
    line(x1, y1, x2, y2);
  }
  endShape();
  popMatrix();
}

void avizCircleLineSpectrum(float x, float y, float rangeStart, float rangeEnd, float rotation, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  beginShape(LINES);
  int avgSize = avizData.getAvgSize();
  for (int i = 0; i < avgSize - 1; i++) {
    float angleA = map(i, 0, avgSize, 0, 360) - rotation;
    float rA = map(avizData.getSpectrumVal(i), 0, 256, rangeStart, rangeEnd);
    float xA = rA * cos(radians(angleA));
    float yA = rA * sin(radians(angleA));
    float angleB = map(i + 1, 0, avgSize, 0, 360) - rotation;
    float rB = map(avizData.getSpectrumVal(i + 1), 0, 256, rangeStart, rangeEnd);
    float xB = rB * cos(radians(angleB));
    float yB = rB * sin(radians(angleB));
    vertex(xA, yA);
    vertex(xB, yB);
  }
  endShape();
  popMatrix();
}

// TODO: Add right buffer support
void avizCircleLineWaveform(float x, float y, float h, float rangeStart, float rangeEnd, float rotation, AvizData avizData) {
  pushMatrix();
  translate(x, y);
  beginShape(LINES);
  int audioBufferSize = avizData.getBufferSize();
  for (int i = 0; i < audioBufferSize - 1; i++) {
    float angleA = map(i, 0, audioBufferSize, 0, 360) - rotation;
    float rA = h + map(avizData.getLeftBuffer(i), -1, 1, rangeStart, rangeEnd);
    float xA = rA * cos(radians(angleA));
    float yA = rA * sin(radians(angleA));

    float angleB = map(i + 1, 0, audioBufferSize, 0, 360) - rotation;
    float rB = h + map(avizData.getLeftBuffer(i + 1), -1, 1, rangeStart, rangeEnd);
    float xB = rB * cos(radians(angleB));
    float yB = rB * sin(radians(angleB));
    vertex(xA, yA);
    vertex(xB, yB);
  }
  endShape();
  popMatrix();
}

/*

Ideas:

- Circular Waveform
- Circular Explosions
  - circle grows from center until going off screen
- Waveform explosions
  - waveform circle of the waveform expands until off screen
- Random

*/