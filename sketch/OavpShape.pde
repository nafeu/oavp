class OavpShape {
  public Spectrum spectrum;
  public Waveform waveform;
  public Levels levels;
  public Beats beats;
  public OavpPosition cursor;

  OavpShape(OavpData data) {
    spectrum = new Spectrum(oavpData);
    waveform = new Waveform(oavpData);
    levels = new Levels(oavpData);
    beats = new Beats(oavpData);
  }

  OavpShape(OavpData data, OavpPosition cursor) {
    spectrum = new Spectrum(oavpData);
    waveform = new Waveform(oavpData);
    levels = new Levels(oavpData);
    beats = new Beats(oavpData);
    this.cursor = cursor;
  }

  void attach(OavpPosition cursor) {
    this.cursor = cursor;
  }

  OavpShape create() {
    pushMatrix();
    return this;
  }

  OavpShape center() {
    translate(cursor.getCenteredX(), 0);
    return this;
  }

  OavpShape middle() {
    translate(0, cursor.getCenteredY());
    return this;
  }

  OavpShape left() {
    translate(cursor.getScaledX(), 0);
    return this;
  }

  OavpShape right() {
    translate(cursor.getScaledX() + cursor.scale, 0);
    return this;
  }

  OavpShape top() {
    translate(0, cursor.getScaledY());
    return this;
  }

  OavpShape bottom() {
    translate(0, cursor.getScaledY() + cursor.scale);
    return this;
  }

  OavpShape rotate(float x) {
    rotateX(radians(x));
    return this;
  }

  OavpShape rotate(float x, float y) {
    rotateX(radians(x));
    rotateY(radians(y));
    return this;
  }

  OavpShape next() {
    popMatrix();
    pushMatrix();
    return this;
  }

  OavpShape create(float x, float y) {
    pushMatrix();
    translate(x, y);
    return this;
  }

  OavpShape create(float x, float y, float rotationX, float rotationY) {
    pushMatrix();
    translate(x, y);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    return this;
  }

  OavpShape create(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    return this;
  }

  OavpShape create(float x, float y, float z, float rotationX, float rotationY, float rotationZ) {
    pushMatrix();
    translate(x, y, z);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    rotateZ(radians(rotationZ));
    return this;
  }

  OavpShape done() {
    popMatrix();
    return this;
  }

  class Spectrum {
    OavpData oavpData;

    Spectrum(OavpData data) {
      oavpData = data;
    }

    OavpShape bars(float w, float h) {
      int avgSize = oavpData.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float rawAmplitude = oavpData.getSpectrumVal(i);
        float displayAmplitude = oavpData.scaleSpectrumVal(rawAmplitude);
        rect(i * (w / avgSize), h, (w / avgSize), -h * displayAmplitude);
      }
      return OavpShape.this;
    }

    OavpShape wire(float w, float h) {
      beginShape(LINES);
      int avgSize = oavpData.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float rawSpectrumValA = oavpData.getSpectrumVal(i);
        float rawSpectrumValB = oavpData.getSpectrumVal(i + 1);
        vertex(i * (w / avgSize), -h * oavpData.scaleSpectrumVal(rawSpectrumValA) + h);
        vertex((i + 1) * (w / avgSize), -h * oavpData.scaleSpectrumVal(rawSpectrumValB) + h);
      }
      endShape();
      return OavpShape.this;
    }

    OavpShape radialBars(float h, float rangeStart, float rangeEnd, float rotation) {
      beginShape();
      int avgSize = oavpData.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float angle = map(i, 0, avgSize, 0, 360) - rotation;
        float r = map(oavpData.getSpectrumVal(i), 0, 256, rangeStart, rangeEnd);
        float x1 = h * cos(radians(angle));
        float y1 = h * sin(radians(angle));
        float x2 = r * cos(radians(angle));
        float y2 = r * sin(radians(angle));
        line(x1, y1, x2, y2);
      }
      endShape();
      return OavpShape.this;
    }

    OavpShape radialWire(float rangeStart, float rangeEnd, float rotation) {
      beginShape(LINES);
      int avgSize = oavpData.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float angleA = map(i, 0, avgSize, 0, 360) - rotation;
        float rA = map(oavpData.getSpectrumVal(i), 0, 256, rangeStart, rangeEnd);
        float xA = rA * cos(radians(angleA));
        float yA = rA * sin(radians(angleA));
        float angleB = map(i + 1, 0, avgSize, 0, 360) - rotation;
        float rB = map(oavpData.getSpectrumVal(i + 1), 0, 256, rangeStart, rangeEnd);
        float xB = rB * cos(radians(angleB));
        float yB = rB * sin(radians(angleB));
        vertex(xA, yA);
        vertex(xB, yB);
      }
      endShape();
      return OavpShape.this;
    }
  }

  class Waveform {
    OavpData oavpData;

    Waveform(OavpData data) {
      oavpData = data;
    }

    OavpShape wire(float w, float h) {
      int audioBufferSize = oavpData.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float x1 = map( i, 0, audioBufferSize, 0, w);
        float x2 = map( i + 1, 0, audioBufferSize, 0, w);
        float leftBufferScale = (h / 4);
        float rightBufferScale = (h / 4) * 3;
        float waveformScale = (h / 4);
        line(x1, leftBufferScale + oavpData.getLeftBuffer(i) * waveformScale, x2, leftBufferScale + oavpData.getLeftBuffer(i + 1) * waveformScale);
        line(x1, rightBufferScale + oavpData.getRightBuffer(i) * waveformScale, x2, rightBufferScale + oavpData.getRightBuffer(i + 1) * waveformScale);
      }
      endShape();
      return OavpShape.this;
    }

    OavpShape radialWire(float h, float rangeStart, float rangeEnd, float rotation) {
      beginShape(LINES);
      int audioBufferSize = oavpData.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float angleA = map(i, 0, audioBufferSize, 0, 360) - rotation;
        float rA = h + map(oavpData.getLeftBuffer(i), -1, 1, rangeStart, rangeEnd);
        float xA = rA * cos(radians(angleA));
        float yA = rA * sin(radians(angleA));

        float angleB = map(i + 1, 0, audioBufferSize, 0, 360) - rotation;
        float rB = h + map(oavpData.getLeftBuffer(i + 1), -1, 1, rangeStart, rangeEnd);
        float xB = rB * cos(radians(angleB));
        float yB = rB * sin(radians(angleB));
        vertex(xA, yA);
        vertex(xB, yB);
      }
      endShape();
      return OavpShape.this;
    }
  }

  class Levels {
    OavpData oavpData;

    Levels(OavpData data) {
      oavpData = data;
    }

    OavpShape bars(float w, float h) {
      float rawLeftLevel = oavpData.getLeftLevel();
      float rawRightLevel = oavpData.getRightLevel();
      rect(0, 0, oavpData.scaleLeftLevel(rawLeftLevel) * w, h / 2);
      rect(0, h / 2, oavpData.scaleRightLevel(rawRightLevel) * w, h / 2);
      endShape();
      return OavpShape.this;
    }

    OavpShape intervalBars(float w, float h, float scale, OavpInterval interval) {
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        rect(i * (w / intervalSize), h, (w / intervalSize), -oavpData.scaleLeftLevel(interval.getIntervalData(i)[0]) * scale);
      }
      return OavpShape.this;
    }

    OavpShape cube(float scale) {
      float rawLeftLevel = oavpData.getLeftLevel();
      float rawRightLevel = oavpData.getRightLevel();
      float boxLevel = ((oavpData.scaleLeftLevel(rawLeftLevel) + oavpData.scaleRightLevel(rawRightLevel)) / 2) * scale;
      box(boxLevel, boxLevel, boxLevel);
      return OavpShape.this;
    }
  }

  class Beats {
    OavpData oavpData;

    Beats(OavpData data) {
      oavpData = data;
    }

    OavpShape circle(float minRadius, float maxRadius, OavpAmplitude amplitude) {
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      ellipse(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      return OavpShape.this;
    }

    OavpShape square(float minRadius, float maxRadius, OavpAmplitude amplitude) {
      rectMode(CENTER);
      float scale = maxRadius - minRadius;
      rect(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      rectMode(CORNER);
      return OavpShape.this;
    }

    OavpShape splashCircle(float minRadius, float maxRadius, OavpInterval interval) {
      pushStyle();
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        float position = map(i, 0, intervalSize, minRadius, maxRadius);
        if (interval.getIntervalData(i)[0] == 1.0) {
          ellipse(0, 0, position, position);
        }
      }
      popStyle();
      return OavpShape.this;
    }

    OavpShape splashSquare(float minRadius, float maxRadius, OavpInterval interval) {
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
      return OavpShape.this;
    }

  }

  OavpShape svg(float scaleFactor, float origSize, PShape shape) {
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