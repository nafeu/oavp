void setupSketch() {
  entities.addCamera("default");

  entities.addOscillators("b", "c", "d", "e");

  palette
    .add("a", #B33771)
    .add("b", #3B3B98)
    .add("c", #F8EFBA)
    .add("d", #1B9CFC)
    .add("e", #F97F51);

  entities.addColorRotator("colorA").add(palette);
  entities.addColorRotator("colorB").add(palette).displace(1);
  entities.addColorRotator("colorC").add(palette).displace(2);
  entities.addColorRotator("colorD").add(palette).displace(3);
  entities.addColorRotator("colorE").add(palette).displace(4);
}

void updateSketch() {
  entities.getCamera("default").rotateAroundY(frameCount(0.3), oavp.width(0.4));

  entities.useCamera("default");
}

void drawSketch() {
  palette.reset(entities.getColorRotator("colorA").getColor(), palette.flat.white, 4);

  visualizers
    .create().center().middle().moveBackward(75)
    .startStyle().strokeColor(entities.getColorRotator("colorB").getColor())
    .draw.basicSquare(oavp.width(0.5) * entities.getOscillator("b").getValue())
    .next().center().middle().moveBackward(50).rotate(0, 0, 22.5)
    .startStyle().strokeColor(entities.getColorRotator("colorC").getColor())
    .draw.basicSquare(oavp.width(0.4) * entities.getOscillator("c").getValue())
    .next().center().middle().moveBackward(25).rotate(0, 0, 45)
    .startStyle().strokeColor(entities.getColorRotator("colorD").getColor())
    .draw.basicSquare(oavp.width(0.3) * entities.getOscillator("d").getValue())
    .next().center().middle().rotate(0, 0, 45 + 22.5)
    .startStyle().strokeColor(entities.getColorRotator("colorE").getColor())
    .draw.basicSquare(oavp.width(0.2) * entities.getOscillator("e").getValue())
    .done();
}

void keyPressed() {
  if (key == 'q') {
    entities.getColorRotator("colorA").duration(2).rotate();
    entities.getColorRotator("colorB").duration(2).rotate();
    entities.getColorRotator("colorC").duration(2).rotate();
    entities.getColorRotator("colorD").duration(2).rotate();
    entities.getColorRotator("colorE").duration(2).rotate();
  }
  if (key == 'w') { entities.getOscillator("b").duration(2).easing(Ani.CUBIC_IN_OUT).restart(); }
  if (key == 'e') { entities.getOscillator("c").duration(2).easing(Ani.CUBIC_IN_OUT).restart(); }
  if (key == 'r') { entities.getOscillator("d").duration(2).easing(Ani.CUBIC_IN_OUT).restart(); }
  if (key == 't') { entities.getOscillator("e").duration(2).easing(Ani.CUBIC_IN_OUT).restart(); }
}