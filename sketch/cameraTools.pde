// Camera Values
float targetCameraX = 0;
float targetCameraY = 0;
float targetCameraZ = 0;
float currCameraX = 0;
float currCameraY = 0;
float currCameraZ = 0;
float cameraEasing = 0.10;
float finalEyeX;
float finalEyeY;
float finalEyeZ;
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
boolean mouseDown = false;
boolean mouseUp = true;

void updateCamera() {
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

  camera(finalEyeX, finalEyeY, finalEyeZ, finalCenterX, finalCenterY, finalCenterZ, finalUpX, finalUpY, finalUpZ);
}

void moveCameraRight() {
  if (cameraPosition.moveRight(entities.getUpperBoundX())) {
    targetCameraX = cameraPosition.getScaledX();
    updateColor();
  } else if (cameraPosition.moveToNextLine(entities.getUpperBoundY())) {
    targetCameraX = cameraPosition.getScaledX();
    targetCameraY = cameraPosition.getScaledY();
    updateColor();
  }
}

void moveCameraLeft() {
  if (cameraPosition.moveLeft(entities.getLowerBoundX())) {
    targetCameraX = cameraPosition.getScaledX();
    updateColor();
  } else if (cameraPosition.moveToPrevLine(entities.getLowerBoundY())) {
    targetCameraX = cameraPosition.getScaledX();
    targetCameraY = cameraPosition.getScaledY();
  }
}

void moveCameraDown() {
  if (cameraPosition.moveDown(entities.getUpperBoundY())) {
    targetCameraY = cameraPosition.getScaledY();
    updateColor();
  }
}

void moveCameraUp() {
  if (cameraPosition.moveUp(entities.getLowerBoundY())) {
    targetCameraY = cameraPosition.getScaledY();
    updateColor();
  }
}

void moveCameraForward() {
  targetCameraZ = max(targetCameraZ - width / 2, -width / 2);
}

void moveCameraBackward() {
  targetCameraZ = min(targetCameraZ + width / 2, width * 2);
}