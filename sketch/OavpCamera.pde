public class OavpCamera {
  float targetCameraX = 0;
  float targetCameraY = 0;
  float targetCameraZ = 0;
  float currCameraX = 0;
  float currCameraY = 0;
  float currCameraZ = 0;
  float finalEyeX;
  float finalEyeY;
  float finalEyeZ;
  float cameraEasing;
  float finalCenterX;
  float finalCenterY;
  float finalCenterZ;
  float finalUpX;
  float finalUpY;
  float finalUpZ;
  float xOffset;
  float yOffset;
  float lastXOffset;
  float lastYOffset;
  OavpPosition cameraPosition;
  OavpPosition entityPosition;
  OavpStyle style;

  OavpCamera(OavpPosition cameraPosition, OavpPosition entityPosition, OavpStyle style, float xOffset, float yOffset, float cameraEasing) {
    this.cameraPosition = cameraPosition;
    this.entityPosition = entityPosition;
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.cameraEasing = cameraEasing;
    this.style = style;
  }

  void update() {
    float centerX;
    float centerY;

    if (mousePressed) {
      if (!mouseDown) {
        mouseDown = true;
        mouseUp = false;
        lastXOffset = mouseX;
        lastYOffset = mouseY;
      }
      centerX = xOffset - (mouseX - lastXOffset);
      centerY = yOffset - (mouseY - lastYOffset);

      if (mouseButton == RIGHT) {
        xOffset = width/2.0;
        yOffset = height/2.0;
        centerX = xOffset;
        centerY = yOffset;
      }
      cursor(MOVE);
    } else {
      if (!mouseUp) {
        xOffset -= mouseX - lastXOffset;
        yOffset -= mouseY - lastYOffset;
        mouseUp = true;
      }
      mouseDown = false;
      centerX = xOffset;
      centerY = yOffset;
      cursor(CROSS);
    }

    float dx = targetCameraX - currCameraX;
    currCameraX += dx * cameraEasing;

    float dy = targetCameraY - currCameraY;
    currCameraY += dy * cameraEasing;

    float dz = targetCameraZ - currCameraZ;
    currCameraZ += dz * cameraEasing;

    finalEyeX = width/2.0 + currCameraX;
    finalEyeY = height/2.0 + currCameraY;
    finalEyeZ = (height/2.0) / tan(PI*30.0 / 180.0) + currCameraZ;
    finalCenterX = centerX + currCameraX;
    finalCenterY = centerY + currCameraY;
    finalCenterZ = currCameraZ;
    finalUpX = 0;
    finalUpY = 1;
    finalUpZ = 0;

    camera(finalEyeX,
           finalEyeY,
           finalEyeZ,
           finalCenterX,
           finalCenterY,
           finalCenterZ,
           finalUpX,
           finalUpY,
           finalUpZ);
  }

  void moveRight() {
    if (cameraPosition.moveRight(entityPosition.getUpperBoundX())) {
      targetCameraX = cameraPosition.getScaledX();
    } else if (cameraPosition.moveToNextLine(entityPosition.getUpperBoundY())) {
      targetCameraX = cameraPosition.getScaledX();
      targetCameraY = cameraPosition.getScaledY();
    }
    style.updateColor(this.cameraPosition);
  }

  void moveLeft() {
    if (cameraPosition.moveLeft(entityPosition.getLowerBoundX())) {
      targetCameraX = cameraPosition.getScaledX();
      style.updateColor(this.cameraPosition);
    } else if (cameraPosition.moveToPrevLine(entityPosition.getLowerBoundY())) {
      targetCameraX = cameraPosition.getScaledX();
      targetCameraY = cameraPosition.getScaledY();
    }
  }

  void moveDown() {
    if (cameraPosition.moveDown(entityPosition.getUpperBoundY())) {
      targetCameraY = cameraPosition.getScaledY();
      style.updateColor(this.cameraPosition);
    }
  }

  void moveUp() {
    if (cameraPosition.moveUp(entityPosition.getLowerBoundY())) {
      targetCameraY = cameraPosition.getScaledY();
      style.updateColor(this.cameraPosition);
    }
  }

  void moveForward() {
    targetCameraZ = max(targetCameraZ - width / 2, -width / 2);
  }

  void moveBackward() {
    targetCameraZ = min(targetCameraZ + width / 2, width * 2);
  }
}

