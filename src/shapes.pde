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
    float x1,     float y1
  ) {
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
    float x2,     float y2
  ) {
    beginShape();
    curveVertex(xStart, yStart);
    curveVertex(xStart, yStart);
    curveVertex(x1, y1);
    curveVertex(x2, y2);
    curveVertex(xEnd, yEnd);
    curveVertex(xEnd, yEnd);
    endShape();
  }
}