void setupExamples() {
  entities.addCamera("default");

  entities.addGridInterval("example", 10, 10);
}

void updateExamples() {
  entities.getGridInterval("example").updateDiagonal(analysis.getLevel());

  entities.useCamera("default");
}

void drawExamples() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .useGridInterval("example")
    .create()
    .left().top()
    .dimensions(oavp.w, oavp.h)
    .draw.gridIntervalSquare()
    .done();
}

void keyPressed() {
  if (key == 'W') {
    entities.getCamera("default").moveForward(250);
  }
  if (key == 'S') {
    entities.getCamera("default").moveBackward(250);
  }
  if (key == 'w') {
    entities.getCamera("default").moveUp(250);
  }
  if (key == 's') {
    entities.getCamera("default").moveDown(250);
  }
  if (key == 'a') {
    entities.getCamera("default").moveLeft(250);
  }
  if (key == 'd') {
    entities.getCamera("default").moveRight(250);
  }
}