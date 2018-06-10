import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.Random;
import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.HashMap;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

OavpConfig oavp;
Minim minim;
OavpPosition entityPosition;
OavpCamera defaultCamera;
OavpAnalysis analysis;
OavpVisualizer visualizers;
OavpEmitter emitters;
OavpShape shapes;
OavpText text;
OavpPalette palette;
OavpEntityManager entities;

void setup() {
  // Load configs
  oavp = new OavpConfig("config.json");

  // Screen Setup
  // size(1000, 1000, P3D);
  fullScreen(P3D, 2);
  frameRate(oavp.FRAMERATE);

  // Library initialization
  minim = new Minim(this);
  Ani.init(this);

  // Entity Setup
  entityPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);
  entities = new OavpEntityManager(minim);

  // Default Camera Setup
  defaultCamera = new OavpCamera();
  defaultCamera.view();

  // Style Setup
  palette = new OavpPalette(oavp);

  // Audio Analysis Tools Setup
  analysis = new OavpAnalysis(minim, oavp);

  // Main Visualizer Setup
  visualizers = new OavpVisualizer(analysis, entityPosition, entities);
  emitters = new OavpEmitter(analysis, entities);
  shapes = new OavpShape();

  // Load Files
  entities.addSvg("test-logo.svg");
  entities.addImg("test-image.jpg");

  if (oavp.SHOW_EXAMPLES) {
    setupExamples();
  } else {
    setupSketch();
  }

  // Typography Setup
  text = new OavpText(entityPosition);
  text.setPadding(20);

  debug();
}

void draw() {
  updateHelpers();
  updateEntities();

  if (oavp.SHOW_EXAMPLES) {
    drawExamples();
  } else {
    drawSketch();
  }
}

void updateEntities() {
  entities.update();
  analysis.forward();
  if (oavp.SHOW_EXAMPLES) {
    updateExamples();
  } else {
    updateSketch();
  }
}