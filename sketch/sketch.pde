import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Random;
import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;

Minim minim;
OavpData oavpData;
OavpInterval spectrumInterval;
OavpInterval levelInterval;
OavpGridInterval levelGridInterval;
OavpAmplitude beatAmplitude;
OavpInterval beatAmplitudeInterval;
OavpGridInterval beatAmplitudeGridInterval;
OavpPosition cameraPosition;
OavpPosition entityPosition;
OavpCamera camera;
OavpVisualizer visualizers;
OavpMetronome metronome;
List visTrackers;
OavpShape shapes;
OavpText text;
OavpStyle style;
String introText;
PShape logo;
PFont mono;
JSONObject configs;

float stageWidth = 500;
float stageHeight = 500;
float gridScale = 500;

boolean isDayMode = true;
int defaultStrokeWeight = 2;

void setup() {
  // size(500, 500, P3D);
  fullScreen(P3D, 2);
  configs = loadJSONObject("config.json");
  frameRate(configs.getInt("frameRate"));


  style = new OavpStyle(configs.getInt("colorAccent"));

  cameraPosition = new OavpPosition(0, 0, gridScale);
  entityPosition = new OavpPosition(0, 0, gridScale);
  camera = new OavpCamera(cameraPosition, entityPosition, style, stageWidth / 2, stageHeight / 2, 0.10);
  // camera.enableOrthoCamera();

  minim = new Minim(this);

  oavpData = new OavpData(minim,
                          // configs.getString("audioFile"),
                          configs.getInt("bufferSize"),
                          configs.getInt("minBandwidthPerOctave"),
                          configs.getInt("bandsPerOctave"));

  oavpData.setSpectrumSmoothing(0.80f);
  oavpData.setLevelSmoothing(0.95f);
  oavpData.setBufferSmoothing(0.85f);


  println("AVG: ", oavpData.getAvgSize());
  spectrumInterval = new OavpInterval(40, oavpData.getAvgSize());
  // spectrumInterval.setDelay(4);

  levelInterval = new OavpInterval(20);
  levelGridInterval = new OavpGridInterval(4);

  beatAmplitude = new OavpAmplitude(0, 1, 0.08);
  beatAmplitudeInterval = new OavpInterval(20);
  beatAmplitudeGridInterval = new OavpGridInterval(4);

  visualizers = new OavpVisualizer(oavpData, entityPosition);
  visTrackers = new ArrayList();

  metronome = new OavpMetronome(minim, "tack.wav", "tack.wav", 130);

  shapes = new OavpShape();
  text = new OavpText(entityPosition);
  text.setPadding(20);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, configs.getInt("fontUnit") * (Math.round(stageWidth * configs.getFloat("fontScale"))));

  style.setTargetColor(cameraPosition);

  introText = text.read("intro.txt");

  sandboxSetup();
  debug();
}

void draw() {
  metronome.update();

  style.updateColorInterp();
  style.getIntermediateColor();
  noFill();
  strokeWeight(2);

  stroke(style.getPrimaryColor());
  background(style.getSecondaryColor());

  camera.update();

  oavpData.forward();
  oavpData.update(visTrackers);
  spectrumInterval.update(oavpData.getSpectrum());
  levelInterval.update(oavpData.getLeftLevel(), 1);
  levelGridInterval.updateDiagonal(oavpData.getLeftLevel(), 0);
  beatAmplitude.update(oavpData);
  beatAmplitudeInterval.update(beatAmplitude.getValue(), 0);
  beatAmplitudeGridInterval.updateDiagonal(beatAmplitude.getValue(), 0);

  // exampleGallery();
  sandbox();
}