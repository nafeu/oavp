public class OavpText {

  private OavpPosition cursor;
  private float padding;
  private PFont regular;
  private PFont bold;
  private PFont thin;
  private int size;

  OavpText(OavpConfig config, OavpPosition cursor) {
    this.cursor = cursor;
    this.padding = 50;
    textMode(SHAPE);
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
    textFont(this.regular);
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
    // text(text, cursor.getScaledX() + padding, cursor.getScaledY() + padding, cursor.scale - padding * 2, cursor.scale - padding * 2);
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
    translate(cursor.getScaledX() + cursor.scale, 0);
    return this;
  }

  public OavpText top() {
    translate(0, cursor.getScaledY());
    return this;
  }

  public OavpText bottom() {
    translate(0, cursor.getScaledY() + cursor.scale);
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

  public OavpText colour(color inputColour) {
    fill(inputColour);
    return this;
  }

  public OavpText write(String text, color inputColor) {
    noStroke();
    fill(inputColor);
    text(text, cursor.getScaledX() + padding, cursor.getScaledY() + padding, cursor.scale - padding * 2, cursor.scale - padding * 2);
    return this;
  }

  public OavpText write(float value, color inputColor) {
    noStroke();
    fill(inputColor);
    text(String.valueOf(value), cursor.getScaledX() + padding, cursor.getScaledY() + padding, cursor.scale - padding * 2, cursor.scale - padding * 2);
    return this;
  }

  String read(String path) {
    String[] lines = loadStrings(path);
    String text = String.join("\n", lines);
    return text;
  }
}