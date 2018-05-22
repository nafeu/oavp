boolean mouseDown = false;
boolean mouseUp = true;

void keyPressed() {
  println("RAW INPUT:", key);
  if (key == CODED) {
    switch (keyCode) {
      case RIGHT:
        camera.moveRight();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      case LEFT:
        camera.moveLeft();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      case DOWN:
        camera.moveDown();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      case UP:
        camera.moveUp();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      default:
        println("Unhandled code:", keyCode);
        break;
    }
  } else {
    switch (key) {
      case ' ':
        analysis.toggleLoop();
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
        camera.moveUp();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      case 's':
        camera.moveDown();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      case 'W':
        camera.moveForward();
        break;
      case 'S':
        camera.moveBackward();
        break;
      case 'a':
        camera.moveLeft();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      case 'd':
        camera.moveRight();
        palette.setRotatingColorByPosition(cameraPosition, 5, 0.3, Ani.SINE_IN_OUT);
        break;
      case '/':
        debug();
        break;
      default:
        println("Unhandled key.");
        break;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e > 0) {
    camera.increaseDistance();
  } else {
    camera.decreaseDistance();
  }
}
