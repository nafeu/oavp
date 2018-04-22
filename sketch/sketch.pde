import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;
AvizData avizData;
Colors colors;

// Configs
final int FPS = 60;

final int bufferSize = 1024;
final int minBandwidthPerOctave = 200;
final int bandsPerOctave = 30;

float paramA = 0;
float deltaA = 16;
float paramB = 0;
float deltaB = 16;
float paramC = 0;
float deltaC = 16;
float paramD = 0;
float deltaD = 16;
float paramE = 0;
float deltaE = 16;

float targetCameraX = 0;
float targetCameraY = 0;
float targetCameraZ = 0;
float currCameraX = 0;
float currCameraY = 0;
float currCameraZ = 0;
float easing = 0.10;

PShape logo;

void setup() {
  frameRate(FPS);
  size(1000, 1000, P3D);

  colors = new Colors();
  minim = new Minim(this);
  avizData = new AvizData(minim,
                          "sample.mp3",
                          bufferSize,
                          minBandwidthPerOctave,
                          bandsPerOctave);
  avizData.setSpectrumSmoothing(0.80f);
  avizData.setLevelSmoothing(0.95f);
  avizData.setBufferSmoothing(0.85f);

  logo = loadShape("test-logo.svg");

  debug();
}

void draw() {
  noCursor();
  background(colors.teal);
  stroke(colors.black);
  noFill();
  strokeWeight(2);

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
  currCameraX += dx * easing;

  float dy = targetCameraY - currCameraY;
  currCameraY += dy * easing;

  float dz = targetCameraZ - currCameraZ;
  currCameraZ += dz * easing;

  camera(width/2.0 + currCameraX, height/2.0 + currCameraY, (height/2.0) / tan(PI*30.0 / 180.0) + currCameraZ,
         centerX + currCameraX, centerY + currCameraY, 0,
         0, 1, 0);

  avizData.forward();

  exampleSketch();
}

void exampleSketch() {
  avizLogo(width / 2, height / 2, 0.50f, 400, logo);
  avizCircleLineWaveform(width / 2, height / 2, 0, 50, 200, frameCount * 0.25, avizData);
  avizCircleBarSpectrum(width / 2, height / 2, 160, 232, 1024, frameCount * 0.25, avizData);
  avizBarSpectrum(0, height - (height / 4), width, height / 4, avizData);
  avizLineSpectrum(0, height / 4, width, -(height / 4), avizData);
  // avizLineWaveform(0, 0, width, height, avizData);
  // avizBarLevels(0, height, width, height, avizData);
  avizRotatingBox(0 + 144, height / 2, 200, frameCount, avizData);
  avizRotatingBox(0 + 144, height / 2, 100, -frameCount * 0.25, avizData);
  avizRotatingBox(width - 144, height / 2, 200, frameCount, avizData);
  avizRotatingBox(width - 144, height / 2, 100, -frameCount * 0.25, avizData);
}

void debug() {
  println("bufferSize: " + String.valueOf(bufferSize));
  println("minBandwidthPerOctave: " + String.valueOf(minBandwidthPerOctave));
  println("bandsPerOctave: " + String.valueOf(bandsPerOctave));
  print("paramA: " + paramA);
  println(", deltaA: " + deltaA);
  print("paramB: " + paramB);
  println(", deltaB: " + deltaB);
  print("paramC: " + paramC);
  println(", deltaC: " + deltaC);
  print("paramD: " + paramD);
  println(", deltaD: " + deltaD);
  print("paramE: " + paramE);
  println(", deltaE: " + deltaE);
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

public class Colors {
  int teal = #1abc9c;
  int darkTeal = #16a085;
  int green = #2ecc71;
  int darkGreen = #27ae60;
  int blue = #3498db;
  int darkBlue = #2980b9;
  int purple = #9b59b6;
  int darkPurple = #8e44ad;
  int red = #e74c3c;
  int darkRed = #c0392b;
  int orange = #e67e22;
  int darkOrange = #d35400;
  int yellow = #f1c40f;
  int darkYellow = #f39c12;
  int grey = #95a5a6;
  int darkGrey = #7f8c8d;
  int primary = #ecf0f1;
  int darkPrimary = #bdc3c7;
  int secondary = #34495e;
  int darkSecondary = #2c3e50;
  int white = #FFFFFF;
  int black = #000000;
  Colors() {}
}

void keyPressed() {
  if (key == CODED) {
    switch (keyCode) {
      case SHIFT:
        break;
      case RIGHT:
        targetCameraX += width;
        println("[RIGHT] targetCameraX : " + targetCameraX);
        break;
      case LEFT:
        targetCameraX -= width;
        println("[LEFT] targetCameraX : " + targetCameraX);
        break;
      case DOWN:
        targetCameraY += height;
        println("[DOWN] targetCameraY : " + targetCameraY);
        break;
      case UP:
        targetCameraY -= height;
        println("[UP] targetCameraY : " + targetCameraY);
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