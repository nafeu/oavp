public class OavpText {

  OavpPosition cursor;
  float padding;

  OavpText(OavpPosition cursor) {
    this.cursor = cursor;
    this.padding = 0;
  }

  void setPadding(float padding) {
    this.padding = padding;
  }

  void write(String text, float x, float y, float w, float h, float padding) {
    pushStyle();
    fill(0);
    // textAlign(CENTER);
    text(text, x + padding, y + padding, w - padding * 2, h - padding * 2);
    popStyle();
  }

  void read(String path) {
    String[] lines = loadStrings(path);
    String text = String.join("\n", lines);
    text(text, cursor.getScaledX() + padding, cursor.getScaledY() + padding, cursor.scale - padding * 2, cursor.scale - padding * 2);
  }

  void write(String text) {
    pushStyle();
    fill(0);
    // textAlign(CENTER);
    text(text, cursor.getScaledX() + padding, cursor.getScaledY() + padding, cursor.scale - padding * 2, cursor.scale - padding * 2);
    popStyle();
  }

  // void title(String displayText, float x, float y) {
  //   pushStyle();
  //   fill(0);
  //   textAlign(CENTER);
  //   text(displayText, x + width * 0.5, y + height * 0.05);
  //   popStyle();
  // }

}