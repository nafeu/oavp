class OavpVisualizer {
  public Draw draw;
  OavpEntityManager entities;
  OavpPosition cursor;
  OavpAmplitude currAmplitude;
  OavpInterval currInterval;
  OavpGridInterval currGridInterval;
  List currTrackers;
  OavpRhythm currRhythm;

  OavpVisualizer(OavpAnalysis analysis, OavpPosition cursor, OavpEntityManager entities) {
    draw = new Draw(analysis);
    this.cursor = cursor;
    this.entities = entities;
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

  OavpVisualizer move(float x, float y) {
    translate(x, y);
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

  OavpVisualizer moveBackward(float distance) {
    translate(0, 0, -distance);
    return this;
  }

  OavpVisualizer moveForward(float distance) {
    translate(0, 0, distance);
    return this;
  }

  OavpVisualizer create() {
    pushMatrix();
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

  OavpVisualizer startStyle() {
    pushStyle();
    return this;
  }

  OavpVisualizer endStyle() {
    popStyle();
    return this;
  }

  OavpVisualizer noFillStyle() {
    noFill();
    return this;
  }

  OavpVisualizer noStrokeStyle() {
    noStroke();
    return this;
  }

  OavpVisualizer fillColor(color customColor) {
    fill(customColor);
    return this;
  }

  OavpVisualizer strokeColor(color customColor) {
    stroke(customColor);
    return this;
  }

  OavpVisualizer strokeWeightStyle(float weight) {
    strokeWeight(weight);
    return this;
  }

  OavpVisualizer done() {
    popMatrix();
    return this;
  }

  OavpVisualizer useAmplitude(String name) {
    currAmplitude = entities.getAmplitude(name);
    return this;
  }

  OavpVisualizer useInterval(String name) {
    currInterval = entities.getInterval(name);
    return this;
  }

  OavpVisualizer useGridInterval(String name) {
    currGridInterval = entities.getGridInterval(name);
    return this;
  }

  OavpVisualizer useTrackers(String name) {
    currTrackers = entities.getTrackers(name);
    return this;
  }

  OavpVisualizer useRhythm(String name) {
    currRhythm = entities.getRhythm(name);
    return this;
  }

  class Draw {

    OavpAnalysis analysis;

    Draw(OavpAnalysis analysis) {
      this.analysis = analysis;
    }

    OavpVisualizer basicSquare(float size) {
      rectMode(CENTER);
      rect(0, 0, size, size);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer basicSquare(float size, int mode) {
      rectMode(mode);
      rect(0, 0, size, size);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer basicCircle(float radius) {
      ellipse(0, 0, radius, radius);
      return OavpVisualizer.this;
    }

    OavpVisualizer basicOscZSquare(float w, float h, float scale, float range, float speed) {
      rectMode(CENTER);
      pushMatrix();
      translate(0, 0, map(sin(frameCount * speed), -1, 1, 0, range));
      rect(w / 2, h / 2, w * scale, h * scale);
      popMatrix();
      rectMode(CORNER);

      return OavpVisualizer.this;
    }

    OavpVisualizer intervalSpectrumMesh(float w, float h, float scale, int specSample) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int rows = interval.getIntervalSize();
      int cols = analysis.getAvgSize();

      float rowScale = w / rows;
      float colScale = h / cols;

      for (int i = 0; i < rows - 1; i++) {
        beginShape(TRIANGLE_STRIP);
        for (int j = 0; j < cols; j += specSample) {
          float specValA = analysis.scaleSpectrumVal(interval.getIntervalData(i)[j]);
          float specValB = analysis.scaleSpectrumVal(interval.getIntervalData(i + 1)[j]);
          vertex(j * colScale, i * rowScale, specValA * scale);
          vertex(j * colScale, (i + 1) * rowScale, specValB * scale);
        }
        endShape();
      }

      return OavpVisualizer.this;
    }

    OavpVisualizer basicSpectrumBars(float w, float h) {
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float rawAmplitude = analysis.getSpectrumVal(i);
        float displayAmplitude = analysis.scaleSpectrumVal(rawAmplitude);
        rect(i * (w / avgSize), h, (w / avgSize), -h * displayAmplitude);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer basicSpectrumWire(float w, float h) {
      beginShape(LINES);
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float rawSpectrumValA = analysis.getSpectrumVal(i);
        float rawSpectrumValB = analysis.getSpectrumVal(i + 1);
        vertex(i * (w / avgSize), -h * analysis.scaleSpectrumVal(rawSpectrumValA) + h);
        vertex((i + 1) * (w / avgSize), -h * analysis.scaleSpectrumVal(rawSpectrumValB) + h);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basicSpectrumRadialBars(float h, float rangeStart, float rangeEnd, float rotation) {
      beginShape();
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float angle = map(i, 0, avgSize, 0, 360) - rotation;
        float r = map(analysis.getSpectrumVal(i), 0, 256, rangeStart, rangeEnd);
        float x1 = h * cos(radians(angle));
        float y1 = h * sin(radians(angle));
        float x2 = r * cos(radians(angle));
        float y2 = r * sin(radians(angle));
        line(x1, y1, x2, y2);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basiSpectrumRadialWire(float rangeStart, float rangeEnd, float rotation) {
      beginShape(LINES);
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float angleA = map(i, 0, avgSize, 0, 360) - rotation;
        float rA = map(analysis.getSpectrumVal(i), 0, 256, rangeStart, rangeEnd);
        float xA = rA * cos(radians(angleA));
        float yA = rA * sin(radians(angleA));
        float angleB = map(i + 1, 0, avgSize, 0, 360) - rotation;
        float rB = map(analysis.getSpectrumVal(i + 1), 0, 256, rangeStart, rangeEnd);
        float xB = rB * cos(radians(angleB));
        float yB = rB * sin(radians(angleB));
        vertex(xA, yA);
        vertex(xB, yB);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basicWaveformWire(float w, float h) {
      int audioBufferSize = analysis.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float x1 = map( i, 0, audioBufferSize, 0, w);
        float x2 = map( i + 1, 0, audioBufferSize, 0, w);
        float leftBufferScale = (h / 4);
        float rightBufferScale = (h / 4) * 3;
        float waveformScale = (h / 4);
        line(x1, leftBufferScale + analysis.getLeftBuffer(i) * waveformScale, x2, leftBufferScale + analysis.getLeftBuffer(i + 1) * waveformScale);
        line(x1, rightBufferScale + analysis.getRightBuffer(i) * waveformScale, x2, rightBufferScale + analysis.getRightBuffer(i + 1) * waveformScale);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basicWaveformRadialWire(float h, float rangeStart, float rangeEnd, float rotation) {
      beginShape(LINES);
      int audioBufferSize = analysis.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float angleA = map(i, 0, audioBufferSize, 0, 360) - rotation;
        float rA = h + map(analysis.getLeftBuffer(i), -1, 1, rangeStart, rangeEnd);
        float xA = rA * cos(radians(angleA));
        float yA = rA * sin(radians(angleA));

        float angleB = map(i + 1, 0, audioBufferSize, 0, 360) - rotation;
        float rB = h + map(analysis.getLeftBuffer(i + 1), -1, 1, rangeStart, rangeEnd);
        float xB = rB * cos(radians(angleB));
        float yB = rB * sin(radians(angleB));
        vertex(xA, yA);
        vertex(xB, yB);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basicLevelFlatbox(float scale) {
      float rawLeftLevel = analysis.getLeftLevel();
      float rawRightLevel = analysis.getRightLevel();
      float boxLevel = ((analysis.scaleLeftLevel(rawLeftLevel) + analysis.scaleRightLevel(rawRightLevel)) / 2) * scale;
      shapes.flatbox(0, 0, 0, scale, -boxLevel, scale);
      return OavpVisualizer.this;
    }

    OavpVisualizer basicLevelBars(float w, float h) {
      float rawLeftLevel = analysis.getLeftLevel();
      float rawRightLevel = analysis.getRightLevel();
      rect(0, 0, analysis.scaleLeftLevel(rawLeftLevel) * w, h / 2);
      rect(0, h / 2, analysis.scaleRightLevel(rawRightLevel) * w, h / 2);
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer intervalLevelBars(float w, float h, float scale) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        rect(i * (w / intervalSize), h, (w / intervalSize), -analysis.scaleLeftLevel(interval.getIntervalData(i)[0]) * scale);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer basicLevelCube(float scale) {
      float rawLeftLevel = analysis.getLeftLevel();
      float rawRightLevel = analysis.getRightLevel();
      float boxLevel = ((analysis.scaleLeftLevel(rawLeftLevel) + analysis.scaleRightLevel(rawRightLevel)) / 2) * scale;
      box(boxLevel, boxLevel, boxLevel);
      return OavpVisualizer.this;
    }

    OavpVisualizer amplitudeFlatbox(float scale) {
      OavpAmplitude amplitude = OavpVisualizer.this.currAmplitude;
      shapes.flatbox(0, 0, 0, scale, -amplitude.getValue() * scale, scale);
      return OavpVisualizer.this;
    }

    OavpVisualizer gridIntervalGridSquare(float w, float h) {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      rectMode(CENTER);
      float colScale = w / gridInterval.numCols;
      float rowScale = h / gridInterval.numRows;
      for (int i = 0; i < gridInterval.numRows; i++) {
        for (int j = 0; j < gridInterval.numCols; j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          rect(x, y, gridInterval.getData(i, j) * colScale, gridInterval.getData(i, j) * rowScale);
        }
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer amplitudeCircle(float minRadius, float maxRadius) {
      OavpAmplitude amplitude = OavpVisualizer.this.currAmplitude;
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      ellipse(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      return OavpVisualizer.this;
    }

    OavpVisualizer amplitudeSquare(float scale) {
      OavpAmplitude amplitude = OavpVisualizer.this.currAmplitude;
      rectMode(CENTER);
      rect(0, 0, amplitude.getValue() * scale, amplitude.getValue() * scale);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer intervalGhostCircle(float minRadius, float maxRadius, int trailSize) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      pushStyle();
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        strokeWeight(i);
        ellipse(0, 0, interval.getIntervalData(i)[0] * scale, interval.getIntervalData(i)[0] * scale);
      }
      popStyle();
      return OavpVisualizer.this;
    }

    OavpVisualizer intervalGhostSquare(float minRadius, float maxRadius, int trailSize) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      rectMode(CENTER);
      float scale = maxRadius - minRadius;
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        rect(0, 0, interval.getIntervalData(i)[0] * scale, interval.getIntervalData(i)[0] * scale);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer gridIntervalFlatbox(float w, float h, float scale) {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      float colScale = w / gridInterval.numCols;
      float rowScale = h / gridInterval.numRows;
      for (int i = 0; i < gridInterval.numRows; i++) {
        for (int j = 0; j < gridInterval.numCols; j++) {
          float x = (j * colScale);
          float z = (i * rowScale);
          float finalLevel = analysis.scaleLeftLevel(gridInterval.getData(i, j));
          shapes.flatbox(x, 0, z, colScale, -finalLevel * scale, rowScale);
        }
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer gridIntervalSquare(float w, float h) {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      rectMode(CENTER);
      float colScale = w / gridInterval.numCols;
      float rowScale = h / gridInterval.numRows;
      for (int i = 0; i < gridInterval.numRows; i++) {
        for (int j = 0; j < gridInterval.numCols; j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          float finalLevel = gridInterval.getData(i, j);
          rect(x, y, finalLevel * colScale, finalLevel * rowScale);
        }
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerSpectrumWire(float w, float h, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        pushMatrix();
        translate(0, 0, -tracker.value * scale);
        beginShape();
        float offset = w / tracker.payload.length;
        for (int i = 0; i < tracker.payload.length; i++) {
          vertex(i * offset, (h / 2) - analysis.scaleSpectrumVal(tracker.payload[i]) * (h / 2));
        }
        endShape();
        rect(0, 0, w, h);
        popMatrix();
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerSquare(float size, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      rectMode(CENTER);
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        rect(0, -tracker.value * scale, size, size);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerCircle(float radius, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        ellipse(0, -tracker.value * scale, radius, radius);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerConnectedRings(float radius, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        float xInit = 0;
        float yInit = 0;

        beginShape();
        for (int i = 0; i < tracker.payload.length; ++i) {
          float x = (tracker.value * scale) * cos(radians(tracker.payload[i]));
          float y = (tracker.value * scale) * sin(radians(tracker.payload[i]));
          vertex(x, y);
          if (i == 0) {
            xInit = x;
            yInit = y;
          }
        }
        vertex(xInit, yInit);
        endShape();

        for (int i = 0; i < tracker.payload.length; ++i) {
          float x = (tracker.value * scale) * cos(radians(tracker.payload[i]));
          float y = (tracker.value * scale) * sin(radians(tracker.payload[i]));
          ellipse(x, y, radius, radius);
        }
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerSplashSquare(float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      rectMode(CENTER);
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        rect(0, 0, tracker.value * scale, tracker.value * scale);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerSplashCircle(float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        ellipse(0, 0, tracker.value * scale, tracker.value * scale);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerChevron(float w, float h, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        shapes.chevron(0, -tracker.value * scale, w, h);
      }
      return OavpVisualizer.this;
    }
  }

  OavpVisualizer svg(float scaleFactor, PShape shape) {
    pushStyle();
    shape.disableStyle();
    noStroke();
    scale(scaleFactor);
    shape(shape, 0, 0);
    popStyle();
    return this;
  }

  OavpVisualizer img(float scaleFactor, PImage image) {
    pushStyle();
    scale(scaleFactor);
    image(image, 0, 0);
    popStyle();
    return this;
  }
}