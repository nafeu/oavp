public class OavpShape {

  OavpShape() {}

  void flatbox(float width, float height, float depth, int inputColor) {
    float[] a = { 0, 0, 0 };
    float[] b = { width, 0, 0 };
    float[] c = { width, 0, depth };
    float[] d = { 0, 0, depth };
    float[] e = { 0, height, 0 };
    float[] f = { width, height, 0 };
    float[] g = { width, height, depth };
    float[] h = { 0, height, depth };

    pushStyle();
    noStroke();
    fill(inputColor);

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

}