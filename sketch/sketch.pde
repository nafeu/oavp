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

float eyeZ = 0;

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

  float centerX = width/2.0 + map(mouseX, 0, width, -(width / 2), (width / 2));
  float centerY = height/2.0 + map(mouseY, 0, height, -(height / 2), (height / 2));
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0) + eyeZ,
         centerX, centerY, 0,
         0, 1, 0);


  avizData.forward();

  exampleSketch();
}

void exampleSketch() {
  avizLogo(width / 2, height / 2, 0.50f * paramA, 400, logo);
  avizCircleBarSpectrum(width / 2, height / 2, paramB, paramC, paramD, -frameCount * 0.25, avizData);
  // avizCircleLineWaveform(width / 2, height / 2, 100, 50, 200, frameCount * 0.25, avizData);
  // avizBarSpectrum(0, 0, width, height, avizData);
  // avizLineSpectrum(0, height, width, height, avizData);
  // avizLineWaveform(0, height, width, height, avizData);
  // avizBarLevels(0, height, width, height, avizData);
  // avizRotatingBox(width / 2, height / 2, 200, frameCount, avizData);
  // avizRotatingBox(width / 2, height / 2, 100, -frameCount * 0.25, avizData);
  // avizCircleBarSpectrum(width / 2, height / 2, 100, 150, 700, frameCount * 0.25, avizData);
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
  eyeZ += e * 20;
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
      case 'y':
        deltaA *= 2;
        println("[y] deltaA : " + deltaA);
        break;
      case 'h':
        deltaA /= 2;
        println("[h] deltaA : " + deltaA);
        break;
      case 'u':
        deltaB *= 2;
        println("[u] deltaB : " + deltaB);
        break;
      case 'j':
        deltaB /= 2;
        println("[j] deltaB : " + deltaB);
        break;
      case 'i':
        deltaC *= 2;
        println("[i] deltaC : " + deltaC);
        break;
      case 'k':
        deltaC /= 2;
        println("[k] deltaC : " + deltaC);
        break;
      case 'o':
        deltaD *= 2;
        println("[o] deltaD : " + deltaD);
        break;
      case 'l':
        deltaD /= 2;
        println("[l] deltaD : " + deltaD);
        break;
      case 'p':
        deltaE *= 2;
        println("[p] deltaE : " + deltaE);
        break;
      case ';':
        deltaE /= 2;
        println("[;] deltaE : " + deltaE);
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