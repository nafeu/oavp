public class OavpShape {

  OavpShape() {}

  public void flatbox(float x, float y, float z, float boxWidth, float boxHeight, float boxLength, color visibleColor, color shadeColor) {
    float offsetX = x - (boxWidth/2);
    float offsetY = y - (boxHeight/2);
    float offsetZ = z - (boxLength/2);

    float[] a = { offsetX, offsetY, offsetZ };
    float[] b = { offsetX + boxWidth, offsetY, offsetZ };
    float[] c = { offsetX + boxWidth, offsetY, offsetZ + boxLength };
    float[] d = { offsetX, offsetY, offsetZ + boxLength };
    float[] e = { offsetX, offsetY + boxHeight, offsetZ };
    float[] f = { offsetX + boxWidth, offsetY + boxHeight, offsetZ };
    float[] g = { offsetX + boxWidth, offsetY + boxHeight, offsetZ + boxLength };
    float[] h = { offsetX, offsetY + boxHeight, offsetZ + boxLength };

    // Face 1
    beginShape();
    vertex(a[0], a[1], a[2]);
    vertex(b[0], b[1], b[2]);
    vertex(c[0], c[1], c[2]);
    vertex(d[0], d[1], d[2]);
    endShape(CLOSE);

    // Face 2
    beginShape();
    vertex(e[0], e[1], e[2]);
    vertex(f[0], f[1], f[2]);
    vertex(g[0], g[1], g[2]);
    vertex(h[0], h[1], h[2]);
    endShape(CLOSE);

    pushStyle();
    fill(visibleColor);

    // Face 3
    beginShape();
    vertex(h[0], h[1], h[2]);
    vertex(g[0], g[1], g[2]);
    vertex(c[0], c[1], c[2]);
    vertex(d[0], d[1], d[2]);
    endShape(CLOSE);

    // Face 4
    beginShape();
    vertex(h[0], h[1], h[2]);
    vertex(e[0], e[1], e[2]);
    vertex(a[0], a[1], a[2]);
    vertex(d[0], d[1], d[2]);
    endShape(CLOSE);

    fill(shadeColor);

    // Face 5
    beginShape();
    vertex(e[0], e[1], e[2]);
    vertex(f[0], f[1], f[2]);
    vertex(b[0], b[1], b[2]);
    vertex(a[0], a[1], a[2]);
    endShape(CLOSE);

    // Face 6
    beginShape();
    vertex(g[0], g[1], g[2]);
    vertex(f[0], f[1], f[2]);
    vertex(b[0], b[1], b[2]);
    vertex(c[0], c[1], c[2]);
    endShape(CLOSE);
    popStyle();
  }

  public void flatbox2(float x0, float y0, float z0, float inputW, float inputH, float inputL, color visibleColor, color shadeColor) {
    float x = x0 - (inputW/2);
    float y = y0 - (inputH/2);
    float z = z0 - (inputL/2);

    float boxWidth = x + inputW;
    float boxHeight = y + inputH;
    float boxLength = z + inputL;

    float[] a = { x,        y,         z };
    float[] b = { boxWidth, y,         z };
    float[] c = { x,        boxHeight, z };
    float[] d = { boxWidth, boxHeight, z };

    float[] e = { x,        y,         boxLength };
    float[] f = { boxWidth, y,         boxLength };
    float[] g = { x,        boxHeight, boxLength };
    float[] h = { boxWidth, boxHeight, boxLength };

    pushStyle();
    fill(visibleColor);
    stroke(shadeColor);

    // Face 3
    beginShape();
    vertex(e[0], e[1], e[2]);
    vertex(f[0], f[1], f[2]);
    vertex(h[0], h[1], h[2]);
    vertex(g[0], g[1], g[2]);
    endShape(CLOSE);

    fill(shadeColor);
    stroke(visibleColor);

    // Face 1
    beginShape();
    vertex(a[0], a[1], a[2]);
    vertex(b[0], b[1], b[2]);
    vertex(f[0], f[1], f[2]);
    vertex(e[0], e[1], e[2]);
    endShape(CLOSE);

    // Face 2
    beginShape();
    vertex(c[0], c[1], c[2]);
    vertex(d[0], d[1], d[2]);
    vertex(h[0], h[1], h[2]);
    vertex(g[0], g[1], g[2]);
    endShape(CLOSE);

    // Face 4
    beginShape();
    vertex(a[0], a[1], a[2]);
    vertex(e[0], e[1], e[2]);
    vertex(g[0], g[1], g[2]);
    vertex(c[0], c[1], c[2]);
    endShape(CLOSE);


    // Face 5
    beginShape();
    vertex(a[0], a[1], a[2]);
    vertex(b[0], b[1], b[2]);
    vertex(d[0], d[1], d[2]);
    vertex(c[0], c[1], c[2]);
    endShape(CLOSE);

    // Face 6
    beginShape();
    vertex(b[0], b[1], b[2]);
    vertex(f[0], f[1], f[2]);
    vertex(h[0], h[1], h[2]);
    vertex(d[0], d[1], d[2]);
    endShape(CLOSE);

    popStyle();
  }

  public void squareBasePyramid(float x, float y, float z, float w, float h, float l, color visibleColor, color shadeColor) {
    PVector a = new PVector(x - w/2, y + h/2, z + l/2);
    PVector b = new PVector(x + w/2, y + h/2, z + l/2);
    PVector c = new PVector(x + w/2, y + h/2, z - l/2);
    PVector d = new PVector(x - w/2, y + h/2, z - l/2);
    PVector e = new PVector(x      , y - h/2, z      );

    pushStyle();
    fill(shadeColor);
    stroke(visibleColor);

    // Face 1
    beginShape();
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(e.x, e.y, e.z);
    endShape(CLOSE);

    // Face 2
    beginShape();
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);
    vertex(e.x, e.y, e.z);
    endShape(CLOSE);

    // Face 3
    beginShape();
    vertex(c.x, c.y, c.z);
    vertex(d.x, d.y, d.z);
    vertex(e.x, e.y, e.z);
    endShape(CLOSE);

    // Face 4
    beginShape();
    vertex(d.x, d.y, d.z);
    vertex(a.x, a.y, a.z);
    vertex(e.x, e.y, e.z);
    endShape(CLOSE);

    // Face 5
    beginShape();
    vertex(a.x, a.y, a.z);
    vertex(b.x, b.y, b.z);
    vertex(c.x, c.y, c.z);
    vertex(d.x, d.y, d.z);
    endShape(CLOSE);

    popStyle();
  }

  public void chevron(float x, float y, float w, float h) {
    pushStyle();
    noFill();
    beginShape();

    vertex(x - w/2, y + h/2);
    vertex(x, y - h/2);
    vertex(x + w/2, y + h/2);

    endShape();
    popStyle();
  }

  public void hill(float x, float y, float w, float h, float scale, float displacement, float[] terrain) {
    float distance = w / terrain.length;
    beginShape();
    vertex(x, terrain[terrain.length - 1] * scale + displacement);
    vertex(x, h);
    vertex(w, h);
    for (int i = 0; i < terrain.length; i++) {
      vertex(w - (i * distance), terrain[i] * scale + displacement);
    }
    vertex(x, terrain[terrain.length - 1] * scale + displacement);
    endShape();
  }

  public void hill(float x, float y, float w, float h, float scale, float displacement, float[] terrain, float position) {
    float distance = w / terrain.length;
    beginShape();
    vertex(x, terrain[0] * scale + displacement);
    for (int i = 0; i < terrain.length; i++) {
      float xPos = (1 + i - floorPosDiff(position)) * distance;
      float yPos = terrain[i] * scale + displacement;
      vertex(xPos, yPos);
    }
    vertex(w, terrain[terrain.length - 1] * scale + displacement);
    vertex(w, h);
    vertex(x, h);
    vertex(x, terrain[0] * scale + displacement);
    endShape();
  }

  public void trees(float x, float y, float w, float h, float scale, float displacement, float[][] values, float position) {
    float distance = w / values[0].length;
    for (int i = 0; i < values[0].length; i++) {
      float xPos = (1 + i - floorPosDiff(position)) * distance;
      float yPos = values[0][i] * scale + displacement;
      switch(int(values[1][i])) {
        case 1:
          line(xPos, yPos, xPos, yPos - 20);
          pushMatrix();
          translate(0, 0, 2);
          ellipse(xPos, yPos - 20, 10, 10);
          popMatrix();
          break;
        case 2:
          line(xPos, yPos, xPos, yPos - 40);
          pushMatrix();
          translate(0, 0, 2);
          ellipse(xPos, yPos - 40, 20, 20);
          popMatrix();
          break;
        case 3:
          line(xPos, yPos, xPos, yPos - 60);
          pushMatrix();
          translate(0, 0, 2);
          ellipse(xPos, yPos - 60, 30, 30);
          popMatrix();
          break;
        default:
          break;
      }
    }
    endShape();
  }

  public void dots(float x, float y, float w, float h, float scale, float displacement, float[] terrain) {
    float distance = w / terrain.length;
    beginShape(POINTS);
    for (int i = 0; i < terrain.length; i++) {
      vertex(w - (i * distance), terrain[i] * scale + displacement);
    }
    endShape();
  }

  public void trapezoid(float x, float y, float w, float h, float displacementA, float displacementB) {
    pushStyle();
    fill(palette.flat.black);
    beginShape();
    vertex(x, y + displacementA);
    vertex(x, y + h);
    vertex(x + w, y + h);
    vertex(x + w, y + displacementB);
    vertex(x, y + displacementA);
    endShape(CLOSE);
    popStyle();
  }

  public void cylinder(float x, float y, float h, float radius, int numCircles) {
    float distance = h / numCircles;
    for (int i = 0; i < numCircles; i++) {
      float mult = cos(radians(map(i, 0, numCircles, 0, 360)));
      ellipse(x, y + (i * distance), (radius / 2) + (radius / 2) * mult, distance * 1.25);
    }
  }

  public void curvedLine(
    float xStart, float yStart,
    float xEnd,   float yEnd,
    float x1,     float y1,
    float tightness
  ) {
    curveTightness(tightness);
    beginShape();
    curveVertex(xStart, yStart);
    curveVertex(xStart, yStart);
    curveVertex(x1, y1);
    curveVertex(xEnd, yEnd);
    curveVertex(xEnd, yEnd);
    endShape();
  }

  public void curvedLine(
    float xStart, float yStart,
    float xEnd,   float yEnd,
    float x1,     float y1,
    float x2,     float y2,
    float tightness
  ) {
    curveTightness(tightness);
    beginShape();
    curveVertex(xStart, yStart);
    curveVertex(xStart, yStart);
    curveVertex(x1, y1);
    curveVertex(x2, y2);
    curveVertex(xEnd, yEnd);
    curveVertex(xEnd, yEnd);
    endShape();
  }

  public void goldenRectangle(float x, float y, float size) {
    float h = size;
    float w = size * PHI;

    rectMode(CENTER);
    rect(x, y, w, h);
    rectMode(CORNER);
  }

  public void goldenSpiral(float x, float y, float size) {
    float scale = 0.125;
    float unitSize = size * scale;

    float currentX = x + unitSize * 2.5;
    float currentY = y + unitSize;

    rectMode(CORNER);

    rect(currentX, currentY, unitSize, unitSize); // A
    currentX -= unitSize;
    rect(currentX, currentY, unitSize, unitSize); // B
    currentY += unitSize;
    rect(currentX, currentY, unitSize * 2, unitSize * 2); // C
    currentX += unitSize * 2;
    currentY -= unitSize;
    rect(currentX, currentY, unitSize * 3, unitSize * 3); // D
    currentX -= unitSize * 2;
    currentY -= unitSize * 5;
    rect(currentX, currentY, unitSize * 5, unitSize * 5); // E
    currentX -= unitSize * 8;
    rect(currentX, currentY, unitSize * 8, unitSize * 8); // F

    rectMode(CORNER);
  }

  public void goldenSpiralCircles(float x, float y, float size) {
    float scale = 0.125;
    float unitSize = size * scale;

    float currentX = x + unitSize * 2.5;
    float currentY = y + unitSize;

    rectMode(CORNER);
    ellipseMode(CORNER);

    rect(currentX, currentY, unitSize, unitSize); // A
    ellipse(currentX, currentY, unitSize, unitSize); // A
    currentX -= unitSize;
    rect(currentX, currentY, unitSize, unitSize); // B
    ellipse(currentX, currentY, unitSize, unitSize); // B
    currentY += unitSize;
    rect(currentX, currentY, unitSize * 2, unitSize * 2); // C
    ellipse(currentX, currentY, unitSize * 2, unitSize * 2); // C
    currentX += unitSize * 2;
    currentY -= unitSize;
    rect(currentX, currentY, unitSize * 3, unitSize * 3); // D
    ellipse(currentX, currentY, unitSize * 3, unitSize * 3); // D
    currentX -= unitSize * 2;
    currentY -= unitSize * 5;
    rect(currentX, currentY, unitSize * 5, unitSize * 5); // E
    ellipse(currentX, currentY, unitSize * 5, unitSize * 5); // E
    currentX -= unitSize * 8;
    rect(currentX, currentY, unitSize * 8, unitSize * 8); // F
    ellipse(currentX, currentY, unitSize * 8, unitSize * 8); // F

    rectMode(CORNER);
    ellipseMode(RADIUS);
  }

  public void goldenSpiralCurves(float x, float y, float size) {
    float scale = 0.125;
    float unitSize = size * scale;

    float currentX = x + unitSize * 2.5;
    float currentY = y + unitSize;

    rectMode(CORNER);
    ellipseMode(CENTER);

    rect(currentX, currentY, unitSize, unitSize); // A
    arc(currentX, currentY + unitSize, unitSize * 2, unitSize * 2, PI * 1.5, PI * 2);
    currentX -= unitSize;
    rect(currentX, currentY, unitSize, unitSize); // B
    arc(currentX + unitSize, currentY + unitSize, unitSize * 2, unitSize * 2, PI, PI * 1.5);
    currentY += unitSize;
    rect(currentX, currentY, unitSize * 2, unitSize * 2); // C
    arc(currentX + unitSize * 2, currentY, unitSize * 4, unitSize * 4, PI * 0.5, PI);
    currentX += unitSize * 2;
    currentY -= unitSize;
    rect(currentX, currentY, unitSize * 3, unitSize * 3); // D
    arc(currentX, currentY, unitSize * 6, unitSize * 6, 0, PI * 0.5);
    currentX -= unitSize * 2;
    currentY -= unitSize * 5;
    rect(currentX, currentY, unitSize * 5, unitSize * 5); // E
    arc(currentX, currentY + unitSize * 5, unitSize * 10, unitSize * 10, PI * 1.5, PI * 2);
    currentX -= unitSize * 8;
    rect(currentX, currentY, unitSize * 8, unitSize * 8); // F
    arc(currentX + unitSize * 8, currentY + unitSize * 8, unitSize * 16, unitSize * 16, PI, PI * 1.5);

    rectMode(CORNER);
    ellipseMode(RADIUS);
  }

  public void ruleOfThirds(float x, float y, float size) {
    float unitSize = size / 8;

    float h = size;
    float w = size * PHI;

    float offsetX = x - w/2;
    float offsetY = y - h/2;

    float thirdH = h / 3;
    float thirdW = w / 3;

    rectMode(CENTER);
    ellipseMode(CENTER);

    rect(x, y, w, h);

    line(offsetX, offsetY + thirdH, offsetX + w, offsetY + thirdH);
    line(offsetX, offsetY + thirdH * 2, offsetX + w, offsetY + thirdH * 2);
    line(offsetX + thirdW, offsetY, offsetX + thirdW, offsetY + h);
    line(offsetX + thirdW * 2, offsetY, offsetX + thirdW * 2, offsetY + h);

    ellipse(offsetX + thirdW, offsetY + thirdH, unitSize * 0.41, unitSize * 0.41);
    ellipse(offsetX + thirdW * 2, offsetY + thirdH, unitSize * 0.20, unitSize * 0.20);
    ellipse(offsetX + thirdW, offsetY + thirdH * 2, unitSize * 0.25, unitSize * 0.25);
    ellipse(offsetX + thirdW * 2, offsetY + thirdH * 2, unitSize * 0.14, unitSize * 0.14);

    rectMode(CORNER);
    ellipseMode(RADIUS);
  }

  public void phiGrid(float x, float y, float size) {
    float h = size;
    float w = size * PHI;

    float unitSizeH = h / 8;
    float unitSizeW = w / 13;

    float offsetX = x - w/2;
    float offsetY = y - h/2;

    rectMode(CENTER);
    ellipseMode(CENTER);

    rect(x, y, w, h);

    line(offsetX, offsetY + unitSizeH * 3, offsetX + w, offsetY + unitSizeH * 3);
    line(offsetX, offsetY + unitSizeH * 5, offsetX + w, offsetY + unitSizeH * 5);
    line(offsetX + unitSizeW * 5, offsetY, offsetX + unitSizeW * 5, offsetY + h);
    line(offsetX + unitSizeW * 8, offsetY, offsetX + unitSizeW * 8, offsetY + h);

    rectMode(CORNER);
    ellipseMode(RADIUS);
  }

  public void orbitalCircle(
    float x,             float y,
    float orbitalPlaneX, float orbitalPlaneY,
    float position,
    float circleRadius
  ) {
    float orbitalPosition = position / TWO_PI;
    float satelliteX = x + cos(orbitalPosition) * orbitalPlaneX;
    float satelliteY = y + sin(orbitalPosition) * orbitalPlaneY;

    ellipseMode(CENTER);
    ellipse(satelliteX, satelliteY, circleRadius, circleRadius);
    ellipseMode(RADIUS);
  }

  public void vegetationA1(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);
    float uniqMultiplier = size * uniqueness;

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // Bottom Triangle
    beginShape();
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,                               o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size) - uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Middle Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Top Triangle
    beginShape();
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,                               o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size) - uniqMultiplier, o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (4 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationA2(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);
    float uniqMultiplier = size * map(uniqueness, 0, 1, -1, 1);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // Bottom Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Middle Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (1 * size)                  - trunkHeight, o.z - 1);
    vertex(o.x,              o.y - (4 * size) + uniqMultiplier - trunkHeight, o.z - 1);
    vertex(o.x + (2 * size), o.y - (1 * size)                  - trunkHeight, o.z - 1);
    vertex(o.x - (2 * size), o.y - (1 * size)                  - trunkHeight, o.z - 1);
    endShape();

    // Top Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z - 2);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z - 2);
    vertex(o.x + (2 * size), o.y - (1 * size) - trunkHeight, o.z - 2);
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z - 2);
    endShape();
  }

  public void vegetationA3(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);
    float uniqMultiplier = size * abs(map(uniqueness, 0, 1, -1, 1));

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // Bottom Triangle
    beginShape();
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,                               o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size) - uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Top Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (2 * size)                  - trunkHeight, o.z + 1);
    vertex(o.x,              o.y - (7 * size) + uniqMultiplier - trunkHeight, o.z + 1);
    vertex(o.x + (2 * size), o.y - (2 * size)                  - trunkHeight, o.z + 1);
    vertex(o.x - (2 * size), o.y - (2 * size)                  - trunkHeight, o.z + 1);
    endShape();
  }

  public void vegetationA4(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);
    float uniqMultiplier = size * abs(map(uniqueness, 0, 1, -1, 1));

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Triangle
    beginShape();
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,                               o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size) - uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Third Triangle
    beginShape();
    vertex(o.x - (1 * size) - uniqMultiplier, o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x,                               o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size) + uniqMultiplier, o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size) - uniqMultiplier, o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationA5(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);
    float uniqMultiplier = size * abs(map(uniqueness, 0, 1, -1, 1));

    // First Trunk
    line(o.x, o.y, o.x, o.y - size);

    // Bottom Triangle
    beginShape();
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,                               o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size) - uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x, o.y - (4 * size) - trunkHeight);

    // Top Triangle
    beginShape();
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,                               o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size) - uniqMultiplier, o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size) + uniqMultiplier, o.y - (4 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationB1(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Triangle
    beginShape();
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Third Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fifth Triangle
    beginShape();
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Sixth Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    endShape();

    // Seventh Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    endShape();

    // Eigth Triangle
    beginShape();
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    endShape();

    // Ninth Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationB2(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Triangle
    beginShape();
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Third Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Triangle
    beginShape();
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Fifth Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    endShape();

    // Sixth Triangle
    beginShape();
    vertex(o.x,              o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (4 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationB3(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Third Triangle
    beginShape();
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fifth Triangle
    beginShape();
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Sixth Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    endShape();

    // Seventh Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    endShape();

    // Eigth Triangle
    beginShape();
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    endShape();

    // Sixth Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationB4(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Triangle
    beginShape();
    vertex(o.x             , o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Third Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    endShape();

    // Fifth Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    endShape();

    // Sixth Triangle
    beginShape();
    vertex(o.x             , o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (6 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationB5(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Triangle
    beginShape();
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Third Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Triangle
    beginShape();
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationC1(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Diamond
    beginShape();
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Diamond
    beginShape();
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (2 * size) - trunkHeight, o.z);
    endShape();

    // Third Diamond
    beginShape();
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationC2(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Diamond
    beginShape();
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Diamond
    beginShape();
    vertex(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Middle Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x, o.y - (5 * size) - trunkHeight);

    // Third Diamond
    beginShape();
    vertex(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Diamond
    beginShape();
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationC3(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Diamond
    beginShape();
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Trunk
    line(
      o.x - (1 * size),
      o.y - (2 * size) - trunkHeight,
      o.x - (1 * size),
      o.y - (3 * size) - trunkHeight
    );

    // Third Trunk
    line(
      o.x + (1 * size),
      o.y - (2 * size) - trunkHeight,
      o.x + (1 * size),
      o.y - (3 * size) - trunkHeight
    );

    // Second Diamond
    beginShape();
    vertex(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Third Diamond
    beginShape();
    vertex(o.x             , o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fourth Diamond
    beginShape();
    vertex(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (4 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.z);
    endShape();

    // Fifth Diamond
    beginShape();
    vertex(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    endShape();

    // Sixth Diamond
    beginShape();
    vertex(o.x + (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x             , o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (5 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationC4(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Diamond
    beginShape();
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (2 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Diamond
    beginShape();
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (3 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationC5(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // First Diamond
    beginShape();
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    vertex(o.x - (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x + (2 * size), o.y - (3 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (1 * size) - trunkHeight, o.z);
    endShape();

    // Second Diamond
    beginShape();
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    vertex(o.x - (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (7 * size) - trunkHeight, o.z);
    vertex(o.x + (1 * size), o.y - (6 * size) - trunkHeight, o.z);
    vertex(o.x,              o.y - (5 * size) - trunkHeight, o.z);
    endShape();
  }

  public void vegetationD1(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    rectMode(CORNER);
    // First Rectangle
    rect(o.x - (1 * size), o.y - (2 * size) - trunkHeight, 1 * size, 1 * size);
    // Second Rectangle
    rect(o.x             , o.y - (3 * size) - trunkHeight, 1 * size, 1 * size);
    // Third Rectangle
    rect(o.x + (1 * size), o.y - (4 * size) - trunkHeight, 1 * size, 1 * size);
    // Fourth Rectangle
    rect(o.x             , o.y - (5 * size) - trunkHeight, 1 * size, 1 * size);
    // Fifth Rectangle
    rect(o.x - (1 * size), o.y - (6 * size) - trunkHeight, 1 * size, 1 * size);
    // Sixth Rectangle
    rect(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 1 * size, 1 * size);
    rectMode(CORNER);
  }

  public void vegetationD2(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    rectMode(CORNER);
    // First Rectangle
    rect(o.x             , o.y - (2 * size) - trunkHeight, 1 * size, 1 * size);
    // Second Rectangle
    rect(o.x - (2 * size), o.y - (4 * size) - trunkHeight, 2 * size, 2 * size);
    // Third Rectangle
    rect(o.x             , o.y - (7 * size) - trunkHeight, 2 * size, 3 * size);
    rectMode(CORNER);
  }

  public void vegetationD3(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // Second Trunk
    line(o.x, o.y - (2 * size) - trunkHeight, o.x, o.y - (3 * size) - trunkHeight);

    // Third Trunk
    line(o.x, o.y - (4 * size) - trunkHeight, o.x, o.y - (5 * size) - trunkHeight);

    rectMode(CORNER);
    // First Rectangle
    rect(o.x - (2 * size), o.y - (2 * size) - trunkHeight, 4 * size, 1 * size);
    // Second Rectangle
    rect(o.x - (1 * size), o.y - (4 * size) - trunkHeight, 2 * size, 1 * size);
    // Third Rectangle
    rect(o.x             , o.y - (6 * size) - trunkHeight, 1 * size, 1 * size);
    // Fourth Rectangle
    rect(o.x - (1 * size), o.y - (7 * size) - trunkHeight, 1 * size, 1 * size);
    rectMode(CORNER);
  }

  public void vegetationD4(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // Second Trunk
    line(o.x - (1 * size), o.y - (2 * size) - trunkHeight, o.x - (1 * size), o.y - (3 * size) - trunkHeight);
    // Third Trunk
    line(o.x             , o.y - (3 * size) - trunkHeight, o.x             , o.y - (4 * size) - trunkHeight);
    // Fourth Trunk
    line(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.x + (1 * size), o.y - (4 * size) - trunkHeight);
    // Fifth Trunk
    line(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.x - (1 * size), o.y - (6 * size) - trunkHeight);
    // Sixth Trunk
    line(o.x + (1 * size), o.y - (5 * size) - trunkHeight, o.x + (1 * size), o.y - (6 * size) - trunkHeight);

    rectMode(CORNER);
    // First Rectangle
    rect(o.x - (1 * size), o.y - (2 * size) - trunkHeight, 1 * size, 1 * size);
    // Second Rectangle
    rect(o.x             , o.y - (3 * size) - trunkHeight, 1 * size, 1 * size);
    // Third Rectangle
    rect(o.x - (2 * size), o.y - (4 * size) - trunkHeight, 1 * size, 1 * size);
    // Fourth Rectangle
    rect(o.x - (1 * size), o.y - (5 * size) - trunkHeight, 1 * size, 1 * size);
    // Fifth Rectangle
    rect(o.x + (1 * size), o.y - (5 * size) - trunkHeight, 1 * size, 1 * size);
    // Six Rectangle
    rect(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 1 * size, 1 * size);
    // Seventh Rectangle
    rect(o.x             , o.y - (7 * size) - trunkHeight, 1 * size, 1 * size);
    rectMode(CORNER);
  }

  public void vegetationD5(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // Second Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x, o.y - (4 * size) - trunkHeight);

    rectMode(CORNER);
    // First Rectangle
    rect(o.x             , o.y - (2 * size) - trunkHeight, 2 * size, 1 * size);
    // Second Rectangle
    rect(o.x - (2 * size), o.y - (3 * size) - trunkHeight, 2 * size, 1 * size);
    // Third Rectangle
    rect(o.x             , o.y - (5 * size) - trunkHeight, 2 * size, 1 * size);
    // Fourth Rectangle
    rect(o.x - (2 * size), o.y - (6 * size) - trunkHeight, 2 * size, 1 * size);
    // Fifth Rectangle
    rect(o.x             , o.y - (7 * size) - trunkHeight, 1 * size, 1 * size);
    rectMode(CORNER);
  }

  public void vegetationE1(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - (6 * size) - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x             , o.y - (2 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Second Semi-Circle
    arc(o.x - (2 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Third Semi-Circle
    arc(o.x             , o.y - (4 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x - (2 * size), o.y - (5 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x             , o.y - (6 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Sixth Semi-Circle
    arc(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    ellipseMode(RADIUS);
  }

  public void vegetationE2(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (2 * size), o.y - (2 * size) - trunkHeight, 4 * size, 2 * size, PI, TWO_PI, CHORD);
    // Second Semi-Circle
    arc(o.x - (2 * size), o.y - (4 * size) - trunkHeight, 4 * size, 4 * size, PI, TWO_PI, CHORD);
    // Third Semi-Circle
    arc(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 4 * size, 6 * size, PI, TWO_PI, CHORD);
    ellipseMode(RADIUS);
  }

  public void vegetationE3(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    // Second Trunk
    line(o.x - (1 * size), o.y - (1 * size) - trunkHeight, o.x - (1 * size), o.y - (2 * size) - trunkHeight);
    // Third Trunk
    line(o.x + (1 * size), o.y - (1 * size) - trunkHeight, o.x + (1 * size), o.y - (2 * size) - trunkHeight);
    // Fourth Trunk
    line(o.x             , o.y - (2 * size) - trunkHeight, o.x             , o.y - (3 * size) - trunkHeight);
    // Fifth Trunk
    line(o.x - (1 * size), o.y - (3 * size) - trunkHeight, o.x - (1 * size), o.y - (4 * size) - trunkHeight);
    // Sixth Trunk
    line(o.x + (1 * size), o.y - (3 * size) - trunkHeight, o.x + (1 * size), o.y - (4 * size) - trunkHeight);
    // Seventh Trunk
    line(o.x             , o.y - (4 * size) - trunkHeight, o.x             , o.y - (5 * size) - trunkHeight);
    // Eight Trunk
    line(o.x - (1 * size), o.y - (5 * size) - trunkHeight, o.x - (1 * size), o.y - (6 * size) - trunkHeight);
    // Ninth Trunk
    line(o.x + (1 * size), o.y - (5 * size) - trunkHeight, o.x + (1 * size), o.y - (6 * size) - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (1 * size), o.y - (2 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Second Semi-Circle
    arc(o.x - (2 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Third Semi-Circle
    arc(o.x             , o.y - (3 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x - (1 * size), o.y - (4 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x - (2 * size), o.y - (5 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Sixth Semi-Circle
    arc(o.x             , o.y - (5 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Seventh Semi-Circle
    arc(o.x - (1 * size), o.y - (6 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Eigth Semi-Circle
    arc(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Ninth Semi-Circle
    arc(o.x             , o.y - (7 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    ellipseMode(RADIUS);
  }

  public void vegetationE4(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (1 * size), o.y - (2 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Second Semi-Circle
    arc(o.x - (2 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Third Semi-Circle
    arc(o.x - (1 * size), o.y - (4 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x             , o.y - (5 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x - (1 * size), o.y - (6 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Sixth Semi-Circle
    arc(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    ellipseMode(RADIUS);
  }

  public void vegetationE5(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (2 * size), o.y - (2 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Second Semi-Circle
    arc(o.x             , o.y - (2 * size) - trunkHeight, 2 * size, 2 * size, PI, TWO_PI, CHORD);
    // Third Semi-Circle
    arc(o.x - (2 * size), o.y - (4 * size) - trunkHeight, 2 * size, 4 * size, PI, TWO_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x             , o.y - (4 * size) - trunkHeight, 2 * size, 4 * size, PI, TWO_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 2 * size, 6 * size, PI, TWO_PI, CHORD);
    // Sixth Semi-Circle
    arc(o.x             , o.y - (7 * size) - trunkHeight, 2 * size, 6 * size, PI, TWO_PI, CHORD);
    ellipseMode(RADIUS);
  }

  public void vegetationF1(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Circle
    ellipse(o.x - (1 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size);
    // Second Circle
    ellipse(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 4 * size, 4 * size);
    ellipseMode(RADIUS);
  }

  public void vegetationF2(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - (6 * size) - trunkHeight);

    ellipseMode(CORNER);
    // First Circle
    ellipse(o.x - (1 * size), o.y - (2 * size) - trunkHeight, 1 * size, 1 * size);
    // Second Circle
    ellipse(o.x - (2 * size), o.y - (3 * size) - trunkHeight, 1 * size, 1 * size);
    // Third Circle
    ellipse(o.x             , o.y - (3 * size) - trunkHeight, 1 * size, 1 * size);
    // Fourth Circle
    ellipse(o.x + (1 * size), o.y - (4 * size) - trunkHeight, 1 * size, 1 * size);
    // Fifth Circle
    ellipse(o.x - (1 * size), o.y - (5 * size) - trunkHeight, 1 * size, 1 * size);
    // Sixth Circle
    ellipse(o.x - (2 * size), o.y - (6 * size) - trunkHeight, 1 * size, 1 * size);
    // Seventh Circle
    ellipse(o.x             , o.y - (6 * size) - trunkHeight, 1 * size, 1 * size);
    // Eigth Circle
    ellipse(o.x + (1 * size), o.y - (7 * size) - trunkHeight, 1 * size, 1 * size);
    ellipseMode(RADIUS);
  }

  public void vegetationF3(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Circle
    ellipse(o.x - (1 * (size / 2)), o.y - (2 * size) - trunkHeight, 1 * size, 1 * size);
    // Second Circle
    ellipse(o.x - (1 * size), o.y - (7 * size) - trunkHeight, 2 * size, 6 * size);
    ellipseMode(RADIUS);
  }

  public void vegetationF4(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - (5 * size) - trunkHeight);

    pushMatrix();
    translate(0, 0, -1);
    ellipseMode(CORNER);
    // First Circle
    ellipse(o.x - (2 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size);
    // Second Circle
    ellipse(o.x             , o.y - (4 * size) - trunkHeight, 2 * size, 2 * size);
    // Third Circle
    ellipse(o.x - (2 * size), o.y - (5 * size) - trunkHeight, 2 * size, 2 * size);
    // Fourth Circle
    ellipse(o.x             , o.y - (6 * size) - trunkHeight, 2 * size, 2 * size);
    // Fifth Circle
    ellipse(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 2 * size, 2 * size);
    ellipseMode(RADIUS);
    popMatrix();

    // Second Trunk
    line(o.x, o.y - (1 * size) - trunkHeight, o.x - (1 * size), o.y - (2 * size) - trunkHeight);
    // Third Trunk
    line(o.x, o.y - (2 * size) - trunkHeight, o.x + (1 * size), o.y - (3 * size) - trunkHeight);
    // Fourth Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x - (1 * size), o.y - (4 * size) - trunkHeight);
    // Fifth Trunk
    line(o.x, o.y - (4 * size) - trunkHeight, o.x + (1 * size), o.y - (5 * size) - trunkHeight);
    // Sixth Trunk
    line(o.x, o.y - (5 * size) - trunkHeight, o.x - (1 * size), o.y - (6 * size) - trunkHeight);
  }

  public void vegetationF5(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Circle
    ellipse(o.x - (1 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size);
    // Second Circle
    ellipse(o.x - (1 * size), o.y - (5 * size) - trunkHeight, 2 * size, 2 * size);
    // Third Circle
    ellipse(o.x - (1 * size), o.y - (7 * size) - trunkHeight, 2 * size, 2 * size);
    ellipseMode(RADIUS);
  }

  public void vegetationG1(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - (5 * size) - trunkHeight);

    pushMatrix();
    translate(0, 0, -1);
    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (2 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Second Semi-Circle
    arc(o.x             , o.y - (4 * size) - trunkHeight, 2 * size, 2 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Third Semi-Circle
    arc(o.x - (2 * size), o.y - (5 * size) - trunkHeight, 2 * size, 2 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x             , o.y - (6 * size) - trunkHeight, 2 * size, 2 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x - (2 * size), o.y - (7 * size) - trunkHeight, 2 * size, 2 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    ellipseMode(RADIUS);
    popMatrix();

    // Second Trunk
    line(o.x, o.y - (1 * size) - trunkHeight, o.x - (1 * size), o.y - (2 * size) - trunkHeight);
    // Third Trunk
    line(o.x, o.y - (2 * size) - trunkHeight, o.x + (1 * size), o.y - (3 * size) - trunkHeight);
    // Fourth Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x - (1 * size), o.y - (4 * size) - trunkHeight);
    // Fifth Trunk
    line(o.x, o.y - (4 * size) - trunkHeight, o.x + (1 * size), o.y - (5 * size) - trunkHeight);
    // Sixth Trunk
    line(o.x, o.y - (5 * size) - trunkHeight, o.x - (1 * size), o.y - (6 * size) - trunkHeight);
  }

  public void vegetationG2(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (1 * size), o.y - (3 * size) - trunkHeight, 2 * size, 2 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Second Semi-Circle
    arc(o.x - (2 * size), o.y - (4 * size) - trunkHeight, 2 * size, 2 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Third Semi-Circle
    arc(o.x - (1 * size), o.y - (4 * size) - trunkHeight, 2 * size, 2 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x             , o.y - (5 * size) - trunkHeight, 2 * size, 2 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x - (1 * size), o.y - (6 * size) - trunkHeight, 2 * size, 2 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Sixth Semi-Circle
    arc(o.x - (1 * size), o.y - (7 * size) - trunkHeight, 2 * size, 2 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    ellipseMode(RADIUS);
  }

  public void vegetationG3(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - size - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (1 * size), o.y - (2 * size) - trunkHeight, 2 * size, 1 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Second Semi-Circle
    arc(o.x             , o.y - (3 * size) - trunkHeight, 2 * size, 2 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Third Semi-Circle
    arc(o.x - (1 * size), o.y - (4 * size) - trunkHeight, 2 * size, 2 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x             , o.y - (6 * size) - trunkHeight, 2 * size, 3 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x - (1 * size), o.y - (7 * size) - trunkHeight, 2 * size, 3 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    ellipseMode(RADIUS);

    // Second Trunk
    line(o.x, o.y - (1 * size) - trunkHeight, o.x + (1 * size), o.y - (2 * size) - trunkHeight);
    // Third Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x + (1 * size), o.y - (4 * size) - trunkHeight);
  }

  public void vegetationG4(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - (6 * size) - (size/2) - trunkHeight);

    pushMatrix();
    translate(0, 0, -1);
    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (1 * size), o.y - (7 * size) - trunkHeight, 4 * size, 6 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    ellipseMode(RADIUS);
    popMatrix();

    // Second Trunk
    line(o.x, o.y - (2 * size) - trunkHeight, o.x + (1 * size), o.y - (3 * size) - trunkHeight);
    // Third Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x - (1 * size), o.y - (4 * size) - trunkHeight);
    // Fourth Trunk
    line(o.x, o.y - (4 * size) - trunkHeight, o.x + (1 * size), o.y - (5 * size) - trunkHeight);
  }

  public void vegetationG5(float x, float y, float size, float trunkHeight, float uniqueness) {
    PVector o = new PVector(x, y, 0);

    // Trunk
    line(o.x, o.y, o.x, o.y - (6 * size) - trunkHeight);

    ellipseMode(CORNER);
    // First Semi-Circle
    arc(o.x - (1 * size), o.y - (2 * size) - trunkHeight, 2 * size, 1 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Second Semi-Circle
    arc(o.x - (1 * size), o.y - (3 * size) - trunkHeight, 2 * size, 1 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Third Semi-Circle
    arc(o.x             , o.y - (3 * size) - trunkHeight, 2 * size, 1 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Fourth Semi-Circle
    arc(o.x - (2 * size), o.y - (4 * size) - trunkHeight, 2 * size, 1 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Fifth Semi-Circle
    arc(o.x - (1 * size), o.y - (4 * size) - trunkHeight, 2 * size, 1 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Sixth Semi-Circle
    arc(o.x - (1 * size), o.y - (5 * size) - trunkHeight, 2 * size, 1 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Seventh Semi-Circle
    arc(o.x             , o.y - (5 * size) - trunkHeight, 2 * size, 1 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Eigth Semi-Circle
    arc(o.x - (2 * size), o.y - (6 * size) - trunkHeight, 2 * size, 1 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Ninth Semi-Circle
    arc(o.x - (1 * size), o.y - (6 * size) - trunkHeight, 2 * size, 1 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    // Tenth Semi-Circle
    arc(o.x - (1 * size), o.y - (7 * size) - trunkHeight, 2 * size, 1 * size, PI - HALF_PI, TWO_PI - HALF_PI, CHORD);
    // Eleventh Semi-Circle
    arc(o.x             , o.y - (7 * size) - trunkHeight, 2 * size, 1 * size, PI + HALF_PI, TWO_PI + HALF_PI, CHORD);
    ellipseMode(RADIUS);

    // Second Trunk
    line(o.x, o.y - (2 * size) - trunkHeight, o.x + (1 * size), o.y - (3 * size) - trunkHeight);
    // Third Trunk
    line(o.x, o.y - (3 * size) - trunkHeight, o.x - (1 * size), o.y - (4 * size) - trunkHeight);
    // Fourth Trunk
    line(o.x, o.y - (4 * size) - trunkHeight, o.x + (1 * size), o.y - (5 * size) - trunkHeight);
    // Fifth Trunk
    line(o.x, o.y - (5 * size) - trunkHeight, o.x - (1 * size), o.y - (6 * size) - trunkHeight);
    // Sixth Trunk
    line(o.x, o.y - (6 * size) - trunkHeight, o.x + (1 * size), o.y - (7 * size) - trunkHeight);
  }
}
