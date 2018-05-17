class OavpVisualizer {
  public Spectrum spectrum;
  public Waveform waveform;
  public Levels levels;
  public Beats beats;
  public Grids grids;
  public Floaters floaters;
  public Emitters emitters;
  public Oscillator oscillators;
  public OavpPosition cursor;

  OavpVisualizer(OavpData data) {
    spectrum = new Spectrum(oavpData);
    waveform = new Waveform(oavpData);
    levels = new Levels(oavpData);
    beats = new Beats(oavpData);
    grids = new Grids(oavpData);
    floaters = new Floaters(oavpData);
    emitters = new Emitters(oavpData);
    oscillators = new Oscillator(oavpData);
  }

  OavpVisualizer(OavpData data, OavpPosition cursor) {
    spectrum = new Spectrum(oavpData);
    waveform = new Waveform(oavpData);
    levels = new Levels(oavpData);
    beats = new Beats(oavpData);
    grids = new Grids(oavpData);
    floaters = new Floaters(oavpData);
    emitters = new Emitters(oavpData);
    oscillators = new Oscillator(oavpData);
    this.cursor = cursor;
  }

  void attach(OavpPosition cursor) {
    this.cursor = cursor;
  }

  OavpVisualizer create() {
    pushMatrix();
    return this;
  }

  OavpVisualizer center() {
    translate(cursor.getCenteredX(), 0);
    return this;
  }

  OavpVisualizer middle() {
    translate(0, cursor.getCenteredY());
    return this;
  }

  OavpVisualizer left() {
    translate(cursor.getScaledX(), 0);
    return this;
  }

  OavpVisualizer right() {
    translate(cursor.getScaledX() + cursor.scale, 0);
    return this;
  }

  OavpVisualizer top() {
    translate(0, cursor.getScaledY());
    return this;
  }

  OavpVisualizer bottom() {
    translate(0, cursor.getScaledY() + cursor.scale);
    return this;
  }

  OavpVisualizer rotate(float x) {
    rotateX(radians(x));
    return this;
  }

  OavpVisualizer rotate(float x, float y) {
    rotateX(radians(x));
    rotateY(radians(y));
    return this;
  }

  OavpVisualizer rotate(float x, float y, float z) {
    rotateX(radians(x));
    rotateY(radians(y));
    rotateZ(radians(z));
    return this;
  }

  OavpVisualizer next() {
    popMatrix();
    pushMatrix();
    return this;
  }

  OavpVisualizer move(float x, float y, float z) {
    translate(x, y, z);
    return this;
  }

  OavpVisualizer moveUp(float distance) {
    translate(0, -distance);
    return this;
  }

  OavpVisualizer moveDown(float distance) {
    translate(0, distance);
    return this;
  }

  OavpVisualizer moveLeft(float distance) {
    translate(-distance, 0);
    return this;
  }

  OavpVisualizer moveRight(float distance) {
    translate(distance, 0);
    return this;
  }

  OavpVisualizer create(float x, float y) {
    pushMatrix();
    translate(x, y);
    return this;
  }

  OavpVisualizer create(float x, float y, float rotationX, float rotationY) {
    pushMatrix();
    translate(x, y);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    return this;
  }

  OavpVisualizer create(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    return this;
  }

  OavpVisualizer create(float x, float y, float z, float rotationX, float rotationY, float rotationZ) {
    pushMatrix();
    translate(x, y, z);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    rotateZ(radians(rotationZ));
    return this;
  }

  OavpVisualizer done() {
    popMatrix();
    return this;
  }

  class Oscillator {
    OavpData oavpData;

    Oscillator(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer zSquare(float w, float h, float scale, float range, float speed) {
      rectMode(CENTER);
      pushMatrix();
      translate(0, 0, map(sin(frameCount * speed), -1, 1, 0, range));
      rect(w / 2, h / 2, w * scale, h * scale);
      popMatrix();
      rectMode(CORNER);

      return OavpVisualizer.this;
    }

  }

  class Spectrum {
    OavpData oavpData;

    Spectrum(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer mesh(float w, float h, int specSample, OavpInterval interval) {
      int rows = interval.getIntervalSize();
      int cols = oavpData.getAvgSize();

      float rowScale = w / rows;
      float colScale = h / cols;

      for (int i = 0; i < rows - 1; i++) {
        beginShape(TRIANGLE_STRIP);
        for (int j = 0; j < cols; j += specSample) {
          float specValA = oavpData.scaleSpectrumVal(interval.getIntervalData(i)[j]);
          float specValB = oavpData.scaleSpectrumVal(interval.getIntervalData(i + 1)[j]);
          vertex(j * colScale, i * rowScale, specValA * stageWidth / 2);
          vertex(j * colScale, (i + 1) * rowScale, specValB * stageWidth / 2);
        }
        endShape();
      }


      return OavpVisualizer.this;
    }

    OavpVisualizer bars(float w, float h) {
      int avgSize = oavpData.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float rawAmplitude = oavpData.getSpectrumVal(i);
        float displayAmplitude = oavpData.scaleSpectrumVal(rawAmplitude);
        rect(i * (w / avgSize), h, (w / avgSize), -h * displayAmplitude);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer wire(float w, float h) {
      beginShape(LINES);
      int avgSize = oavpData.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float rawSpectrumValA = oavpData.getSpectrumVal(i);
        float rawSpectrumValB = oavpData.getSpectrumVal(i + 1);
        vertex(i * (w / avgSize), -h * oavpData.scaleSpectrumVal(rawSpectrumValA) + h);
        vertex((i + 1) * (w / avgSize), -h * oavpData.scaleSpectrumVal(rawSpectrumValB) + h);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer radialBars(float h, float rangeStart, float rangeEnd, float rotation) {
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
      return OavpVisualizer.this;
    }

    OavpVisualizer radialWire(float rangeStart, float rangeEnd, float rotation) {
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
      return OavpVisualizer.this;
    }
  }

  class Waveform {
    OavpData oavpData;

    Waveform(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer wire(float w, float h) {
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
      return OavpVisualizer.this;
    }

    OavpVisualizer radialWire(float h, float rangeStart, float rangeEnd, float rotation) {
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
      return OavpVisualizer.this;
    }
  }

  class Levels {
    OavpData oavpData;

    Levels(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer flatbox(float scale, int inputColor) {
      float rawLeftLevel = oavpData.getLeftLevel();
      float rawRightLevel = oavpData.getRightLevel();
      float boxLevel = ((oavpData.scaleLeftLevel(rawLeftLevel) + oavpData.scaleRightLevel(rawRightLevel)) / 2) * scale;
      shapes.flatbox(0, 0, 0, scale, -boxLevel, scale, inputColor);
      return OavpVisualizer.this;
    }

    OavpVisualizer bars(float w, float h) {
      float rawLeftLevel = oavpData.getLeftLevel();
      float rawRightLevel = oavpData.getRightLevel();
      rect(0, 0, oavpData.scaleLeftLevel(rawLeftLevel) * w, h / 2);
      rect(0, h / 2, oavpData.scaleRightLevel(rawRightLevel) * w, h / 2);
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer intervalBars(float w, float h, float scale, OavpInterval interval) {
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        rect(i * (w / intervalSize), h, (w / intervalSize), -oavpData.scaleLeftLevel(interval.getIntervalData(i)[0]) * scale);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer cube(float scale) {
      float rawLeftLevel = oavpData.getLeftLevel();
      float rawRightLevel = oavpData.getRightLevel();
      float boxLevel = ((oavpData.scaleLeftLevel(rawLeftLevel) + oavpData.scaleRightLevel(rawRightLevel)) / 2) * scale;
      box(boxLevel, boxLevel, boxLevel);
      return OavpVisualizer.this;
    }
  }

  class Beats {
    OavpData oavpData;

    Beats(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer flatbox(float scale, int inputColor, OavpAmplitude amplitude) {
      shapes.flatbox(0, 0, 0, scale, -amplitude.getValue() * scale, scale, inputColor);
      return OavpVisualizer.this;
    }

    OavpVisualizer gridSquare(float w, float h, OavpGridInterval interval) {
      rectMode(CENTER);
      float colScale = w / interval.numCols;
      float rowScale = h / interval.numRows;
      for (int i = 0; i < interval.numRows; i++) {
        for (int j = 0; j < interval.numCols; j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          rect(x, y, interval.getData(i, j) * colScale, interval.getData(i, j) * rowScale);
        }
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer circle(float minRadius, float maxRadius, OavpAmplitude amplitude) {
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      ellipse(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      return OavpVisualizer.this;
    }

    OavpVisualizer square(float minRadius, float maxRadius, OavpAmplitude amplitude) {
      rectMode(CENTER);
      float scale = maxRadius - minRadius;
      rect(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer ghostCircle(float minRadius, float maxRadius, OavpInterval interval, int trailSize) {
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        strokeWeight(i);
        ellipse(0, 0, interval.getIntervalData(i)[0] * scale, interval.getIntervalData(i)[0] * scale);
      }
      strokeWeight(defaultStrokeWeight);
      return OavpVisualizer.this;
    }

    OavpVisualizer ghostSquare(float minRadius, float maxRadius, OavpInterval interval, int trailSize) {
      rectMode(CENTER);
      float scale = maxRadius - minRadius;
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        rect(0, 0, interval.getIntervalData(i)[0] * scale, interval.getIntervalData(i)[0] * scale);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer splashCircle(float minRadius, float maxRadius, OavpInterval interval) {
      pushStyle();
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        float position = map(i, 0, intervalSize, minRadius, maxRadius);
        if (interval.getIntervalData(i)[0] == 1.0) {
          ellipse(0, 0, position, position);
        }
      }
      popStyle();
      return OavpVisualizer.this;
    }

    OavpVisualizer splashSquare(float minRadius, float maxRadius, OavpInterval interval) {
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
      return OavpVisualizer.this;
    }
  }

  class Grids {
    OavpData oavpData;

    Grids(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer flatbox(float w, float h, float scale, OavpGridInterval interval) {
      float colScale = w / interval.numCols;
      float rowScale = h / interval.numRows;
      for (int i = 0; i < interval.numRows; i++) {
        for (int j = 0; j < interval.numCols; j++) {
          float x = (j * colScale);
          float z = (i * rowScale);
          float finalLevel = oavpData.scaleLeftLevel(interval.getData(i, j));
          shapes.flatbox(x, 0, z, colScale, -finalLevel * scale, rowScale, style.flat.grey);
        }
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer square(float w, float h, OavpGridInterval interval) {
      rectMode(CENTER);
      float colScale = w / interval.numCols;
      float rowScale = h / interval.numRows;
      for (int i = 0; i < interval.numRows; i++) {
        for (int j = 0; j < interval.numCols; j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          float finalLevel = interval.getData(i, j);
          rect(x, y, finalLevel * colScale, finalLevel * rowScale);
        }
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }
  }

  class Emitters {
    OavpData oavpData;

    Emitters(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer linearBeat(float start, float end, float easing, List trackers) {
      if (oavpData.isBeatOnset()) {
        trackers.add(new OavpTracker(start, end, easing));
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer linearDelay(float start, float end, float easing, int frameDelay, List trackers) {
      if (frameCount % frameDelay == 0) {
        trackers.add(new OavpTracker(start, end, easing));
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer linearTempo(float start, float end, float easing, OavpRhythm metronome, List trackers) {
      if (metronome.onRhythm()) {
        trackers.add(new OavpTracker(start, end, easing));
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer linearSpectrumTempo(float start, float end, float easing, OavpRhythm metronome, List trackers) {
      float[] payload = new float[oavpData.getSpectrum().length];
      for (int i = 0; i < oavpData.getSpectrum().length; i++) {
        payload[i] = oavpData.getSpectrumVal(i);
      }
      if (metronome.onRhythm()) {
        trackers.add(new OavpTracker(start, end, easing, payload));
      }
      return OavpVisualizer.this;
    }
  }

  class Floaters {
    OavpData oavpData;

    Floaters(OavpData data) {
      oavpData = data;
    }

    OavpVisualizer spectrumWire(float w, float h, List trackers) {
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        pushMatrix();
        translate(0, 0, -tracker.value);
        beginShape();
        float scale = w / tracker.payload.length;
        for (int i = 0; i < tracker.payload.length; i++) {
          vertex(i * scale, (h / 2) - oavpData.scaleSpectrumVal(tracker.payload[i]) * (h / 2));
        }
        endShape();
        rect(0, 0, w, h);
        popMatrix();
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer square(float size, List trackers) {
      rectMode(CENTER);
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        rect(0, -tracker.value, size, size);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer circle(float size, List trackers) {
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        ellipse(0, -tracker.value, size, size);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer splashSquare(List trackers) {
      rectMode(CENTER);
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        rect(0, 0, tracker.value, tracker.value);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer splashCircle(List trackers) {
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        ellipse(0, 0, tracker.value, tracker.value);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer chevron(float w, float h, List trackers) {
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        shapes.chevron(0, -tracker.value, w, h);
      }
      return OavpVisualizer.this;
    }
  }

  OavpVisualizer svg(float scaleFactor, float origSize, PShape shape) {
    translate(-origSize * scaleFactor / 2, -origSize * scaleFactor / 2);
    pushStyle();
    shape.disableStyle();
    noStroke();
    scale(scaleFactor);
    shape(shape, 0, 0);
    popStyle();
    return this;
  }
}