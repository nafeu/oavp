import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Random;

Minim minim;
OavpData oavpData;
OavpInterval levelInterval;
OavpInterval beatInterval;
OavpAmplitude beatAmplitude;
OavpInterval beatAmplitudeInterval;
OavpPosition cameraPosition;
OavpPosition entityPosition;
OavpCamera camera;
OavpShape visualizers;
OavpText text;
OavpStyle style;
String introText;
PShape logo;
PFont mono;
JSONObject configs;

float stageWidth = 1000;
float stageHeight = 1000;
float gridScale = 1000;

boolean isDayMode = true;
int defaultStrokeWeight = 2;

void setup() {
  // size(1280, 1000, P3D);
  fullScreen(P3D);
  configs = loadJSONObject("config.json");
  frameRate(configs.getInt("frameRate"));

  style = new OavpStyle(configs.getInt("colorAccent"));

  cameraPosition = new OavpPosition(0, 0, gridScale);
  entityPosition = new OavpPosition(0, 0, gridScale);
  camera = new OavpCamera(cameraPosition, entityPosition, style, stageWidth / 2, stageHeight / 2, 0.10);

  minim = new Minim(this);

  oavpData = new OavpData(minim,
                          configs.getString("audioFile"),
                          configs.getInt("bufferSize"),
                          configs.getInt("minBandwidthPerOctave"),
                          configs.getInt("bandsPerOctave"));

  oavpData.setSpectrumSmoothing(0.80f);
  oavpData.setLevelSmoothing(0.95f);
  oavpData.setBufferSmoothing(0.85f);

  levelInterval = new OavpInterval(20);
  levelInterval.setDelay(2);

  beatInterval = new OavpInterval(100);
  beatAmplitude = new OavpAmplitude(0, 1, 0.08);
  beatAmplitudeInterval = new OavpInterval(20);

  visualizers = new OavpShape(oavpData, entityPosition);
  text = new OavpText(entityPosition);
  text.setPadding(20);

  logo = loadShape("test-logo.svg");
  mono = loadFont("RobotoMono-Regular-32.vlw");
  textFont(mono, configs.getInt("fontUnit") * (Math.round(stageWidth * configs.getFloat("fontScale"))));

  style.setTargetColor(cameraPosition);

  introText = text.read("intro.txt");

  debug();
}

void draw() {
  style.updateColorInterp();
  style.getIntermediateColor();
  noFill();
  strokeWeight(2);

  stroke(style.getPrimaryColor());
  background(style.getSecondaryColor());

  camera.update();

  oavpData.forward();
  levelInterval.updateAveraged(oavpData.getLeftLevel());
  beatInterval.update(oavpData.isBeatOnset());
  beatAmplitude.update(oavpData);
  beatAmplitudeInterval.update(beatAmplitude.getValue());

  drawExamples();
}