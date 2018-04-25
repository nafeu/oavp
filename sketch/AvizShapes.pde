class AvizShapes {
  public Spectrum spectrum;
  public Waveform waveform;
  public Levels levels;
  public Beats beats;

  AvizShapes(AvizData data) {
    spectrum = new Spectrum(avizData);
    waveform = new Waveform(avizData);
    levels = new Levels(avizData);
    beats = new Beats(avizData);
  }

  class Spectrum {
    AvizData avizData;

    Spectrum(AvizData data) {
      avizData = data;
    }

    void bars(float x, float y, float w, float h) {
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

    void wire(float x, float y, float w, float h) {
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

    void radialBars(float x, float y, float h, float rangeStart, float rangeEnd, float rotation) {
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

    void radialWire(float x, float y, float rangeStart, float rangeEnd, float rotation) {
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
  }

  class Waveform {
    AvizData avizData;

    Waveform(AvizData data) {
      avizData = data;
    }

    void wire(float x, float y, float w, float h) {
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

    void radialWire(float x, float y, float h, float rangeStart, float rangeEnd, float rotation) {
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
  }

  class Levels {
    AvizData avizData;

    Levels(AvizData data) {
      avizData = data;
    }

    void bars(float x, float y, float w, float h) {
      pushMatrix();
      translate(x, y);
      float rawLeftLevel = avizData.getLeftLevel();
      float rawRightLevel = avizData.getRightLevel();
      rect(0, 0, avizData.scaleLeftLevel(rawLeftLevel) * w, h / 2);
      rect(0, h / 2, avizData.scaleRightLevel(rawRightLevel) * w, h / 2);
      endShape();
      popMatrix();
    }

    void intervalBars(float x, float y, float w, float h, float scale, AvizInterval interval) {
      pushMatrix();
      translate(x, y);
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        rect(i * (w / intervalSize), h, (w / intervalSize), -avizData.scaleLeftLevel(interval.getIntervalData(i)[0]) * scale);
      }
      popMatrix();
    }

    void cube(float x, float y, float scale, float rotation) {
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
  }

  class Beats {
    AvizData avizData;
    float amplitude;

    Beats(AvizData data) {
      avizData = data;
      ellipseMode(RADIUS);
    }

    void circle(float x, float y, float minRadius, float maxRadius) {
      pushMatrix();
      translate(x, y);
      if ( avizData.isBeatOnset() ) {
        amplitude = maxRadius;
      } else {
        float da = amplitude - minRadius;
        amplitude -= da * 0.08;
      }
      if (amplitude <= minRadius) {
        amplitude = minRadius;
      }
      ellipse(0, 0, amplitude, amplitude);
      popMatrix();
    }

    void splash(float x, float y, float minRadius, float maxRadius, AvizInterval interval) {
      pushMatrix();
      translate(x, y);
      pushStyle();
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        float position = map(i, 0, intervalSize, minRadius, maxRadius);
        if (interval.getIntervalData(i)[0] == 1.0) {
          ellipse(0, 0, position, position);
        }
      }
      popStyle();
      popMatrix();
    }

  }

  void svg(float x, float y, float scaleFactor, float origSize, PShape shape) {
    pushMatrix();
    translate(x - ((origSize * scaleFactor) / 2), y - ((origSize * scaleFactor) / 2));
    scale(scaleFactor);
    shape(shape, 0, 0);
    popMatrix();
  }
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