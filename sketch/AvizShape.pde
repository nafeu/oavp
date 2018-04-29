class AvizShape {
  public Spectrum spectrum;
  public Waveform waveform;
  public Levels levels;
  public Beats beats;
  public AvizPosition cursor;

  AvizShape(AvizData data) {
    spectrum = new Spectrum(avizData);
    waveform = new Waveform(avizData);
    levels = new Levels(avizData);
    beats = new Beats(avizData);
  }

  AvizShape(AvizData data, AvizPosition cursor) {
    spectrum = new Spectrum(avizData);
    waveform = new Waveform(avizData);
    levels = new Levels(avizData);
    beats = new Beats(avizData);
    this.cursor = cursor;
  }

  void attach(AvizPosition cursor) {
    this.cursor = cursor;
  }

  AvizShape create() {
    pushMatrix();
    return this;
  }

  AvizShape center() {
    translate(cursor.getCenteredX(), 0);
    return this;
  }

  AvizShape middle() {
    translate(0, cursor.getCenteredY());
    return this;
  }

  AvizShape left() {
    translate(cursor.getScaledX(), 0);
    return this;
  }

  AvizShape right() {
    translate(cursor.getScaledX() + cursor.scale, 0);
    return this;
  }

  AvizShape top() {
    translate(0, cursor.getScaledY());
    return this;
  }

  AvizShape bottom() {
    translate(0, cursor.getScaledY() + cursor.scale);
    return this;
  }

  AvizShape rotate(float x) {
    rotateX(radians(x));
    return this;
  }

  AvizShape rotate(float x, float y) {
    rotateX(radians(x));
    rotateY(radians(y));
    return this;
  }

  AvizShape next() {
    popMatrix();
    pushMatrix();
    return this;
  }

  AvizShape create(float x, float y) {
    pushMatrix();
    translate(x, y);
    return this;
  }

  AvizShape create(float x, float y, float rotationX, float rotationY) {
    pushMatrix();
    translate(x, y);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    return this;
  }

  AvizShape create(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    return this;
  }

  AvizShape create(float x, float y, float z, float rotationX, float rotationY, float rotationZ) {
    pushMatrix();
    translate(x, y, z);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    rotateZ(radians(rotationZ));
    return this;
  }

  AvizShape done() {
    popMatrix();
    return this;
  }

  class Spectrum {
    AvizData avizData;

    Spectrum(AvizData data) {
      avizData = data;
    }

    AvizShape bars(float w, float h) {
      int avgSize = avizData.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float rawAmplitude = avizData.getSpectrumVal(i);
        float displayAmplitude = avizData.scaleSpectrumVal(rawAmplitude);
        rect(i * (w / avgSize), h, (w / avgSize), -h * displayAmplitude);
      }
      return AvizShape.this;
    }

    AvizShape wire(float w, float h) {
      beginShape(LINES);
      int avgSize = avizData.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float rawSpectrumValA = avizData.getSpectrumVal(i);
        float rawSpectrumValB = avizData.getSpectrumVal(i + 1);
        vertex(i * (w / avgSize), -h * avizData.scaleSpectrumVal(rawSpectrumValA) + h);
        vertex((i + 1) * (w / avgSize), -h * avizData.scaleSpectrumVal(rawSpectrumValB) + h);
      }
      endShape();
      return AvizShape.this;
    }

    AvizShape radialBars(float h, float rangeStart, float rangeEnd, float rotation) {
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
      return AvizShape.this;
    }

    AvizShape radialWire(float rangeStart, float rangeEnd, float rotation) {
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
      return AvizShape.this;
    }
  }

  class Waveform {
    AvizData avizData;

    Waveform(AvizData data) {
      avizData = data;
    }

    AvizShape wire(float w, float h) {
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
      return AvizShape.this;
    }

    AvizShape radialWire(float h, float rangeStart, float rangeEnd, float rotation) {
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
      return AvizShape.this;
    }
  }

  class Levels {
    AvizData avizData;

    Levels(AvizData data) {
      avizData = data;
    }

    AvizShape bars(float w, float h) {
      float rawLeftLevel = avizData.getLeftLevel();
      float rawRightLevel = avizData.getRightLevel();
      rect(0, 0, avizData.scaleLeftLevel(rawLeftLevel) * w, h / 2);
      rect(0, h / 2, avizData.scaleRightLevel(rawRightLevel) * w, h / 2);
      endShape();
      return AvizShape.this;
    }

    AvizShape intervalBars(float w, float h, float scale, AvizInterval interval) {
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        rect(i * (w / intervalSize), h, (w / intervalSize), -avizData.scaleLeftLevel(interval.getIntervalData(i)[0]) * scale);
      }
      return AvizShape.this;
    }

    AvizShape cube(float scale) {
      float rawLeftLevel = avizData.getLeftLevel();
      float rawRightLevel = avizData.getRightLevel();
      float boxLevel = ((avizData.scaleLeftLevel(rawLeftLevel) + avizData.scaleRightLevel(rawRightLevel)) / 2) * scale;
      box(boxLevel, boxLevel, boxLevel);
      return AvizShape.this;
    }
  }

  class Beats {
    AvizData avizData;

    Beats(AvizData data) {
      avizData = data;
    }

    AvizShape circle(float minRadius, float maxRadius, AvizAmplitude amplitude) {
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      ellipse(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      return AvizShape.this;
    }

    AvizShape square(float minRadius, float maxRadius, AvizAmplitude amplitude) {
      rectMode(CENTER);
      float scale = maxRadius - minRadius;
      rect(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      rectMode(CORNER);
      return AvizShape.this;
    }

    AvizShape splashCircle(float minRadius, float maxRadius, AvizInterval interval) {
      pushStyle();
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        float position = map(i, 0, intervalSize, minRadius, maxRadius);
        if (interval.getIntervalData(i)[0] == 1.0) {
          ellipse(0, 0, position, position);
        }
      }
      popStyle();
      return AvizShape.this;
    }

    AvizShape splashSquare(float minRadius, float maxRadius, AvizInterval interval) {
      rectMode(CENTER);
      pushStyle();
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        float position = map(i, 0, intervalSize, minRadius, maxRadius);
        if (interval.getIntervalData(i)[0] == 1.0) {
          rect(0, 0, position, position);
        }
      }
      popStyle();
      rectMode(CORNER);
      return AvizShape.this;
    }

  }

  AvizShape svg(float scaleFactor, float origSize, PShape shape) {
    translate(-origSize * scaleFactor / 2, -origSize * scaleFactor / 2);
    pushStyle();
    shape.disableStyle();
    noStroke();
    fill(primaryColor);
    scale(scaleFactor);
    shape(shape, 0, 0);
    popStyle();
    return this;
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