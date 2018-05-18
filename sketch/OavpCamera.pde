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

  float targetDistanceMultiplier = 1.75;
  float currDistanceMultiplier = 1.75;

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

  float endXCameraOffset;
  float endYCameraOffset;
  float startXCameraOffset;
  float startYCameraOffset;

  float endEyeRotation = 90;
  float startEyeRotation;

  OavpPosition cameraPosition;
  OavpPosition entityPosition;
  OavpStyle style;

  boolean isOrtho;
  boolean awaitingOffsetUpdate = false;
  boolean awaitingRotationUpdate = false;

  OavpCamera(OavpPosition cameraPosition, OavpPosition entityPosition, OavpStyle style, float endXCameraOffset, float endYCameraOffset, float cameraEasing) {
    this.cameraPosition = cameraPosition;
    this.entityPosition = entityPosition;
    this.endXCameraOffset = endXCameraOffset;
    this.endYCameraOffset = endYCameraOffset;
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
    float eyeX;
    float eyeZ;

    float ddm = targetDistanceMultiplier - currDistanceMultiplier;
    currDistanceMultiplier += ddm * cameraEasing;

    float distanceFromCenter = (oavp.STAGE_WIDTH/2.0) * currDistanceMultiplier;

    if (mousePressed && keyPressed && keyCode == SHIFT) {
      awaitingRotationUpdate = true;
      if (!mouseDown) {
        mouseDown = true;
        mouseUp = false;
        startEyeRotation = map(mouseX, 0, width, 0, 180);
        if (mouseButton == RIGHT) {
          endEyeRotation = 90;
          eyeX = cos(radians(endEyeRotation)) * distanceFromCenter;
          eyeZ = sin(radians(endEyeRotation)) * distanceFromCenter;
        }
      }
      centerX = endXCameraOffset;
      centerY = endYCameraOffset;
      eyeX = (cos(radians(endEyeRotation - (map(mouseX, 0, width, 0, 180) - startEyeRotation))) * distanceFromCenter);
      eyeZ = (sin(radians(endEyeRotation - (map(mouseX, 0, width, 0, 180) - startEyeRotation))) * distanceFromCenter);
      cursor(MOVE);
    }
    else if (mousePressed) {
      awaitingOffsetUpdate = true;
      if (!mouseDown) {
        mouseDown = true;
        mouseUp = false;
        startXCameraOffset = mouseX;
        startYCameraOffset = mouseY;
        if (mouseButton == RIGHT) {
          endXCameraOffset = oavp.STAGE_WIDTH/2.0;
          endYCameraOffset = oavp.STAGE_HEIGHT/2.0;
          centerX = endXCameraOffset;
          centerY = endYCameraOffset;
        }
      }
      centerX = endXCameraOffset - (mouseX - startXCameraOffset);
      centerY = endYCameraOffset - (mouseY - startYCameraOffset);
      eyeX = (cos(radians(endEyeRotation)) * distanceFromCenter);
      eyeZ = (sin(radians(endEyeRotation)) * distanceFromCenter);
      cursor(MOVE);
    }
    else
    {
      if (!mouseUp) {
        if (awaitingOffsetUpdate) {
          endXCameraOffset -= mouseX - startXCameraOffset;
          endYCameraOffset -= mouseY - startYCameraOffset;
          awaitingOffsetUpdate = false;
        }
        if (awaitingRotationUpdate) {
          endEyeRotation -= map(mouseX, 0, width, 0, 180) - startEyeRotation;
          awaitingRotationUpdate = false;
        }
        mouseUp = true;
      }
      mouseDown = false;
      centerX = endXCameraOffset;
      centerY = endYCameraOffset;
      eyeX = (cos(radians(endEyeRotation)) * distanceFromCenter);
      eyeZ = (sin(radians(endEyeRotation)) * distanceFromCenter);
      cursor(CROSS);
    }

    float dx = targetCameraX - currCameraX;
    currCameraX += dx * cameraEasing;

    float dy = targetCameraY - currCameraY;
    currCameraY += dy * cameraEasing;

    float dz = targetCameraZ - currCameraZ;
    currCameraZ += dz * cameraEasing;

    finalCenterX = centerX + currCameraX;
    finalCenterY = centerY + currCameraY;
    finalCenterZ = currCameraZ;

    finalEyeX = finalCenterX + eyeX;
    finalEyeY = finalCenterY;
    finalEyeZ = finalCenterZ + eyeZ;

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
    targetCameraZ = max(targetCameraZ - oavp.STAGE_WIDTH / 2, -oavp.STAGE_WIDTH / 2);
    if (targetOrthoLeft < (-width * orthoScale)) {
      targetOrthoLeft = targetOrthoLeft + (width * orthoScale);
      targetOrthoRight = targetOrthoRight - (width * orthoScale);
      targetOrthoBottom = targetOrthoBottom + (height * orthoScale);
      targetOrthoTop = targetOrthoTop - (height * orthoScale);
    }
  }

  void moveBackward() {
    targetCameraZ = min(targetCameraZ + oavp.STAGE_WIDTH / 2, oavp.STAGE_WIDTH * 2);
    if (targetOrthoLeft > (-width * orthoScale * orthoDistanceLimit)) {
      targetOrthoLeft = targetOrthoLeft - (width * orthoScale);
      targetOrthoRight = targetOrthoRight + (width * orthoScale);
      targetOrthoBottom = targetOrthoBottom - (height * orthoScale);
      targetOrthoTop = targetOrthoTop + (height * orthoScale);
    }
  }

  void increaseDistance() {
    if (targetDistanceMultiplier < 5) {
      targetDistanceMultiplier += 0.25;
    }
  }

  void decreaseDistance() {
    if (targetDistanceMultiplier >= 0.5) {
      targetDistanceMultiplier -= 0.25;
    }
  }

}

