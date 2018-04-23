void updateCamera() {
  float centerX;
  float centerY;

  if (mousePressed && (mouseButton == LEFT)) {
    centerX = width/2.0 + map(mouseX, 0, width, -(width / 2), (width / 2));
    centerY = height/2.0 + map(mouseY, 0, height, -(height / 2), (height / 2));
  } else {
    centerX = width/2.0;
    centerY = height/2.0;
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