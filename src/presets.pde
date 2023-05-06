void addHorizon() {
  print(objects);

  objects.add("Horizon", "Rectangle")
    .set("x",0)
    .set("y",20000)
    .set("z",-30000)
    .set("w",200000.0)
    .set("h",40000.0)
    .set("strokeColor",-1)
    .set("fillColor",-16777216)
    .set("i",1);
}

void randomizeAllColors() {
  for (int i = 0; i < objects.getCount(); i++) {
    editorObjectButtonNext();
    editor.randomAssignment();
  }
}

void randomizePalette() {
  editor.randomPalette();
}

void addNHorizonRectangles(int n) {
  for (int i = 0; i < n; i++) {
    objects.add("HorizonRectangle" + i, "Rectangle")
      .set("x",0)
      .set("y",20000)
      .set("z",-40000 + (getRandomInt(200) * coinFlip()))
      .set("w",200000.0)
      .set("h",40000.0)
      .set("zr", getRandomInt(50) * coinFlip())
      .set("strokeColor",-1)
      .set("fillColor",-16777216)
      .set("i",1);
  }
}

void addHorizonCurve() {
  objects.add("HorizonCurve", "CurvedLine")
    .set("x", getRandomInt(10000) * coinFlip())
    .set("z",-37000)
    .set("w",100000.0)
    .set("h",50000.0)
    .set("paramA", getRandomInt(5000) * coinFlip())
    .set("paramB", getRandomInt(5000) * coinFlip())
    .set("paramC", getRandomInt(5000) * coinFlip())
    .set("paramD", getRandomInt(5000) * coinFlip())
    .set("strokeColor",-1)
    .set("fillColor",-16777216)
    .set("i",1);
}

// TODO: Implement
void addNHorizonShapes(int n) {
  // for (int i = 0; i < n; i++) {
  //   if (random(1) > 0.5) {
  //     objects.add("HorizonShape" + i, "Rectangle")
  //       .set("x",0)
  //       .set("y",20000)
  //       .set("z",-40000 + (getRandomInt(200) * coinFlip()))
  //       .set("w",200000.0)
  //       .set("h",40000.0)
  //       .set("zr", getRandomInt(50) * coinFlip())
  //       .set("strokeColor",-1)
  //       .set("fillColor",-16777216)
  //       .set("i",1);
  //   } else {

  //   }

  // }
}

void presetOne() { randomizeAllColors(); }
void presetTwo() { randomizePalette(); }
void presetThree() {}
void presetFour() {}
void presetFive() {}
void presetSix() {}
void presetSeven() {}
void presetEight() {}
void presetNine() {}

