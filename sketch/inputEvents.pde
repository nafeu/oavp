void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case SHIFT:
        break;
      case RIGHT:
        moveCameraRight();
        break;
      case LEFT:
        moveCameraLeft();
        break;
      case DOWN:
        moveCameraDown();
        break;
      case UP:
        moveCameraUp();
        break;
      default:
        println("Unhandled code:", keyCode);
        break;
    }
  } else {
    switch (key) {
      case ' ':
        avizData.toggleLoop();
        break;
      case 'y':
        paramA += deltaA;
        println("[y] paramA : " + paramA);
        break;
      case 'h':
        paramA -= deltaA;
        println("[h] paramA : " + paramA);
        break;
      case 'u':
        paramB += deltaB;
        println("[u] paramB : " + paramB);
        break;
      case 'j':
        paramB -= deltaB;
        println("[j] paramB : " + paramB);
        break;
      case 'i':
        paramC += deltaC;
        println("[i] paramC : " + paramC);
        break;
      case 'k':
        paramC -= deltaC;
        println("[k] paramC : " + paramC);
        break;
      case 'o':
        paramD += deltaD;
        println("[o] paramD : " + paramD);
        break;
      case 'l':
        paramD -= deltaD;
        println("[l] paramD : " + paramD);
        break;
      case 'p':
        paramE += deltaE;
        println("[p] paramE : " + paramE);
        break;
      case ';':
        paramD -= deltaD;
        println("[;] paramD : " + paramD);
        break;
      case 'Y':
        deltaA *= 2;
        println("[Y] deltaA : " + deltaA);
        break;
      case 'H':
        deltaA /= 2;
        println("[H] deltaA : " + deltaA);
        break;
      case 'U':
        deltaB *= 2;
        println("[U] deltaB : " + deltaB);
        break;
      case 'J':
        deltaB /= 2;
        println("[J] deltaB : " + deltaB);
        break;
      case 'I':
        deltaC *= 2;
        println("[I] deltaC : " + deltaC);
        break;
      case 'K':
        deltaC /= 2;
        println("[K] deltaC : " + deltaC);
        break;
      case 'O':
        deltaD *= 2;
        println("[O] deltaD : " + deltaD);
        break;
      case 'L':
        deltaD /= 2;
        println("[L] deltaD : " + deltaD);
        break;
      case 'P':
        deltaE *= 2;
        println("[P] deltaE : " + deltaE);
        break;
      case ':':
        deltaE /= 2;
        println("[:] deltaE : " + deltaE);
        break;
      case 'w':
        moveCameraUp();
        break;
      case 's':
        moveCameraDown();
        break;
      case 'a':
        moveCameraLeft();
        break;
      case 'd':
        moveCameraRight();
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
    targetCameraZ = min(targetCameraZ + width / 2, width * 2);
    println("[MWHEEL_UP] targetCameraZ : " + targetCameraZ);
  } else {
    targetCameraZ = max(targetCameraZ - width / 2, -width / 2);
    println("[MWHEEL_UP] targetCameraZ : " + targetCameraZ);
  }
}
