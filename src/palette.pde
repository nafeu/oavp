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
    },
    // 100
    {
      #ffcdd2, #f8bbd0, #e1bee7, #d1c4e9, #c5cae9, #bbdefb,
      #b3e5fc, #b2ebf2, #b2dfdb, #c8e6c9, #dcedc8, #f0f4c3,
      #fff9c4, #ffecb3, #ffe0b2, #ffccbc, #d7ccc8, #f5f5f5,
      #cfd8dc,
    },

    // 200
    {
      #ef9a9a, #f48fb1, #ce93d8, #b39ddb, #9fa8da, #90caf9,
      #81d4fa, #80deea, #80cbc4, #a5d6a7, #c5e1a5, #e6ee9c,
      #fff59d, #ffe082, #ffcc80, #ffab91, #bcaaa4, #eeeeee,
      #b0bec5,
    },
    // 300
    {
      #e57373, #f06292, #ba68c8, #9575cd, #7986cb, #64b5f6,
      #4fc3f7, #4dd0e1, #4db6ac, #81c784, #aed581, #dce775,
      #fff176, #ffd54f, #ffb74d, #ff8a65, #a1887f, #e0e0e0,
      #90a4ae,
    },
    // 400
    {
      #ef5350, #ec407a, #ab47bc, #7e57c2, #5c6bc0, #42a5f5,
      #29b6f6, #26c6da, #26a69a, #66bb6a, #9ccc65, #d4e157,
      #ffee58, #ffca28, #ffa726, #ff7043, #8d6e63, #bdbdbd,
      #78909c,
    },
    // 500
    {
      #f44336, #e91e63, #9c27b0, #673ab7, #3f51b5, #2196f3,
      #03a9f4, #00bcd4, #009688, #4caf50, #8bc34a, #cddc39,
      #ffeb3b, #ffc107, #ff9800, #ff5722, #795548, #9e9e9e,
      #607d8b,
    },
    // 600
    {
      #e53935, #d81b60, #8e24aa, #5e35b1, #3949ab, #1e88e5,
      #039be5, #00acc1, #00897b, #43a047, #7cb342, #c0ca33,
      #fdd835, #ffb300, #fb8c00, #f4511e, #6d4c41, #757575,
      #546e7a,
    },
    // 700
    {
      #d32f2f, #c2185b, #7b1fa2, #512da8, #303f9f, #1976d2,
      #0288d1, #0097a7, #00796b, #388e3c, #689f38, #afb42b,
      #fbc02d, #ffa000, #f57c00, #e64a19, #5d4037, #616161,
      #455a64,
    },
    // 800
    {
      #c62828, #ad1457, #6a1b9a, #4527a0, #283593, #1565c0,
      #0277bd, #00838f, #00695c, #2e7d32, #558b2f, #9e9d24,
      #f9a825, #ff8f00, #ef6c00, #d84315, #4e342e, #424242,
      #37474f,
    },
    // 900
    {
      #b71c1c, #880e4f, #4a148c, #311b92, #1a237e, #0d47a1,
      #01579b, #006064, #004d40, #1b5e20, #33691e, #827717,
      #f57f17, #ff6f00, #e65100, #bf360c, #3e2723, #212121,
      #263238,
    },

    // A100
    {
      #ff8a80, #ff80ab, #ea80fc, #b388ff, #8c9eff, #82b1ff,
      #80d8ff, #84ffff, #a7ffeb, #b9f6ca, #ccff90, #f4ff81,
      #ffff8d, #ffe57f, #ffd180, #ff9e80,

    },
    // A200
    {
      #ff5252, #ff4081, #e040fb, #7c4dff, #536dfe, #448aff,
      #40c4ff, #18ffff, #64ffda, #69f0ae, #b2ff59, #eeff41,
      #ffff00, #ffd740, #ffab40, #ff6e40,

    },
    // A400
    {
      #ff1744, #f50057, #d500f9, #651fff, #3d5afe, #2979ff,
      #00b0ff, #00e5ff, #1de9b6, #00e676, #76ff03, #c6ff00,
      #ffea00, #ffc400, #ff9100, #ff3d00,

    },
    // A700
    {
      #d50000, #c51162, #aa00ff, #6200ea, #304ffe, #2962ff,
      #0091ea, #00b8d4, #00bfa5, #00c853, #64dd17, #aeea00,
      #ffd600, #ffab00, #ff6d00, #dd2c00,
    },
  };
}