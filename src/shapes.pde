public class OavpShape {

  OavpShape() {}

  void flatbox(float x, float y, float z, float width, float height, float depth) {
    float[] a = { x, y, z };
    float[] b = { x + width, y, z };
    float[] c = { x + width, y, z + depth };
    float[] d = { x, y, z + depth };
    float[] e = { x, y + height, z };
    float[] f = { x + width, y + height, z };
    float[] g = { x + width, y + height, z + depth };
    float[] h = { x, y + height, z + depth };

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
    fill(style.flat.white);

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

    fill(style.flat.black);

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

  void chevron(float x, float y, float w, float h) {
    pushStyle();
    noFill();
    beginShape();

    // Centered
    vertex(x - w/2, y + h/2);
    vertex(x, y - h/2);
    vertex(x + w/2, y + h/2);

    // Cornered
    // vertex(x, y + h);
    // vertex(x + w/2, y);
    // vertex(x + w, y + h);

    endShape();
    popStyle();
  }

  void hill(float x, float y, float w, float h, float displacement, float scale, int numPoints, float granularity) {

    float[] points = new float[numPoints];
    float distance = w / numPoints;

    for (int i = 0; i < numPoints; ++i) {
      points[i] = (noise(i * granularity) * scale) + displacement;
    }

    beginShape();
    vertex(x, points[points.length - 1]);
    vertex(x, h);
    vertex(w, h);
    for (int i = 0; i < points.length; i++) {
      vertex(w - (i * distance), points[i]);
    }
    vertex(x, points[points.length - 1]);
    endShape();

  }
}