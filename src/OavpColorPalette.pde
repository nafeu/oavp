public class OavpColorPalette {

  HashMap<String, color[]> storage;

  OavpColorPalette() {
    storage = new HashMap<String, color[]>();
  }

  void add(String name, color colorA) {
    color[] colors = new color[1];
    colors[0] = colorA;
    storage.put(name, colors);
  }

  void add(String name, color colorA, color colorB) {
    color[] colors = new color[2];
    colors[0] = colorA;
    colors[1] = colorB;
    storage.put(name, colors);
  }

  color get(String name) {
    return storage.get(name)[0];
  }

  color get(String name, float interpolation) {
    color[] colors = storage.get(name);
    if (colors.length == 1) {
      return colors[0];
    }
    return lerpColor(colors[0], colors[1], interpolation);
  }
}