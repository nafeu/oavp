class OavpVisualizer {
  public Draw draw;
  OavpEntityManager entities;
  OavpPosition cursor;
  OavpPulser currPulser;
  OavpInterval currInterval;
  OavpGridInterval currGridInterval;
  OavpTerrain currTerrain;
  float currWidth;
  float currHeight;
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

  OavpVisualizer rotateClockwise(float x) {
    rotateZ(radians(x));
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

  OavpVisualizer usePulser(String name) {
    currPulser = entities.getPulser(name);
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

  OavpVisualizer useTerrain(String name) {
    currTerrain = entities.getTerrain(name);
    return this;
  }

  OavpVisualizer dimensions(float w, float h) {
    currWidth = w;
    currHeight = h;
    return this;
  }

  class Draw {

    OavpAnalysis analysis;

    Draw(OavpAnalysis analysis) {
      this.analysis = analysis;
    }

    OavpVisualizer basicHills(float scale, float displacement, int windowSize, int phaseShift, float position) {
      shapes.hill(0, 0, currWidth, currHeight, scale, displacement,
                  currTerrain.getValues(position, windowSize, phaseShift), position);
      shapes.trees(0, 0, currWidth, currHeight, scale, displacement,
                   currTerrain.getWindow(position, windowSize, phaseShift), position);
      return OavpVisualizer.this;
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

    OavpVisualizer basicZSquare(float size, float distance) {
      rectMode(CENTER);
      pushMatrix();
      translate(0, 0, distance);
      rect(0, 0, size, size);
      popMatrix();
      rectMode(CORNER);

      return OavpVisualizer.this;
    }

    OavpVisualizer intervalSpectrumMesh(float scale, int specSample) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int rows = interval.getIntervalSize();
      int cols = analysis.getAvgSize();

      float rowScale = currWidth / rows;
      float colScale = currHeight / cols;

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

    OavpVisualizer basicSpectrumBars() {
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float rawPulser = analysis.getSpectrumVal(i);
        float displayPulser = analysis.scaleSpectrumVal(rawPulser);
        rect(i * (currWidth / avgSize), currHeight, (currWidth / avgSize), -currHeight * displayPulser);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer basicSpectrumWire() {
      beginShape(LINES);
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float rawSpectrumValA = analysis.getSpectrumVal(i);
        float rawSpectrumValB = analysis.getSpectrumVal(i + 1);
        vertex(i * (currWidth / avgSize), -currHeight * analysis.scaleSpectrumVal(rawSpectrumValA) + currHeight);
        vertex((i + 1) * (currWidth / avgSize), -currHeight * analysis.scaleSpectrumVal(rawSpectrumValB) + currHeight);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basicSpectrumRadialBars(float scale, float rangeStart, float rangeEnd, float rotation) {
      beginShape();
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float angle = map(i, 0, avgSize, 0, 360) - rotation;
        float r = map(analysis.getSpectrumVal(i), 0, 256, rangeStart, rangeEnd);
        float x1 = scale * cos(radians(angle));
        float y1 = scale * sin(radians(angle));
        float x2 = r * cos(radians(angle));
        float y2 = r * sin(radians(angle));
        line(x1, y1, x2, y2);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basicSpectrumRadialWire(float rangeStart, float rangeEnd, float rotation) {
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

    OavpVisualizer basicWaveformWire() {
      int audioBufferSize = analysis.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float x1 = map( i, 0, audioBufferSize, 0, currWidth);
        float x2 = map( i + 1, 0, audioBufferSize, 0, currWidth);
        float leftBufferScale = (currHeight / 4);
        float rightBufferScale = (currHeight / 4) * 3;
        float waveformScale = (currHeight / 4);
        line(x1, leftBufferScale + analysis.getLeftBuffer(i) * waveformScale, x2, leftBufferScale + analysis.getLeftBuffer(i + 1) * waveformScale);
        line(x1, rightBufferScale + analysis.getRightBuffer(i) * waveformScale, x2, rightBufferScale + analysis.getRightBuffer(i + 1) * waveformScale);
      }
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer basicWaveformRadialWire(float scale, float rangeStart, float rangeEnd, float rotation) {
      beginShape(LINES);
      int audioBufferSize = analysis.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float angleA = map(i, 0, audioBufferSize, 0, 360) - rotation;
        float rA = scale + map(analysis.getLeftBuffer(i), -1, 1, rangeStart, rangeEnd);
        float xA = rA * cos(radians(angleA));
        float yA = rA * sin(radians(angleA));

        float angleB = map(i + 1, 0, audioBufferSize, 0, 360) - rotation;
        float rB = scale + map(analysis.getLeftBuffer(i + 1), -1, 1, rangeStart, rangeEnd);
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

    OavpVisualizer basicLevelBars() {
      float rawLeftLevel = analysis.getLeftLevel();
      float rawRightLevel = analysis.getRightLevel();
      rect(0, 0, analysis.scaleLeftLevel(rawLeftLevel) * currWidth, currHeight / 2);
      rect(0, currHeight / 2, analysis.scaleRightLevel(rawRightLevel) * currWidth, currHeight / 2);
      endShape();
      return OavpVisualizer.this;
    }

    OavpVisualizer intervalLevelBars(float scale) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        rect(i * (currWidth / intervalSize), currHeight, (currWidth / intervalSize), -analysis.scaleLeftLevel(interval.getIntervalData(i)[0]) * scale);
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

    OavpVisualizer pulserFlatbox(float scale) {
      OavpPulser pulser = OavpVisualizer.this.currPulser;
      shapes.flatbox(0, 0, 0, scale, -pulser.getValue() * scale, scale);
      return OavpVisualizer.this;
    }

    OavpVisualizer gridIntervalGridSquare() {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      rectMode(CENTER);
      float colScale = currWidth / gridInterval.numCols;
      float rowScale = currHeight / gridInterval.numRows;
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

    OavpVisualizer pulserCircle(float minRadius, float maxRadius) {
      OavpPulser pulser = OavpVisualizer.this.currPulser;
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      ellipse(0, 0, pulser.getValue() * scale, pulser.getValue() * scale);
      return OavpVisualizer.this;
    }

    OavpVisualizer pulserSquare(float scale) {
      OavpPulser pulser = OavpVisualizer.this.currPulser;
      rectMode(CENTER);
      rect(0, 0, pulser.getValue() * scale, pulser.getValue() * scale);
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

    OavpVisualizer gridIntervalFlatbox(float scale) {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      float colScale = currWidth / gridInterval.numCols;
      float rowScale = currHeight / gridInterval.numRows;
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

    OavpVisualizer gridIntervalSquare() {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      rectMode(CENTER);
      float colScale = currWidth / gridInterval.numCols;
      float rowScale = currHeight / gridInterval.numRows;
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

    OavpVisualizer trackerSpectrumWire(float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        pushMatrix();
        translate(0, 0, -tracker.value * scale);
        beginShape();
        float offset = currWidth / tracker.payload.length;
        for (int i = 0; i < tracker.payload.length; i++) {
          vertex(i * offset, (currHeight / 2) - analysis.scaleSpectrumVal(tracker.payload[i]) * (currHeight / 2));
        }
        endShape();
        rect(0, 0, currWidth, currHeight);
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

    OavpVisualizer trackerColorSquare(float size, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      rectMode(CENTER);
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        pushStyle();
        fill((color) tracker.payload[0]);
        rect(0, -tracker.value * scale, size, size);
        popStyle();
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerColorDiamond(float size, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      rectMode(CENTER);
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        pushStyle();
        fill((color) tracker.payload[0]);
        beginShape();
        vertex(0, -size + tracker.value * scale);
        vertex(size, tracker.value * scale);
        vertex(0, size + tracker.value * scale);
        vertex(-size, tracker.value * scale);
        endShape();
        popStyle();
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

    OavpVisualizer trackerColorConnectedRings(float radius, float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        float xInit = 0;
        float yInit = 0;

        pushStyle();
        stroke((color) tracker.payload[tracker.payload.length - 1]);
        beginShape();
        for (int i = 0; i < tracker.payload.length - 1; ++i) {
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

        for (int i = 0; i < tracker.payload.length - 1; ++i) {
          float x = (tracker.value * scale) * cos(radians(tracker.payload[i]));
          float y = (tracker.value * scale) * sin(radians(tracker.payload[i]));
          ellipse(x, y, radius, radius);
        }
        popStyle();
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

    OavpVisualizer trackerChevron(float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        shapes.chevron(0, -tracker.value * scale, currWidth, currHeight);
      }
      return OavpVisualizer.this;
    }

    OavpVisualizer trackerColorChevron(float scale) {
      List trackers = OavpVisualizer.this.currTrackers;
      for (ListIterator<OavpTracker> iter = trackers.listIterator(); iter.hasNext();) {
        OavpTracker tracker = iter.next();
        pushStyle();
        stroke((color) tracker.payload[0]);
        shapes.chevron(0, -tracker.value * scale, currWidth, currHeight);
        popStyle();
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
    pushMatrix();
    scale(scaleFactor);
    image(image, 0, 0);
    popMatrix();
    return this;
  }
}