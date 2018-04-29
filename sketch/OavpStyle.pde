public class OavpStyle {

  // int colorSeed = Math.round(random(0, 100));
  int colorAccent;
  int currColor = 0;
  int intermediateColor = 0;
  int targetColor;
  float currInterp = 0.0;
  float targetInterp = 1.0;
  float colorEasing = 0.025;
  FlatUIColors flat;
  int primary;
  int secondary;

  OavpStyle(int colorAccent) {
    this.colorAccent = colorAccent % material[colorAccent].length;
    flat = new FlatUIColors();
  }

  void setColorAccent(int colorAccent) {
    this.colorAccent = colorAccent % material[colorAccent].length;
  }

  void setTargetColor(OavpPosition position) {
    targetColor = this.getRandomColor(position.x, position.y);
  }

  int getIntermediateColor() {
    intermediateColor = lerpColor(currColor, targetColor, currInterp);
    return intermediateColor;
  }

  int getRandomColor(int x, int y) {
    return material[colorAccent][(x + y) % material[colorAccent].length];
  }

  void updateColor(OavpPosition position) {
    currColor = intermediateColor;
    targetColor = this.getRandomColor(position.x, position.y);
    currInterp = 0.0;
  }

  void updateColorInterp() {
    float di = targetInterp - currInterp;
    currInterp += di * colorEasing;
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

  // int material[] = {
  //   #ffebee,  #ffcdd2,  #ef9a9a,  #e57373,  #ef5350,  #f44336,  #e53935,
  //   #d32f2f,  #c62828,  #b71c1c,  #ff8a80,  #ff5252,  #ff1744,  #d50000,
  //   #fce4ec,  #f8bbd0,  #f48fb1,  #f06292,  #ec407a,  #e91e63,  #d81b60,
  //   #c2185b,  #ad1457,  #880e4f,  #ff80ab,  #ff4081,  #f50057,  #c51162,
  //   #f3e5f5,  #e1bee7,  #ce93d8,  #ba68c8,  #ab47bc,  #9c27b0,  #8e24aa,
  //   #7b1fa2,  #6a1b9a,  #4a148c,  #ea80fc,  #e040fb,  #d500f9,  #aa00ff,
  //   #ede7f6,  #d1c4e9,  #b39ddb,  #9575cd,  #7e57c2,  #673ab7,  #5e35b1,
  //   #512da8,  #4527a0,  #311b92,  #b388ff,  #7c4dff,  #651fff,  #6200ea,
  //   #e8eaf6,  #c5cae9,  #9fa8da,  #7986cb,  #5c6bc0,  #3f51b5,  #3949ab,
  //   #303f9f,  #283593,  #1a237e,  #8c9eff,  #536dfe,  #3d5afe,  #304ffe,
  //   #e3f2fd,  #bbdefb,  #90caf9,  #64b5f6,  #42a5f5,  #2196f3,  #1e88e5,
  //   #1976d2,  #1565c0,  #0d47a1,  #82b1ff,  #448aff,  #2979ff,  #2962ff,
  //   #e1f5fe,  #b3e5fc,  #81d4fa,  #4fc3f7,  #29b6f6,  #03a9f4,  #039be5,
  //   #0288d1,  #0277bd,  #01579b,  #80d8ff,  #40c4ff,  #00b0ff,  #0091ea,
  //   #e0f7fa,  #b2ebf2,  #80deea,  #4dd0e1,  #26c6da,  #00bcd4,  #00acc1,
  //   #0097a7,  #00838f,  #006064,  #84ffff,  #18ffff,  #00e5ff,  #00b8d4,
  //   #e0f2f1,  #b2dfdb,  #80cbc4,  #4db6ac,  #26a69a,  #009688,  #00897b,
  //   #00796b,  #00695c,  #004d40,  #a7ffeb,  #64ffda,  #1de9b6,  #00bfa5,
  //   #e8f5e9,  #c8e6c9,  #a5d6a7,  #81c784,  #66bb6a,  #4caf50,  #43a047,
  //   #388e3c,  #2e7d32,  #1b5e20,  #b9f6ca,  #69f0ae,  #00e676,  #00c853,
  //   #f1f8e9,  #dcedc8,  #c5e1a5,  #aed581,  #9ccc65,  #8bc34a,  #7cb342,
  //   #689f38,  #558b2f,  #33691e,  #ccff90,  #b2ff59,  #76ff03,  #64dd17,
  //   #f9fbe7,  #f0f4c3,  #e6ee9c,  #dce775,  #d4e157,  #cddc39,  #c0ca33,
  //   #afb42b,  #9e9d24,  #827717,  #f4ff81,  #eeff41,  #c6ff00,  #aeea00,
  //   #fffde7,  #fff9c4,  #fff59d,  #fff176,  #ffee58,  #ffeb3b,  #fdd835,
  //   #fbc02d,  #f9a825,  #f57f17,  #ffff8d,  #ffff00,  #ffea00,  #ffd600,
  //   #fff8e1,  #ffecb3,  #ffe082,  #ffd54f,  #ffca28,  #ffc107,  #ffb300,
  //   #ffa000,  #ff8f00,  #ff6f00,  #ffe57f,  #ffd740,  #ffc400,  #ffab00,
  //   #fff3e0,  #ffe0b2,  #ffcc80,  #ffb74d,  #ffa726,  #ff9800,  #fb8c00,
  //   #f57c00,  #ef6c00,  #e65100,  #ffd180,  #ffab40,  #ff9100,  #ff6d00,
  //   #fbe9e7,  #ffccbc,  #ffab91,  #ff8a65,  #ff7043,  #ff5722,  #f4511e,
  //   #e64a19,  #d84315,  #bf360c,  #ff9e80,  #ff6e40,  #ff3d00,  #dd2c00,
  //   #efebe9,  #d7ccc8,  #bcaaa4,  #a1887f,  #8d6e63,  #795548,  #6d4c41,
  //   #5d4037,  #4e342e,  #3e2723,  #eceff1,  #cfd8dc,  #b0bec5,  #90a4ae,
  //   #78909c,  #607d8b,  #546e7a,  #455a64,  #37474f,  #263238,  #fafafa,
  //   #f5f5f5,  #eeeeee,  #e0e0e0,  #bdbdbd,  #9e9e9e,  #757575,  #616161,
  //   #424242,  #212121,
  // };

  int[][] material = {
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
