void addHorizon() {
  objects.add("Horizon", "Rectangle")
    .set("x",0)
    .set("y",20000)
    .set("z",-40000)
    .set("w",100000.0)
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

void presetOne() { addHorizon(); }
void presetTwo() { randomizeAllColors(); }
void presetThree() {}
void presetFour() {}
void presetFive() {}
void presetSix() {}
void presetSeven() {}
void presetEight() {}
void presetNine() {}

