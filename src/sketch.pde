void setupSketch() {
  entities.addCamera("default");

  entities.addPulser("a").duration(2).easing(Ani.EXPO_OUT);
}

void updateSketch() {

  entities.useCamera("default");
}

void drawSketch() {
  palette.reset(palette.flat.black, palette.flat.white, 2);

  visualizers
    .create()
    .top().left()
    .moveLeft(500)
    .startStyle()
      .imageTint(palette.flat.blue, 20 + entities.getPulser("a").getValue() * 50)
      .draw.movie("test-video", 1)
    .endStyle()
    .done();

  visualizers
    .create()
    .center().middle()
    .draw.basicSquare(100)
    .done();
}

void keyPressed() {
  if (key == 'q') {
    entities.getPulser("a").pulse();
  }
}