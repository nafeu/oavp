public class OavpText {

  private OavpPosition cursor;
  private float padding;
  private PFont regular;
  private PFont bold;
  private PFont thin;
  private float opacity;
  private int size;

  OavpText(OavpConfig config, OavpPosition cursor) {
    this.cursor = cursor;
    this.padding = 50;
    this.opacity = 1.0;
    textMode(MODEL);
    try {
      this.regular = createFont(config.FONT_REGULAR, config.FONT_SIZE);
      this.bold = createFont(config.FONT_BOLD, config.FONT_SIZE);
      this.thin = createFont(config.FONT_THIN, config.FONT_SIZE);
      this.size = config.FONT_SIZE;
      textFont(regular);
    } catch (Exception e) {
      println("[ oavp ] Error loading font");
      debugError(e);
      exit();
    }

  }

  public void setPadding(float padding) {
    this.padding = padding;
  }

  public OavpText create() {
    pushMatrix();
    pushStyle();
    return this;
  }

  public OavpText done() {
    popStyle();
    popMatrix();
    return this;
  }

  public OavpText weightRegular() {
    textFont(this.regular, size);
    return this;
  }

  public OavpText weightBold() {
    textFont(this.bold, size);
    return this;
  }

  public OavpText weightThin() {
    textFont(this.thin, size);
    return this;
  }

  public OavpText size(int size) {
    this.size = size;
    textSize(size);
    textLeading(20);
    return this;
  }

  public OavpText size(float size) {
    textSize(size);
    return this;
  }

  public OavpText write(String text, float x, float y, float w, float h, float padding) {
    text(text, x + padding, y + padding, w - padding * 2, h - padding * 2);
    return this;
  }

  public OavpText write(String text, float x, float y) {
    text(text, x, y, 100, 50);
    return this;
  }

  public OavpText write(String text) {
    text(text, 0, 0);
    return this;
  }

  public OavpText move(float x, float y) {
    translate(x, y);
    return this;
  }

  public OavpText move(float x, float y, float z) {
    translate(x, y, z);
    return this;
  }

  public OavpText moveUp(float distance) {
    translate(0, -distance);
    return this;
  }

  public OavpText moveDown(float distance) {
    translate(0, distance);
    return this;
  }

  public OavpText moveLeft(float distance) {
    translate(-distance, 0);
    return this;
  }

  public OavpText moveRight(float distance) {
    translate(distance, 0);
    return this;
  }

  public OavpText moveBackward(float distance) {
    translate(0, 0, -distance);
    return this;
  }

  public OavpText moveForward(float distance) {
    translate(0, 0, distance);
    return this;
  }

  public OavpText center() {
    translate(cursor.getCenteredX(), 0);
    return this;
  }

  public OavpText middle() {
    translate(0, cursor.getCenteredY());
    return this;
  }

  public OavpText left() {
    translate(cursor.getScaledX(), 0);
    return this;
  }

  public OavpText right() {
    translate(cursor.getScaledX() + cursor.xScale, 0);
    return this;
  }

  public OavpText top() {
    translate(0, cursor.getScaledY());
    return this;
  }

  public OavpText bottom() {
    translate(0, cursor.getScaledY() + cursor.yScale);
    return this;
  }

  public OavpText rotate(float x) {
    rotateX(radians(x));
    return this;
  }

  public OavpText rotate(float x, float y) {
    rotateX(radians(x));
    rotateY(radians(y));
    return this;
  }

  public OavpText rotate(float x, float y, float z) {
    rotateX(radians(x));
    rotateY(radians(y));
    rotateZ(radians(z));
    return this;
  }

  public OavpText rotateClockwise(float x) {
    rotateZ(radians(x));
    return this;
  }

  public OavpText alignRight() {
    textAlign(RIGHT);
    return this;
  }

  public OavpText alignLeft() {
    textAlign(LEFT);
    return this;
  }

  public OavpText alignCenter() {
    textAlign(CENTER);
    return this;
  }

  public OavpText alignCompleteCenter() {
    textAlign(CENTER, CENTER);
    return this;
  }

  public OavpText textOpacity(float opacity) {
    this.opacity = opacity;
    return this;
  }

  public OavpText write(String text, color inputColor) {
    noStroke();
    fill(inputColor);
    text(text, cursor.getScaledX() + padding, cursor.getScaledY() + padding, cursor.xScale - padding * 2, cursor.yScale - padding * 2);
    return this;
  }

  public OavpText write(float value, color inputColor) {
    noStroke();
    fill(inputColor);
    text(String.valueOf(value), cursor.getScaledX() + padding, cursor.getScaledY() + padding, cursor.xScale - padding * 2, cursor.yScale - padding * 2);
    return this;
  }

  public OavpText writeBox(String text, float w, float h) {
    noStroke();
    text(text, 0, 0, w, h);
    return this;
  }

  String read(String path) {
    String[] lines = loadStrings(path);
    String text = String.join("\n", lines);
    return text;
  }

  public OavpText fillColor(color customColor) {
    if (customColor != 0) {
      fill(customColor);
    } else {
      noFill();
    }
    return this;
  }

  public OavpText fillColor(String customColor) {
    fill(unhex("FF" + customColor.substring(1)));
    return this;
  }

  public OavpText fillColor(color customColor, float opacity) {
    fill(opacity(customColor, opacity));
    return this;
  }

  public OavpText strokeColor(color customColor) {
    if (customColor != 0) {
      stroke(customColor);
    } else {
      noStroke();
    }
    return this;
  }

  public OavpText strokeColor(String customColor) {
    stroke(unhex("FF" + customColor.substring(1)));
    return this;
  }

  /**
   * Set stroke color
   * @param customColor the color
   * @param opacity the opacity value
   */
  public OavpText strokeColor(color customColor, float opacity) {
    stroke(opacity(customColor, opacity));
    return this;
  }

  public OavpText use(OavpVariable variable) {
    this
      .strokeColor(variable.strokeColor(), 255)
      .fillColor(variable.fillColor(), 255)
      .size(variable.val("s"))
      .move(
        variable.val("x"),
        variable.val("y"),
        variable.val("z")
      )
      .rotate(
        variable.val("xr"),
        variable.val("yr"),
        variable.val("zr")
      );
    return this;
  }
}