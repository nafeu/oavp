void setupSketch() {
  entities.addCamera("default");
  entities.addCounter("a").duration(0.5).easing(Ani.QUAD_IN_OUT);
  entities.addCounter("b").duration(1).easing(Ani.QUAD_IN_OUT);
  entities.addCounter("c").duration(1.5).easing(Ani.QUAD_IN_OUT);
  entities.addCounter("d").duration(2).easing(Ani.QUAD_IN_OUT);
  entities.addCounter("e").duration(2.5).easing(Ani.QUAD_IN_OUT);
  entities.addToggle("a").duration(0.5).easing(Ani.QUAD_IN_OUT);
  entities.addToggle("b").duration(1).easing(Ani.QUAD_IN_OUT);
  entities.addToggle("c").duration(1.5).easing(Ani.QUAD_IN_OUT);
  entities.addToggle("d").duration(2).easing(Ani.QUAD_IN_OUT);
  entities.addToggle("e").duration(2.5).easing(Ani.QUAD_IN_OUT);
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
      .imageTint(palette.flat.blue, 70)
      .draw.movie("test-video", 1)
    .endStyle()
    .done();

  visualizers
    .create().center().middle().rotate(0, 0, entities.getCounter("a").getValue() * 45).draw.basicSquare(50 + (entities.getToggle("a").getValue() * 50))
    .next().center().middle().rotate(0, 0, entities.getCounter("b").getValue() * 45).draw.basicSquare(100 + (entities.getToggle("b").getValue() * 100))
    .next().center().middle().rotate(0, 0, entities.getCounter("c").getValue() * 45).draw.basicSquare(150 + (entities.getToggle("c").getValue() * 150))
    .next().center().middle().rotate(0, 0, entities.getCounter("d").getValue() * 45).draw.basicSquare(200 + (entities.getToggle("d").getValue() * 200))
    .next().center().middle().rotate(0, 0, entities.getCounter("e").getValue() * 45).draw.basicSquare(250 + (entities.getToggle("e").getValue() * 250))
    .done();
}

void keyPressed() {
  if (key == 'q') {
    entities.getCounter("a").increment();
    entities.getCounter("b").increment();
    entities.getCounter("c").increment();
    entities.getCounter("d").increment();
    entities.getCounter("e").increment();
  }
  if (key == 'e') {
    entities.getToggle("a").softToggle();
    entities.getToggle("b").softToggle();
    entities.getToggle("c").softToggle();
    entities.getToggle("d").softToggle();
    entities.getToggle("e").softToggle();
  }
}