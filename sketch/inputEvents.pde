void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case SHIFT:
        break;
      case RIGHT:
        if (cameraPosition.moveRight(entities.getUpperBoundX())) {
          targetCameraX = cameraPosition.getScaledX();
          updateBackgroundColor();
          println("[RIGHT] targetCameraX : " + targetCameraX);
        } else if (cameraPosition.moveToNextLine(entities.getUpperBoundY())) {
          targetCameraX = cameraPosition.getScaledX();
          targetCameraY = cameraPosition.getScaledY();
          updateBackgroundColor();
          println("[RIGHT] targetCameraX : " + targetCameraX);
          println("[RIGHT] targetCameraY : " + targetCameraY);
        }
        break;
      case LEFT:
        if (cameraPosition.moveLeft(entities.getLowerBoundX())) {
          targetCameraX = cameraPosition.getScaledX();
          updateBackgroundColor();
          println("[LEFT] targetCameraX : " + targetCameraX);
        } else if (cameraPosition.moveToPrevLine(entities.getLowerBoundY())) {
          targetCameraX = cameraPosition.getScaledX();
          targetCameraY = cameraPosition.getScaledY();
          println("[LEFT] targetCameraX : " + targetCameraX);
          println("[LEFT] targetCameraY : " + targetCameraY);
        }
        break;
      case DOWN:
        if (cameraPosition.moveDown(entities.getUpperBoundY())) {
          targetCameraY = cameraPosition.getScaledY();
          updateBackgroundColor();
          println("[DOWN] targetCameraY : " + targetCameraY);
        }
        break;
      case UP:
        if (cameraPosition.moveUp(entities.getLowerBoundY())) {
          targetCameraY = cameraPosition.getScaledY();
          updateBackgroundColor();
          println("[UP] targetCameraY : " + targetCameraY);
        }
        break;
      default:
        println("Unhandled code.");
        break;
    }
  } else {
    switch (key) {
      case 'q':
        paramA += deltaA;
        println("[q] paramA : " + paramA);
        break;
      case 'a':
        paramA -= deltaA;
        println("[a] paramA : " + paramA);
        break;
      case 'w':
        paramB += deltaB;
        println("[w] paramB : " + paramB);
        break;
      case 's':
        paramB -= deltaB;
        println("[s] paramB : " + paramB);
        break;
      case 'e':
        paramC += deltaC;
        println("[e] paramC : " + paramC);
        break;
      case 'd':
        paramC -= deltaC;
        println("[d] paramC : " + paramC);
        break;
      case 'r':
        paramD += deltaD;
        println("[r] paramD : " + paramD);
        break;
      case 'f':
        paramD -= deltaD;
        println("[f] paramD : " + paramD);
        break;
      case 't':
        paramE += deltaE;
        println("[t] paramE : " + paramE);
        break;
      case 'g':
        paramD -= deltaD;
        println("[g] paramD : " + paramD);
        break;
      case 'Q':
        deltaA *= 2;
        println("[Q] deltaA : " + deltaA);
        break;
      case 'A':
        deltaA /= 2;
        println("[A] deltaA : " + deltaA);
        break;
      case 'W':
        deltaB *= 2;
        println("[W] deltaB : " + deltaB);
        break;
      case 'S':
        deltaB /= 2;
        println("[S] deltaB : " + deltaB);
        break;
      case 'E':
        deltaC *= 2;
        println("[E] deltaC : " + deltaC);
        break;
      case 'D':
        deltaC /= 2;
        println("[D] deltaC : " + deltaC);
        break;
      case 'R':
        deltaD *= 2;
        println("[R] deltaD : " + deltaD);
        break;
      case 'F':
        deltaD /= 2;
        println("[F] deltaD : " + deltaD);
        break;
      case 'T':
        deltaE *= 2;
        println("[T] deltaE : " + deltaE);
        break;
      case 'G':
        deltaE /= 2;
        println("[G] deltaE : " + deltaE);
        break;
      case 'z':
        debug();
        break;
      // case '$':
      //   param# += delta#;
      //   println("[$] param# : " + param#);
      //   break;
      // case '$':
      //   param# -= delta#;
      //   println("[$] param# : " + param#);
      //   break;
      default:
        println("Unhandled key.");
        break;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e > 0) {
    targetCameraZ += width / 2;
    println("[MWHEEL_UP] targetCameraZ : " + targetCameraZ);
  } else {
    targetCameraZ -= width / 2;
    println("[MWHEEL_UP] targetCameraZ : " + targetCameraZ);
  }
}
