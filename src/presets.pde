void addHorizon() {
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
void presetThree() { addHorizon(); }
void presetFour() { addNHorizonRectangles(getRandomInt(5)); }
void presetFive() { addHorizonCurve(); }
void presetSix() { printObjectInfo(); }
void presetSeven() {
  editor.directEdit("z", -30000);
}
void presetEight() {}
void presetNine() {}

void queueFauxTimelapse() {
  objects.add("Square", "Rectangle")
    .set("x", 0)
    .set("y", 0)
    .set("zr", 0)
    .set("w", 100)
    .set("h", 100);

  editor.toggleEditMode();

  delay(3000);
  int DELAY_MS = 100;

  HashMap<String, float[]> finalObjectValues = new HashMap<String, float[]>();

  finalObjectValues.put("x",  new float[]{0, 200});
  finalObjectValues.put("y",  new float[]{0, 200});
  finalObjectValues.put("zr", new float[]{0, 45});
  finalObjectValues.put("w",  new float[]{100, 300});
  finalObjectValues.put("h",  new float[]{100, 400});

  for (Map.Entry finalObjectValueEntry : finalObjectValues.entrySet()) {
    float[] finalObjectValueArray = (float[]) finalObjectValueEntry.getValue();

    float[] progression = generateProgression(
      finalObjectValueArray[0],
      finalObjectValueArray[1],
      getRandomIntInRange(5, 20) // INCREMENT STEPS
    );

    for (int i = 0; i < progression.length; i++) {
      float stepValue = progression[i];

      editor.directEdit((String) finalObjectValueEntry.getKey(), stepValue);

      delay(DELAY_MS);
    }
  }
}

void printObjectInfo() {

}
