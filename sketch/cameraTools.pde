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
  } else {
    if (!mouseUp) {
      xOffset -= mouseX - lastXOffset;
      yOffset -= mouseY - lastYOffset;
      mouseUp = true;
    }
    mouseDown = false;
    centerX = xOffset;
    centerY = yOffset;
  }


  float dx = targetCameraX - currCameraX;
  currCameraX += dx * cameraEasing;

  float dy = targetCameraY - currCameraY;
  currCameraY += dy * cameraEasing;

  float dz = targetCameraZ - currCameraZ;
  currCameraZ += dz * cameraEasing;

  camera(width/2.0 + currCameraX, height/2.0 + currCameraY, (height/2.0) / tan(PI*30.0 / 180.0) + currCameraZ,
         centerX + currCameraX, centerY + currCameraY, 0,
         0, 1, 0);
}