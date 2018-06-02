List<Point> points = new ArrayList<Point>();
int numPoints = 10;
float phase;

public class Point {
  float x;
  float y;
  color indicator;
  float start;
  int numPoints;
  int index;
  float distance;
  Point prev;
  Point next;

  Point(float curr, int numPoints, float distance, int index) {
    start = curr;
    indicator = palette.getRandomColor();
    this.numPoints = numPoints;
    this.distance = distance;
    this.index = index;
    x = (index * distance / numPoints);
    y = refinedNoise(index, 0.15);
  }

  void update(float curr, List points) {
    float spacing = distance / numPoints;

    if (curr - start >= 1.0) {
      increase(curr, points);
      start += 1.0;
    } else if (curr - start < 0.0) {
      decrease(curr);
      start -= 1.0;
    }

    float displacement = curr - start;
    x = (index * spacing) + (displacement * spacing);
  }

  void increase(float curr, List points) {
    if (index == 0) {
      for (int i = points.size() - 1; i > 0; i--) {
        Point p = (Point) points.get(i);
        p.y = p.prev.y;
      }
      y = refinedNoise(curr, 0.15);
    }
  }

  void decrease(float curr) {
    if (index == 0) {
      y = next.y;
    } else if (index < numPoints - 1) {
      y = next.y;
    } else {
      y = refinedNoise(curr - index, 0.15);
    }
  }

  void linkPrev(Point prev) {
    this.prev = prev;
  }

  void linkNext(Point next) {
    this.next = next;
  }

  void link(Point prev, Point next) {
    this.prev = prev;
    this.next = next;
  }
}

void setupExamples() {
  noiseSeed(1);

  entities.addOscillator("rotation")
    .duration(40)
    .easing(Ani.SINE_IN_OUT)
    .start();

  phase = entities.getOscillator("rotation").getValue() * numPoints * 10;

  for (int i = 0; i < numPoints; ++i) {
    points.add(new Point(phase, numPoints, oavp.STAGE_WIDTH, i));
  }

  for (int i = 0; i < points.size(); i++) {
    Point p = points.get(i);

    if (i == 0) {
      p.linkNext(points.get(i + 1));
    } else if (i < points.size() - 1) {
      p.link(points.get(i - 1), points.get(i + 1));
    } else {
      p.linkPrev(points.get(i - 1));
    }
  }
}

void updateExamples() {
  phase = entities.getOscillator("rotation").getValue() * numPoints * 10;

  entities.update();
  for (Point p : points) {
    p.update(phase, points);
  }
}

void drawExamples() {
  background(palette.flat.black);
  stroke(palette.flat.white);
  noFill();
  strokeWeight(2);

  rect(0, 0, oavp.STAGE_WIDTH, oavp.STAGE_HEIGHT);

  beginShape();
  for (Point p : points) {
    curveVertex(p.x, p.y * oavp.STAGE_HEIGHT);
  }
  endShape();

  beginShape();
  for (Point p : points) {
    if (int(p.y * 10) == 4) {
      ellipse(p.x, p.y * oavp.STAGE_HEIGHT, 10, 10);
    }
  }
  endShape();
}