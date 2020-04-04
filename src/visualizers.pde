class OavpVisualizer {
  public Draw draw;
  private OavpEntityManager entities;
  private OavpPosition cursor;
  private OavpPulser currPulser;
  private OavpInterval currInterval;
  private OavpGridInterval currGridInterval;
  private OavpTerrain currTerrain;
  private float currWidth;
  private float currHeight;
  private List currEmissions;
  private OavpRhythm currRhythm;

  OavpVisualizer(OavpAnalysis analysis, OavpPosition cursor, OavpEntityManager entities) {
    draw = new Draw(analysis);
    this.cursor = cursor;
    this.entities = entities;
  }

  /**
   * Center the drawing origin horizontally
   */
  public OavpVisualizer center() {
    translate(cursor.getCenteredX(), 0);
    return this;
  }

  /**
   * Center the drawing origin vertically
   */
  public OavpVisualizer middle() {
    translate(0, cursor.getCenteredY());
    return this;
  }

  /**
   * Set horizontal drawing origin to left of screen
   */
  public OavpVisualizer left() {
    translate(cursor.getScaledX(), 0);
    return this;
  }

  /**
   * Set horizontal drawing origin to right of screen
   */
  public OavpVisualizer right() {
    translate(cursor.getScaledX() + cursor.xScale, 0);
    return this;
  }

  /**
   * Set vertical drawing origin to top of screen
   */
  public OavpVisualizer top() {
    translate(0, cursor.getScaledY());
    return this;
  }

  /**
   * Set vertical drawing origin to bottom of screen
   */
  public OavpVisualizer bottom() {
    translate(0, cursor.getScaledY() + cursor.yScale);
    return this;
  }

  /**
   * Rotate around relative position to origin
   * @param x the x angle
   */
  public OavpVisualizer rotate(float x) {
    rotateX(radians(x));
    return this;
  }

  /**
   * Rotate around relative position to origin
   * @param x the x angle
   * @param y the y angle
   */
  public OavpVisualizer rotate(float x, float y) {
    rotateX(radians(x));
    rotateY(radians(y));
    return this;
  }

  /**
   * Rotate around relative position to origin
   * @param x the x angle
   * @param y the y angle
   * @param z the z angle
   */
  public OavpVisualizer rotate(float x, float y, float z) {
    rotateX(radians(x));
    rotateY(radians(y));
    rotateZ(radians(z));
    return this;
  }

  /**
   * Rotate around relative position to origin
   * @param x the x angle
   */
  public OavpVisualizer rotateClockwise(float x) {
    rotateZ(radians(x));
    return this;
  }

  /**
   * Instantiates the next visualization
   */
  public OavpVisualizer next() {
    resetShader();
    popMatrix();
    pushMatrix();
    return this;
  }

  /**
   * Translate the drawing origin for the visualizer
   * @param x the x translation
   * @param y the y translation
   */
  public OavpVisualizer move(float x, float y) {
    translate(x, y);
    return this;
  }

  /**
   * Translate the drawing origin for the visualizer
   * @param x the x translation
   * @param y the y translation
   * @param z the z translation
   */
  public OavpVisualizer move(float x, float y, float z) {
    translate(x, y, z);
    return this;
  }

  /**
   * Translate the drawing origin upwards
   * @param distance the displacement
   */
  public OavpVisualizer moveUp(float distance) {
    translate(0, -distance);
    return this;
  }

  /**
   * Translate the drawing origin downwards
   * @param distance the displacement
   */

  public OavpVisualizer moveDown(float distance) {
    translate(0, distance);
    return this;
  }

  /**
   * Translate the drawing origin to the left
   * @param distance the displacement
   */
  public OavpVisualizer moveLeft(float distance) {
    translate(-distance, 0);
    return this;
  }

  /**
   * Translate the drawing origin to the right
   * @param distance the displacement
   */
  public OavpVisualizer moveRight(float distance) {
    translate(distance, 0);
    return this;
  }

  /**
   * Translate the drawing origin backwards
   * @param distance the displacement
   */
  public OavpVisualizer moveBackward(float distance) {
    translate(0, 0, -distance);
    return this;
  }

  /**
   * Translate the drawing origin forwards
   * @param distance the displacement
   */
  public OavpVisualizer moveForward(float distance) {
    translate(0, 0, distance);
    return this;
  }

  /**
   * Instantiate a new visualization
   */
  public OavpVisualizer create() {
    pushMatrix();
    translate(0, 0);
    return this;
  }

  /**
   * Instantiate a new visualization
   * @param x the x translation
   * @param y the y translation
   */
  public OavpVisualizer create(float x, float y) {
    pushMatrix();
    translate(x, y);
    return this;
  }

  /**
   * Instantiate a new visualization
   * @param x the x translation
   * @param y the y translation
   * @param rotationX the X rotation
   * @param rotationY the Y rotation
   */
  public OavpVisualizer create(float x, float y, float rotationX, float rotationY) {
    pushMatrix();
    translate(x, y);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    return this;
  }

  /**
   * Instantiate a new visualization
   * @param x the x translation
   * @param y the y translation
   * @param z the z translation
   */
  public OavpVisualizer create(float x, float y, float z) {
    pushMatrix();
    translate(x, y, z);
    return this;
  }

  /**
   * Instantiate a new visualization
   * @param x the x translation
   * @param y the y translation
   * @param z the z translation
   * @param rotationX the X rotation
   * @param rotationY the Y rotation
   * @param rotationZ the Z rotation
   */
  public OavpVisualizer create(float x, float y, float z, float rotationX, float rotationY, float rotationZ) {
    pushMatrix();
    translate(x, y, z);
    rotateX(radians(rotationX));
    rotateY(radians(rotationY));
    rotateZ(radians(rotationZ));
    return this;
  }

  /**
   * Instantiate a new drawing style
   */
  public OavpVisualizer startStyle() {
    pushStyle();
    return this;
  }

  /**
   * Conclude a drawing style
   */
  public OavpVisualizer endStyle() {
    popStyle();
    return this;
  }

  /**
   * Set no fill styling
   */
  public OavpVisualizer noFillStyle() {
    noFill();
    return this;
  }

  /**
   * Set no stroke styling
   */
  public OavpVisualizer noStrokeStyle() {
    noStroke();
    return this;
  }

  /**
   * Set fill color
   * @param customColor the color
   */
  public OavpVisualizer fillColor(color customColor) {
    if (customColor != 0) {
      fill(customColor);
    } else {
      noFill();
    }
    return this;
  }

  public OavpVisualizer fillColor(String customColor) {
    fill(unhex("FF" + customColor.substring(1)));
    return this;
  }

  /**
   * Set fill color
   * @param customColor the color
   * @param opacity the opacity value
   */
  public OavpVisualizer fillColor(color customColor, float opacity) {
    fill(opacity(customColor, opacity));
    return this;
  }

  /**
   * Set stroke color
   * @param customColor the color
   */
  public OavpVisualizer strokeColor(color customColor) {
    if (customColor != 0) {
      stroke(customColor);
    } else {
      noStroke();
    }
    return this;
  }

  public OavpVisualizer strokeColor(String customColor) {
    stroke(unhex("FF" + customColor.substring(1)));
    return this;
  }

  /**
   * Set stroke color
   * @param customColor the color
   * @param opacity the opacity value
   */
  public OavpVisualizer strokeColor(color customColor, float opacity) {
    stroke(opacity(customColor, opacity));
    return this;
  }

  /**
   * Set stroke weight style
   * @param weight the stroke weight value
   */
  public OavpVisualizer strokeWeightStyle(float weight) {
    strokeWeight(weight);
    return this;
  }

  /**
   * Set image tint
   * @param a the red or hue value
   * @param b the green or saturation value
   */
  public OavpVisualizer imageTint(float a, float b) {
    tint(a, b);
    return this;
  }

  /**
   * Set image tint
   * @param a the red or hue value
   * @param b the green or saturation value
   * @param c the blue or brightness value
   */
  public OavpVisualizer imageTint(float a, float b, float c) {
    tint(a, b, c);
    return this;
  }

  /**
   * Set image tint
   * @param a the red or hue value
   * @param b the green or saturation value
   * @param c the blue or brightness value
   * @param d the alpha value
   */
  public OavpVisualizer imageTint(float a, float b, float c, float d) {
    tint(a, b, c, d);
    return this;
  }

  /**
   * Set image tint
   * @param customColor the color value
   * @param alpha the alpha value
   */
  public OavpVisualizer imageTint(color customColor, float alpha) {
    tint(red(customColor), green(customColor), blue(customColor), alpha);
    return this;
  }

  /**
   * Conclude a visualization draw routine
   */
  public OavpVisualizer done() {
    resetShader();
    popMatrix();
    return this;
  }

  /**
   * Select a Pulser entity to use
   * @param name the name of the Pulser entity
   */
  public OavpVisualizer usePulser(String name) {
    currPulser = entities.getPulser(name);
    return this;
  }

  /**
   * Select an Interval entity to use
   * @param name the name of the interval entity
   */
  public OavpVisualizer useInterval(String name) {
    currInterval = entities.getInterval(name);
    return this;
  }

  public OavpVisualizer useInterval(Object name) {
    currInterval = entities.getInterval((String) name);
    return this;
  }

  /**
   * Select a GridInterval entity to use
   * @param name the name of the GridInterval entity
   */
  public OavpVisualizer useGridInterval(String name) {
    currGridInterval = entities.getGridInterval(name);
    return this;
  }

  /**
   * Select an Emissions entity to use
   * @param name the name of the Emissions entity
   */
  public OavpVisualizer useEmissions(String name) {
    currEmissions = entities.getEmissions(name);
    return this;
  }

  public OavpVisualizer useEmissions(Object name) {
    currEmissions = entities.getEmissions((String) name);
    return this;
  }

  /**
   * Select a Rhythm entity to use
   * @param name the name of the Rhythm entity
   */
  public OavpVisualizer useRhythm(String name) {
    currRhythm = entities.getRhythm(name);
    return this;
  }

  /**
   * Select a Terrain entity to use
   * @param name the name of the Terrain entity
   */
  public OavpVisualizer useTerrain(String name) {
    currTerrain = entities.getTerrain(name);
    return this;
  }

  public OavpVisualizer useShader(String name) {
    shader(entities.getShader(name));
    return this;
  }

  /**
   * Set the current width and height of the visualization
   * @param w the width
   * @param h the height
   */
  public OavpVisualizer dimensions(float w, float h) {
    currWidth = w;
    currHeight = h;
    return this;
  }

  public OavpVisualizer use(OavpVariable variable) {
    this
      .strokeColor(variable.strokeColor())
      .fillColor(variable.fillColor())
      .strokeWeightStyle(variable.strokeWeight())
      .move(variable.x(), variable.y(), variable.z())
      .rotate(variable.xr(), variable.yr(), variable.zr())
      .dimensions(variable.w(), variable.h());
    return this;
  }

  class Draw {

    private OavpAnalysis analysis;

    Draw(OavpAnalysis analysis) {
      this.analysis = analysis;
    }

    /**
     * Draw a basic square
     * @param size the length and width of the square
     * @use draw
     */
    public OavpVisualizer basicSquare(float size) {
      rectMode(CENTER);
      rect(0, 0, size, size);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw a basic square
     * @param size the length and width of the square
     * @param mode the rectangle mode
     * @use draw
     */
    public OavpVisualizer basicSquare(float size, int mode) {
      rectMode(mode);
      rect(0, 0, size, size);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicRectangle(float w, float h) {
      rectMode(CENTER);
      rect(0, 0, w, h);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicRectangle(float w, float h, float r, int mode) {
      rectMode(mode);
      rect(0, 0, w, h, r);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicRectangle(float w, float h, float r) {
      rectMode(CENTER);
      rect(0, 0, w, h, r);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicDashedRectangle(float w, float h, float offset) {
      rectMode(CENTER);
      dash.offset(offset);
      dash.rect(0, 0, w, h);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicEquilateralTriangle(float size) {
      triangle(
        0, -size,
        0 + cos(radians(30)) * size, 0 + sin(radians(30)) * size,
        0 - cos(radians(30)) * size, 0 + sin(radians(30)) * size
      );
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicTriangle(float w, float h) {
      triangle(
        0, -h/2,
        w/2, h/2,
        -w/2, h/2
      );
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicLeftRightTriangle(float w, float h) {
      triangle(
        -w/2, -h/2,
        w/2, h/2,
        -w/2, h/2
      );
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicRightRightTriangle(float w, float h) {
      triangle(
        w/2, -h/2,
        w/2, h/2,
        -w/2, h/2
      );
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicVerticalLine(float w, float h, float l) {
      line(0, -h/2, 0, 0, h/2, l);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicDashedVerticalLine(float w, float h, float l, float offset) {
      dash.offset(offset);
      dash.line(0, -h/2, 0, h/2);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicHorizontalLine(float w, float h, float l) {
      line(-w/2, 0, 0, w/2, 0, l);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicDashedHorizontalLine(float w, float h, float l, float offset) {
      dash.offset(offset);
      dash.line(-w/2, 0, w/2, 0);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicDiagonalLine(float w, float h, float l) {
      line(-w/2, -h/2, 0, w/2, h/2, l);
      return OavpVisualizer.this;
    }


    public OavpVisualizer basicDashedDiagonalLine(float w, float h, float l, float offset) {
      dash.offset(offset);
      dash.line(-w/2, -h/2, w/2, h/2);
      return OavpVisualizer.this;
    }

    // public OavpVisualizer basicLine(float w, float h, float l) {
    //   line(x0, y0, z0, x1, y1, z1);
    //   return OavpVisualizer.this;
    // }

    public OavpVisualizer positionalLines(float distance) {
      line(0 - distance, 0, 0, 0 + distance, 0, 0);
      line(0, 0 - distance, 0, 0, 0 + distance, 0);
      line(0, 0, 0 - distance, 0, 0, 0 + distance);
      return OavpVisualizer.this;
    }

    /**
     * Draw a basic diamond
     * @param size the length and width of the diamond
     * @use draw
     */
    public OavpVisualizer basicDiamond(float size) {
      beginShape();
      vertex(-(size * 0.5), 0);
      vertex(0, -(size * 0.5));
      vertex((size * 0.5), 0);
      vertex(0, (size * 0.5));
      endShape(CLOSE);
      return OavpVisualizer.this;
    }

    /**
     * Draw a basic circle
     * @param radius the radius of the circle
     * @use draw
     */
    public OavpVisualizer basicCircle(float radius) {
      ellipse(0, 0, radius, radius);
      return OavpVisualizer.this;
    }

    /**
     * Draw a basic square with displacement in the Z dimension
     * @param size the length and width of the square
     * @param distance the distance in the Z dimension
     * @use draw
     */
    public OavpVisualizer basicZSquare(float size, float distance) {
      rectMode(CENTER);
      pushMatrix();
      translate(0, 0, distance);
      rect(0, 0, size, size);
      popMatrix();
      rectMode(CORNER);

      return OavpVisualizer.this;
    }

    public OavpVisualizer basicZRectangle(float w, float h, float distance) {
      rectMode(CENTER);
      pushMatrix();
      translate(0, 0, distance);
      rect(0, 0, w, h);
      popMatrix();
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicZRectangle(float w, float h, float distance, float r) {
      rectMode(CENTER);
      pushMatrix();
      translate(0, 0, distance);
      rect(0, 0, w, h, r);
      popMatrix();
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw a mesh generated with an interval of incoming spectrum values
     * @param scale the scale of the mesh
     * @param specSample the sample size to use from incoming spectrum values
     * @use draw
     */
    public OavpVisualizer intervalSpectrumMesh(float scale, int specSample) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int rows = interval.getIntervalSize();
      int cols = analysis.getAvgSize();

      float rowScale = currHeight / rows;
      float colScale = currWidth / cols;

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

    public OavpVisualizer intervalSpectrumPoints(float scale, int specSample) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int rows = interval.getIntervalSize();
      int cols = analysis.getAvgSize();

      float rowScale = currHeight / rows;
      float colScale = currWidth / cols;

      for (int i = 0; i < rows - 1; i++) {
        for (int j = 0; j < cols; j += specSample) {
          float specValA = analysis.scaleSpectrumVal(interval.getIntervalData(i)[j]);
          float specValB = analysis.scaleSpectrumVal(interval.getIntervalData(i + 1)[j]);
          point(j * colScale, i * rowScale, specValA * scale);
          point(j * colScale, (i + 1) * rowScale, specValB * scale);
        }
      }

      return OavpVisualizer.this;
    }

    public OavpVisualizer intervalSpectrumZLines(float scale, int specSample) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int rows = interval.getIntervalSize();
      int cols = analysis.getAvgSize();

      float rowScale = currHeight / rows;
      float colScale = currWidth / cols;

      for (int i = 0; i < rows - 1; i++) {
        for (int j = 0; j < cols; j += specSample) {
          float specValA = analysis.scaleSpectrumVal(interval.getIntervalData(i)[j]);
          float specValB = analysis.scaleSpectrumVal(interval.getIntervalData(i + 1)[j]);
          line(
            j * colScale, i * rowScale, 0,
            j * colScale, i * rowScale, specValA * scale
          );
          line(
            j * colScale, (i + 1) * rowScale, 0,
            j * colScale, (i + 1) * rowScale, specValB * scale
          );
        }
      }

      return OavpVisualizer.this;
    }

    public OavpVisualizer intervalSpectrumXLines(float scale, int specSample) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int rows = interval.getIntervalSize();
      int cols = analysis.getAvgSize();

      float rowScale = currHeight / rows;
      float colScale = currWidth / cols;

      for (int i = 0; i < rows - 1; i++) {
        beginShape(LINES);
        for (int j = 0; j < cols; j += specSample) {
          float specValA = analysis.scaleSpectrumVal(interval.getIntervalData(i)[j]);
          float specValB = analysis.scaleSpectrumVal(interval.getIntervalData(i + 1)[j]);
          vertex(
            j * colScale, i * rowScale, specValA * scale
          );
          vertex(
            j * colScale, (i + 1) * rowScale, specValB * scale
          );
        }
        endShape();
      }

      return OavpVisualizer.this;
    }

    /**
     * Draw a spectrum visualizer with bars
     * @use draw
     */
    public OavpVisualizer basicSpectrumBars() {
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float rawPulser = analysis.getSpectrumVal(i);
        float displayPulser = analysis.scaleSpectrumVal(rawPulser);
        rect(i * (currWidth / avgSize), currHeight, (currWidth / avgSize), -currHeight * displayPulser);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw a spectrum visualizer with bars
     * @use draw
     */
    public OavpVisualizer basicSpectrumLines() {
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize; i++) {
        float rawPulser = analysis.getSpectrumVal(i);
        float displayPulser = analysis.scaleSpectrumVal(rawPulser);
        float xPos = (i * (currWidth / avgSize)) + ((currWidth / avgSize) / 2);
        line(
          xPos,
          currHeight,
          xPos,
          currHeight - (currHeight * displayPulser)
        );
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw a spectrum visualizer as a wire
     * @use draw
     */
    public OavpVisualizer basicSpectrumWire() {
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

    public OavpVisualizer basicSpectrumDotted() {
      int avgSize = analysis.getAvgSize();
      for (int i = 0; i < avgSize - 1; i++) {
        float rawSpectrumValA = analysis.getSpectrumVal(i);
        float rawSpectrumValB = analysis.getSpectrumVal(i + 1);
        point(i * (currWidth / avgSize), -currHeight * analysis.scaleSpectrumVal(rawSpectrumValA) + currHeight);
        point((i + 1) * (currWidth / avgSize), -currHeight * analysis.scaleSpectrumVal(rawSpectrumValB) + currHeight);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw a radial spectrum visualizer as bars
     * @param scale the scale of the visualizer
     * @param rangeStart the starting radius
     * @param rangeEnd the ending radius
     * @param rotation the degree rotation
     * @use draw
     */
    public OavpVisualizer basicSpectrumRadialBars(float scale, float rangeStart, float rangeEnd, float rotation) {
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

    /**
     * Draw a radial spectrum visualizer as a wire
     * @param rangeStart the starting radius
     * @param rangeEnd the ending radius
     * @param rotation the degree rotation
     * @use draw
     */
    public OavpVisualizer basicSpectrumRadialWire(float rangeStart, float rangeEnd, float rotation) {
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

    /**
     * Draw a basic waveform as a wire
     * @use draw
     */
    public OavpVisualizer basicWaveformWire(float scale) {
      beginShape(LINES);
      int audioBufferSize = analysis.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float x1 = map( i, 0, audioBufferSize, 0, currWidth);
        float x2 = map( i + 1, 0, audioBufferSize, 0, currWidth);
        float waveformScale = currHeight * (scale / 5);
        line(
          x1,
          ((analysis.getLeftBuffer(i) + analysis.getRightBuffer(i)) / 2) * waveformScale,
          x2,
          ((analysis.getLeftBuffer(i) + analysis.getRightBuffer(i)) / 2) * waveformScale
        );
      }
      endShape();
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicLeftWaveformWire(float scale) {
      beginShape(LINES);
      int audioBufferSize = analysis.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float x1 = map( i, 0, audioBufferSize, 0, currWidth);
        float x2 = map( i + 1, 0, audioBufferSize, 0, currWidth);
        float waveformScale = currHeight * (scale / 5);
        line(x1, analysis.getLeftBuffer(i) * waveformScale, x2, analysis.getLeftBuffer(i + 1) * waveformScale);
      }
      endShape();
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicRightWaveformWire(float scale) {
      beginShape(LINES);
      int audioBufferSize = analysis.getBufferSize();
      for (int i = 0; i < audioBufferSize - 1; i++) {
        float x1 = map( i, 0, audioBufferSize, 0, currWidth);
        float x2 = map( i + 1, 0, audioBufferSize, 0, currWidth);
        float waveformScale = currHeight * (scale / 5);
        line(x1, analysis.getRightBuffer(i) * waveformScale, x2, analysis.getRightBuffer(i + 1) * waveformScale);
      }
      endShape();
      return OavpVisualizer.this;
    }

    /**
     * Draw a radial waveform visualizer as a wire
     * @param scale the scale of the visualizer
     * @param rangeStart the starting radius
     * @param rangeEnd the ending radius
     * @param rotation the degree rotation
     * @use draw
     */
    public OavpVisualizer basicWaveformRadialWire(float scale, float rangeStart, float rangeEnd, float rotation) {
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

    /**
     * Draw a basic level flatbox
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer basicFlatbox(float w, float h, float l, color visibleColor, color shadeColor) {
      shapes.flatbox(0, 0, 0, w, h, l, visibleColor, shadeColor);
      return OavpVisualizer.this;
    }


    /**
     * Draw a basic level flatbox
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer basicLevelFlatbox(float scale) {
      float rawLeftLevel = analysis.getLeftLevel();
      float rawRightLevel = analysis.getRightLevel();
      float boxLevel = ((analysis.scaleLeftLevel(rawLeftLevel) + analysis.scaleRightLevel(rawRightLevel)) / 2) * scale;
      shapes.flatbox(0, 0, 0, scale, -boxLevel, scale, palette.flat.white, palette.flat.black);
      return OavpVisualizer.this;
    }

    /**
     * Draw a basic level bars
     * @use draw
     */
    public OavpVisualizer basicLevelBars() {
      float rawLeftLevel = analysis.getLeftLevel();
      float rawRightLevel = analysis.getRightLevel();
      rect(0, 0, analysis.scaleLeftLevel(rawLeftLevel) * currWidth, currHeight / 2);
      rect(0, currHeight / 2, analysis.scaleRightLevel(rawRightLevel) * currWidth, currHeight / 2);
      endShape();
      return OavpVisualizer.this;
    }

    /**
     * Draw interval level bars
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer intervalLevelBars(float scale) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      int intervalSize = interval.getIntervalSize();
      for (int i = 0; i < intervalSize; i++) {
        rect(i * (currWidth / intervalSize), currHeight, (currWidth / intervalSize), -analysis.scaleLeftLevel(interval.getIntervalData(i)[0]) * scale);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw a basic level cube
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer basicLevelCube(float scale) {
      float rawLeftLevel = analysis.getLeftLevel();
      float rawRightLevel = analysis.getRightLevel();
      float boxLevel = ((analysis.scaleLeftLevel(rawLeftLevel) + analysis.scaleRightLevel(rawRightLevel)) / 2) * scale;
      box(boxLevel, boxLevel, boxLevel);
      return OavpVisualizer.this;
    }

    public OavpVisualizer basicBox(float w, float h, float l) {
      box(w, h, l);
      return OavpVisualizer.this;
    }

    /**
     * Draw a pulsing flatbox
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer pulserFlatbox(float scale) {
      OavpPulser pulser = OavpVisualizer.this.currPulser;
      shapes.flatbox(0, 0, 0, scale, -pulser.getValue() * scale, scale, palette.flat.white, palette.flat.black);
      return OavpVisualizer.this;
    }

    /**
     * Draw a grid interval level square
     * @use draw
     */
    public OavpVisualizer gridIntervalLevelSquare() {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      rectMode(CENTER);
      float colScale = currWidth / gridInterval.getNumCols();
      float rowScale = currHeight / gridInterval.getNumRows();
      for (int i = 0; i < gridInterval.getNumRows(); i++) {
        for (int j = 0; j < gridInterval.getNumCols(); j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          rect(x, y, gridInterval.getData(i, j) * colScale, gridInterval.getData(i, j) * rowScale);
        }
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw a grid interval level square
     * @use draw
     */
    public OavpVisualizer gridIntervalSquares() {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      rectMode(CENTER);
      float colScale = currWidth / gridInterval.getNumCols();
      float rowScale = currHeight / gridInterval.getNumRows();
      for (int i = 0; i < gridInterval.getNumRows(); i++) {
        for (int j = 0; j < gridInterval.getNumCols(); j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          rect(x, y, constrain(gridInterval.getData(i, j), 0, colScale), constrain(gridInterval.getData(i, j), 0, rowScale));
        }
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw a grid interval diamond
     * @use draw
     */
    public OavpVisualizer gridIntervalDiamond() {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      float colScale = currWidth / gridInterval.getNumCols();
      float rowScale = currHeight / gridInterval.getNumRows();
      for (int i = 0; i < gridInterval.getNumRows(); i++) {
        for (int j = 0; j < gridInterval.getNumCols(); j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          beginShape();
          vertex(x - (gridInterval.getData(i, j) * colScale * 0.5), y);
          vertex(x, y - (gridInterval.getData(i, j) * rowScale * 0.5));
          vertex(x + (gridInterval.getData(i, j) * colScale * 0.5), y);
          vertex(x, y + (gridInterval.getData(i, j) * rowScale * 0.5));
          endShape(CLOSE);
        }
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw a pulser circle
     * @param minRadius the minimum radius of the circle
     * @param maxRadius the maximum radius of the circle
     * @use draw
     */
    public OavpVisualizer pulserCircle(float minRadius, float maxRadius) {
      OavpPulser pulser = OavpVisualizer.this.currPulser;
      ellipseMode(RADIUS);
      float scale = maxRadius - minRadius;
      ellipse(0, 0, pulser.getValue() * scale, pulser.getValue() * scale);
      return OavpVisualizer.this;
    }

    /**
     * Draw a pulser square
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer pulserSquare(float scale) {
      OavpPulser pulser = OavpVisualizer.this.currPulser;
      rectMode(CENTER);
      rect(0, 0, pulser.getValue() * scale, pulser.getValue() * scale);
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw an interval based ghost circle
     * @param minRadius the minimum radius of the circle
     * @param maxRadius the maximum radius of the circle
     * @param trailSize the number of trailing circles
     * @use draw
     */
    public OavpVisualizer intervalGhostCircle(float minRadius, float maxRadius, int trailSize) {
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

    /**
     * Draw an interval based ghost square
     * @param minSize the minimum size of the square
     * @param maxSize the maximum size of the square
     * @param trailSize the number of trailing squares
     * @use draw
     */
    public OavpVisualizer intervalGhostSquare(float minSize, float maxSize, int trailSize) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      rectMode(CENTER);
      float scale = maxSize - minSize;
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        rect(0, 0, interval.getIntervalData(i)[0] * scale, interval.getIntervalData(i)[0] * scale);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer intervalBullseyeCircle(float radius, int trailSize) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      ellipseMode(RADIUS);
      pushStyle();
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        strokeWeight(i);
        ellipse(0, 0, interval.getIntervalData(i)[0] * radius, interval.getIntervalData(i)[0] * radius);
      }
      popStyle();
      return OavpVisualizer.this;
    }

    public OavpVisualizer intervalBullseyeRectangle(float w, float h, int trailSize) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      rectMode(CENTER);
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        rect(0, 0, interval.getIntervalData(i)[0] * w, interval.getIntervalData(i)[0] * h);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer intervalBullseyeBox(float w, float h, float l, int trailSize) {
      OavpInterval interval = OavpVisualizer.this.currInterval;
      for (int i = 0; i < min(trailSize, interval.getIntervalSize()); i++) {
        box(interval.getIntervalData(i)[0] * w, interval.getIntervalData(i)[0] * h, interval.getIntervalData(i)[0] * l);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw a grid interval based grid flatbox
     * @param scale the scale (height) of the visualizer
     * @use draw
     */
    public OavpVisualizer gridIntervalFlatbox(float scale) {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      float colScale = currWidth / gridInterval.getNumCols();
      float rowScale = currHeight / gridInterval.getNumRows();
      for (int i = 0; i < gridInterval.getNumRows(); i++) {
        for (int j = 0; j < gridInterval.getNumCols(); j++) {
          float x = (j * colScale);
          float z = (i * rowScale);
          float finalLevel = analysis.scaleLeftLevel(gridInterval.getData(i, j));
          shapes.flatbox(x, 0, z, colScale, -finalLevel * scale, rowScale, palette.flat.white, palette.flat.black);
        }
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw a grid interval based square
     * @use draw
     */
    public OavpVisualizer gridIntervalSquare() {
      OavpGridInterval gridInterval = OavpVisualizer.this.currGridInterval;
      rectMode(CENTER);
      float colScale = currWidth / gridInterval.getNumCols();
      float rowScale = currHeight / gridInterval.getNumRows();
      for (int i = 0; i < gridInterval.getNumRows(); i++) {
        for (int j = 0; j < gridInterval.getNumCols(); j++) {
          float x = (j * colScale) + (colScale * 0.5);
          float y = (i * rowScale) + (rowScale * 0.5);
          float finalLevel = gridInterval.getData(i, j);
          rect(x, y, finalLevel * colScale, finalLevel * rowScale);
        }
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based spectrum wire
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionSpectrumWire(float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        pushMatrix();
        translate(0, 0, -emission.value * scale);
        beginShape();
        float offset = currWidth / emission.payload.length;
        for (int i = 0; i < emission.payload.length; i++) {
          vertex(i * offset, (currHeight / 2) - analysis.scaleSpectrumVal(emission.payload[i]) * (currHeight / 2));
        }
        endShape();
        rect(0, 0, currWidth, currHeight);
        popMatrix();
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based square
     * @param size the size of the shape
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionSquare(float size, float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      rectMode(CENTER);
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        rect(0, -emission.value * scale, size, size);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based square
     * @param size the size of the shape
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionColorSquare(float size, float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      rectMode(CENTER);
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        pushStyle();
        fill((color) emission.payload[0]);
        rect(0, -emission.value * scale, size, size);
        popStyle();
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based diamond
     * @param size the size of the shape
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionColorDiamond(float size, float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      rectMode(CENTER);
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        pushStyle();
        fill((color) emission.payload[0]);
        beginShape();
        vertex(0, -size + emission.value * scale);
        vertex(size, emission.value * scale);
        vertex(0, size + emission.value * scale);
        vertex(-size, emission.value * scale);
        endShape();
        popStyle();
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based circle
     * @param radius the radius of the circle
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionCircle(float radius, float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        ellipse(0, -emission.value * scale, radius, radius);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw emission based connected rings
     * @param radius the radius of the rings
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionConnectedRings(float radius, float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        float xInit = 0;
        float yInit = 0;

        beginShape();
        for (int i = 0; i < emission.payload.length; ++i) {
          float x = (emission.value * scale) * cos(radians(emission.payload[i]));
          float y = (emission.value * scale) * sin(radians(emission.payload[i]));
          vertex(x, y);
          if (i == 0) {
            xInit = x;
            yInit = y;
          }
        }
        vertex(xInit, yInit);
        endShape();

        for (int i = 0; i < emission.payload.length; ++i) {
          float x = (emission.value * scale) * cos(radians(emission.payload[i]));
          float y = (emission.value * scale) * sin(radians(emission.payload[i]));
          ellipse(x, y, radius, radius);
        }
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw emission based colored connected rings
     * @param radius the radius of the rings
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionColorConnectedRings(float radius, float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        float xInit = 0;
        float yInit = 0;

        pushStyle();
        stroke((color) emission.payload[emission.payload.length - 1]);
        beginShape();
        for (int i = 0; i < emission.payload.length - 1; ++i) {
          float x = (emission.value * scale) * cos(radians(emission.payload[i]));
          float y = (emission.value * scale) * sin(radians(emission.payload[i]));
          vertex(x, y);
          if (i == 0) {
            xInit = x;
            yInit = y;
          }
        }
        vertex(xInit, yInit);
        endShape();

        for (int i = 0; i < emission.payload.length - 1; ++i) {
          float x = (emission.value * scale) * cos(radians(emission.payload[i]));
          float y = (emission.value * scale) * sin(radians(emission.payload[i]));
          ellipse(x, y, radius, radius);
        }
        popStyle();
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based splash square
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionSplashSquare(float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      rectMode(CENTER);
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        rect(0, 0, emission.value * scale, emission.value * scale);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer emissionSplashRectangle(float w, float h) {
      List emissions = OavpVisualizer.this.currEmissions;
      rectMode(CENTER);
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        rect(0, 0, emission.value * w, emission.value * h);
      }
      rectMode(CORNER);
      return OavpVisualizer.this;
    }

    public OavpVisualizer emissionSplashBox(float w, float h, float l) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        box(emission.value * w, emission.value * h, emission.value * l);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based splash circle
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionSplashCircle(float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        ellipse(0, 0, emission.value * scale, emission.value * scale);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based chevron
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionChevron(float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        shapes.chevron(0, -emission.value * scale, currWidth, currHeight);
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw an emission based colored chevron
     * @param scale the scale of the visualizer
     * @use draw
     */
    public OavpVisualizer emissionColorChevron(float scale) {
      List emissions = OavpVisualizer.this.currEmissions;
      for (ListIterator<OavpEmission> iter = emissions.listIterator(); iter.hasNext();) {
        OavpEmission emission = iter.next();
        pushStyle();
        stroke((color) emission.payload[0]);
        shapes.chevron(0, -emission.value * scale, currWidth, currHeight);
        popStyle();
      }
      return OavpVisualizer.this;
    }

    /**
     * Draw terrain hills
     * @param scale the scale of the visualizer
     * @param displacement the displacement from starting terrain data
     * @param windowSize the window of the terrain data
     * @param phaseShift the phase shift through terrain data
     * @param position the position in terrain data
     * @use draw
     */
    public OavpVisualizer terrainHills(float scale, float displacement, int windowSize, int phaseShift, float position) {
      OavpTerrain terrain = OavpVisualizer.this.currTerrain;
      shapes.hill(0, 0, currWidth, currHeight, scale, displacement,
                  terrain.getValues(position, windowSize, phaseShift), position);
      shapes.trees(0, 0, currWidth, currHeight, scale, displacement,
                   terrain.getWindow(position, windowSize, phaseShift), position);
      return OavpVisualizer.this;
    }

    /**
     * Draw a centered svg
     * @param svgName the name of the svg file
     * @param scaleFactor the scale factor of the svg
     * @use draw
     */
    public OavpVisualizer centeredSvg(Object svgName, float scaleFactor) {
      PShape shape = entities.getSvg(svgName);
      pushStyle();
      shape.disableStyle();
      noStroke();
      scale(scaleFactor);
      shape(shape, -(shape.width / 2), -(shape.height / 2));
      popStyle();
      return OavpVisualizer.this;
    }

    /**
     * Draw an image
     * @param imgName the name of the img file
     * @param scaleFactor the scale factor of the image
     * @use draw
     */
    public OavpVisualizer img(String imgName, float scaleFactor) {
      PImage image = entities.getImg(imgName);
      pushMatrix();
      scale(scaleFactor);
      image(image, 0, 0);
      popMatrix();
      return OavpVisualizer.this;
    }

    /**
     * Draw a movie
     * @param movieName the name of the movie file
     * @param scaleFactor the scale factor of the movie
     * @use draw
     */
    public OavpVisualizer movie(String movieName, float scaleFactor) {
      Movie movie = entities.getMovie(movieName);
      pushMatrix();
      scale(scaleFactor);
      image(movie, 0, 0);
      popMatrix();
      return OavpVisualizer.this;
    }
  }

}