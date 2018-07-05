void setupExamples() {
  entities.addCamera("default");

  entities.addRhythm("clock")
    .start();

  entities.addColorRotator("example")
    .duration(0.5)
    .easing(Ani.QUAD_IN_OUT)
    .add(palette.flat.red)
    .add(palette.flat.green)
    .add(palette.flat.blue);
}

void updateExamples() {
  entities.getColorRotator("example").rotateIf(entities.onRhythm("clock"));

  entities.useCamera("default");
}

void drawExamples() {
  // palette.reset(palette.flat.black, palette.flat.white, 2);
  background(entities.getColorRotator("example").getColor());
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