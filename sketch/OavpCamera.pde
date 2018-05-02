final int CAMERA_MODE_DEFAULT = 0;
final int CAMERA_MODE_ORTHO = 1;

public class OavpCamera {
  float targetOrthoLeft;
  float targetOrthoRight;
  float targetOrthoBottom;
  float targetOrthoTop;
  float currOrthoLeft = 0;
  float currOrthoRight = 0;
  float currOrthoBottom = 0;
  float currOrthoTop = 0;
  float orthoScale = 0.25;
  int orthoDistanceLimit = 10;

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

  boolean isOrtho;

  OavpCamera(OavpPosition cameraPosition, OavpPosition entityPosition, OavpStyle style, float xOffset, float yOffset, float cameraEasing) {
    this.cameraPosition = cameraPosition;
    this.entityPosition = entityPosition;
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    this.cameraEasing = cameraEasing;
    this.style = style;
    this.isOrtho = false;
    this.targetOrthoLeft = -width * 0.5;
    this.targetOrthoRight = width * 0.5;
    this.targetOrthoBottom = -height * 0.5;
    this.targetOrthoTop = height * 0.5;
  }

  void enableOrthoCamera() {
    isOrtho = true;
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
        xOffset = stageWidth/2.0;
        yOffset = stageHeight/2.0;
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

    finalEyeX = stageWidth/2.0 + currCameraX;
    finalEyeY = stageHeight/2.0 + currCameraY;
    finalEyeZ = (stageHeight/2.0) / tan(PI*30.0 / 180.0) + currCameraZ;
    finalCenterX = centerX + currCameraX;
    finalCenterY = centerY + currCameraY;
    finalCenterZ = currCameraZ;
    finalUpX = 0;
    finalUpY = 1;
    finalUpZ = 0;

    float dol = targetOrthoLeft - currOrthoLeft;
    currOrthoLeft += dol * cameraEasing;

    float dor = targetOrthoRight - currOrthoRight;
    currOrthoRight += dor * cameraEasing;

    float dob = targetOrthoBottom - currOrthoBottom;
    currOrthoBottom += dob * cameraEasing;

    float dot = targetOrthoTop - currOrthoTop;
    currOrthoTop += dot * cameraEasing;

    if (isOrtho) {
      ortho(currOrthoLeft, currOrthoRight, currOrthoBottom, currOrthoTop);
    }
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
    targetCameraZ = max(targetCameraZ - stageWidth / 2, -stageWidth / 2);
    if (targetOrthoLeft < (-width * orthoScale)) {
      targetOrthoLeft = targetOrthoLeft + (width * orthoScale);
      targetOrthoRight = targetOrthoRight - (width * orthoScale);
      targetOrthoBottom = targetOrthoBottom + (height * orthoScale);
      targetOrthoTop = targetOrthoTop - (height * orthoScale);
    }
  }

  void moveBackward() {
    if (targetOrthoLeft > (-width * orthoScale * orthoDistanceLimit)) {
      targetCameraZ = min(targetCameraZ + stageWidth / 2, stageWidth * 2);
      targetOrthoLeft = targetOrthoLeft - (width * orthoScale);
      targetOrthoRight = targetOrthoRight + (width * orthoScale);
      targetOrthoBottom = targetOrthoBottom - (height * orthoScale);
      targetOrthoTop = targetOrthoTop + (height * orthoScale);
    }
  }

}

