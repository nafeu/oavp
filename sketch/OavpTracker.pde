public class OavpTracker {
  float startingX, startingY;
  public float x, y;
  float velX;
  float velY;
  float angle;
  float limit;
  boolean isDead = false;

  OavpTracker(float x, float y, float velX, float velY, float angle, float limit) {
    this.x = x;
    this.y = y;
    this.startingX = x;
    this.startingY = y;
    this.velX = velX;
    this.velY = velY;
    this.angle = angle;
    this.limit = limit;
  }

  void update() {
    x += cos(radians(angle)) * velX;
    y += sin(radians(angle)) * velY;
    float maxDistance = abs(startingX - limit);
    float distanceTravelledX = abs(startingX - x);
    float distanceTravelledY = abs(startingY - y);
    if (distanceTravelledX >= maxDistance) {
      isDead = true;
    }
    if (distanceTravelledY >= maxDistance) {
      isDead = true;
    }
  }

  void setAngle(float angle) {
    this.angle = angle;
  }
}