public class OavpPalette {

  private HashMap<String, color[]> storage;
  public FlatUIColors flat;
  private Ani ani;
  private float rotatingValue = 0;
  private int rotatingColorIndex = 0;
  private color colorA = 0;
  private color colorB = 0;

  OavpPalette(OavpConfig config) {
    storage = new HashMap<String, color[]>();
    flat = new FlatUIColors();
  }

  public void reset(color background, color primary, color secondary, float strokeWeight) {
    background(background);
    fill(primary);
    stroke(secondary);
    strokeWeight(strokeWeight);
  }

  public void reset(color background, color primary, float strokeWeight) {
    background(background);
    noFill();
    stroke(primary);
    strokeWeight(strokeWeight);
  }

  public void reset(String background, String primary, float strokeWeight) {
    background(unhex("FF" + background.substring(1)));
    noFill();
    stroke(unhex("FF" + primary.substring(1)));
    strokeWeight(strokeWeight);
  }

  public void reset(color background, color primary) {
    background(background);
    fill(primary);
    noStroke();
  }

  public void reset(String background, String primary) {
    background(unhex("FF" + background.substring(1)));
    fill(unhex("FF" + primary.substring(1)));
    noStroke();
  }

  public OavpPalette add(String name, color colorA) {
    color[] colors = new color[1];
    colors[0] = colorA;
    storage.put(name, colors);
    return this;
  }

  public OavpPalette add(String name, color colorA, color colorB) {
    color[] colors = new color[2];
    colors[0] = colorA;
    colors[1] = colorB;
    storage.put(name, colors);
    return this;
  }

  public HashMap<String, color[]> getStorage() {
    return storage;
  }

  public color get(String name) {
    return storage.get(name)[0];
  }

  public color get(String name, float interpolation) {
    color[] colors = storage.get(name);
    if (colors.length == 1) {
      return colors[0];
    }
    return lerpColor(colors[0], colors[1], interpolation);
  }

  public int getRandomColor(int accent) {
    int randomIndex = new Random().nextInt(table[accent % table.length].length);
    return table[accent % table.length][randomIndex];
  }

  public int getRandomColor() {
    int randomAccent = new Random().nextInt(table.length);
    int randomIndex = new Random().nextInt(table[randomAccent].length);
    return table[randomAccent][randomIndex];
  }

  public color getRotatingColor() {
    return lerpColor(colorA, colorB, rotatingValue);
  }

  public void setRotatingColor(color newColor, float duration, Easing easing) {
    colorB = colorA;
    colorA = newColor;
    rotatingValue = 1;
    ani = Ani.to(this, duration, "rotatingValue", 0, easing);
  }

  public void setRotatingColorIf(boolean trigger, color newColor, float duration, Easing easing) {
    if (trigger) {
      setRotatingColor(newColor, duration, easing);
    }
  }

  public void setRotatingColorByPosition(OavpPosition position, int accent, float duration, Easing easing) {
    int colorAccent = accent % table.length;
    int colorIndex = abs(position.x + position.y) % table[colorAccent].length;
    setRotatingColor(table[colorAccent][colorIndex], duration, easing);
  }

  public color getColor(int paletteIndex, int selectedIndex) {
    int colorPalette = paletteIndex % table.length;
    int colorIndex = selectedIndex % table[colorPalette].length;
    return table[colorPalette][colorIndex];
  }

  public color[] getPalette(int paletteIndex) {
    return table[paletteIndex % table.length];
  }

  public class FlatUIColors {
    int teal = #1abc9c;
    int darkTeal = #16a085;
    int green = #2ecc71;
    int darkGreen = #27ae60;
    int blue = #3498db;
    int darkBlue = #2980b9;
    int purple = #9b59b6;
    int darkPurple = #8e44ad;
    int red = #e74c3c;
    int darkRed = #c0392b;
    int orange = #e67e22;
    int darkOrange = #d35400;
    int yellow = #f1c40f;
    int darkYellow = #f39c12;
    int grey = #95a5a6;
    int darkGrey = #7f8c8d;
    int primary = #ecf0f1;
    int darkPrimary = #bdc3c7;
    int secondary = #34495e;
    int darkSecondary = #2c3e50;
    int white = #FFFFFF;
    int black = #000000;
    FlatUIColors() {}
  }

  public int[][] table = {
    // BLACK/WHITE
    {
      #FFFFFF, #000000
    },
    // 0
    {
      #A2FAA3, #92C9B1, #4F759B, #5D5179, #571F4E
    },
    // 0
    {
      #A54657, #582630, #F7EE7F, #F1A66A, #F26157
    },
    // 0
    {
      #1B1B1E, #96031A, #FAA916, #FBFFFE, #6D676E
    },
    {
      #001B2E, #294C60, #FFC49B, #ADB6C4, #FFEFD3
    },
    // 1
    {
      #031926, #468189, #77ACA2, #9DBEBB, #F4E9CD
    },
    // 2
    {
      #020202, #503B31, #705D56, #9097C0, #A7BBEC
    },
    // 3
    {
      #12263A, #06BCC1, #C5D8D1, #F4EDEA, #F4D1AE
    },
    // FLAT-DUTCH
    {
      #FFC312, #F79F1F, #EE5A24, #EA2027, #C4E538, #A3CB38,
      #009432, #006266, #12CBC4, #1289A7, #0652DD, #1B1464,
      #FDA7DF, #D980FA, #9980FA, #5758BB, #ED4C67, #B53471,
      #833471, #6F1E51,
    },
    // FLAT-LIGHT
    {
      #1abc9c, #2ecc71, #3498db, #9b59b6, #e74c3c, #e67e22,
      #f1c40f, #95a5a6, #ecf0f1, #34495e,
    },
    // FLAT-DARK
    {
      #16a085, #27ae60, #2980b9, #8e44ad, #c0392b, #d35400,
      #f39c12, #7f8c8d, #bdc3c7, #2c3e50,
    },
    // 50
    {
      #ffebee, #fce4ec, #f3e5f5, #ede7f6, #e8eaf6, #e3f2fd,
      #e1f5fe, #e0f7fa, #e0f2f1, #e8f5e9, #f1f8e9, #f9fbe7,
      #fffde7, #fff8e1, #fff3e0, #fbe9e7, #efebe9, #fafafa,
      #eceff1,
    }
  };
}