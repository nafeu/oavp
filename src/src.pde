import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.spi.*;
import java.util.Random;
import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.Collections;
import java.util.Arrays;
import java.util.Date;
import java.util.UUID;
import java.lang.reflect.Field;
import java.io.File;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.video.*;
import com.hamoid.*;
import javax.sound.midi.*;
import java.util.concurrent.TimeUnit;
import java.awt.datatransfer.StringSelection;
import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import controlP5.*;
import websockets.*;

PApplet context;
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
OavpObjectManager objects;
VideoExport videoExport;
BufferedReader reader;
OavpInput input;
OavpEditor editor;
boolean loaded = false;
boolean isInitializing = true;
ControlP5 cp5;
int loadingDelay = 500;
WebsocketServer server;

int SCALE_FACTOR = 1;

String framePrefix = "frame";
boolean isRecording = false;
boolean isAnimatingBroll = false;
boolean shouldExit = false;

void setup() {
  context = this;
  noLoop();

  println("[ oavp ] github.com/nafeu/oavp");

  // DISPLAY_SETTINGS_START
  fullScreen(P3D, 2);
  // size(3840, 2160, P3D); // 4K
  // DISPLAY_SETTINGS_END

  // Anti-aliasing
  smooth(8);

  // Frame Setup
  frameRate(30);
  surface.setTitle("oavp");

  cp5 = new ControlP5(this);
  setupEditorGui();

  println("[ oavp ] Initializing app...");

  try {
    thread("loadApplication");
    loop();
  } catch (Exception e) {
    System.err.println("[ oavp ] Error during setup");
    debugError(e);
    exit();
  }
}

boolean firstRender = true;

synchronized void draw() {
  if (!loaded) {
    background(0);
    textSize(20);
    fill(255);
    textAlign(CENTER, CENTER);
    text("[ oavp ] : github.com/nafeu/oavp\n\npress 'e' to enter edit mode", width * 0.5, height * 0.5);
  } else {
    try {
      // TODO: Remove deprecated recording code...
      if (oavp.ENABLE_VIDEO_RENDER) {
        String line;
        try {
          if (firstRender == true) {
            TimeUnit.SECONDS.sleep(3);
            firstRender = false;
          }
          line = reader.readLine();
        }
        catch (IOException e) {
          e.printStackTrace();
          line = null;
        }
        if (line == null) {
          // Done reading the file.
          // Close the video file.
          videoExport.endMovie();
          exit();
        } else {
          String[] rawAnalysisData = split(line, oavp.AUDIO_ANALYSIS_SEPERATOR);
          String[] eventsData = split(rawAnalysisData[rawAnalysisData.length - 1], oavp.EVENTS_SEPERATOR);
          float[] analysisData = new float[rawAnalysisData.length];

          for (int i = 0; i < rawAnalysisData.length - 1; i++) {
            analysisData[i] = float(rawAnalysisData[i]);
          }

          updateEntities(oavp, analysisData, eventsData);
          float soundTime = analysisData[0];
          float frameDurationOffset = (1 / oavp.MOVIE_FPS) * oavp.FRAME_OFFSET_MULTIPLIER;
          while (videoExport.getCurrentTime() < (soundTime + frameDurationOffset)) {
            drawSketchDefaults();
            drawSketch();
            objects.draw();
            videoExport.saveFrame();
          }
        }
      } else {
        editor.handleKeyInputs();
        updateHelpers();
        updateEntities();
        if (!editor.isCreateMode) {
          drawSketchDefaults();
          drawSketch();
          objects.draw();
        }
        editor.drawIfEditMode();
        if (EXPORT_SKETCH) {
          editor.exportSketchToFile();
          EXPORT_SKETCH = false;
        }

        if (shouldExit) {
          exit();
        }

        if (isRecording) {
          saveFrame("../package-export-files/" + framePrefix + "-######.png");
        }
      }
    } catch (Exception e) {
      println("[ oavp ] Error during draw loop");
      debugError(e);
      exit();
    }
  }
}

void updateEntities() {
  try {
    input.update();
    entities.update();
    objects.update();
    analysis.forward();
    updateSketchDefaults();
    updateSketch();
  } catch (Exception e) {
    println("[ oavp ] Error during update loop");
    debugError(e);
    exit();
  }
}

void updateEntities(OavpConfig config, float[] analysisData, String[] eventsData) {
  try {
    entities.update();
    objects.update();
    analysis.readAnalysis(config, analysisData, eventsData);
    updateSketch();
  } catch (Exception e) {
    println("[ oavp ] Error during update loop");
    debugError(e);
    exit();
  }
}

void movieEvent(Movie m) {
  m.read();
}

void loadApplication() {
  oavp = new OavpConfig();

  // Inputs
  input = new OavpInput();

  // Library initialization
  minim = new Minim(context);
  Ani.init(context);

  // Entity Setup
  entityPosition = new OavpPosition(0, 0);
  entities = new OavpEntityManager(context, minim);

  // Objects Setup
  objects = new OavpObjectManager();

  // Default Camera Setup
  if (oavp.ENABLE_ORTHO) {
    ortho();
  }

  // Style Setup
  palette = new OavpPalette(oavp);

  // Audio Analysis Tools Setup
  analysis = new OavpAnalysis(minim, oavp);

  if (oavp.ANALYZE_AUDIO) {
    analysis.analyzeAudioFile(oavp);
  }

  // Main Visualizer Setup
  visualizers = new OavpVisualizer(analysis, entityPosition, entities);
  emitters = new OavpEmitter(analysis, entities);
  shapes = new OavpShape();

  // Autoload Files
  File[] files = new File(dataPath("")).listFiles();

  for (int i = 0; i < files.length; i++) {
    String extension = getFileExtension(files[i]);
    String name = files[i].getName();

    switch(extension) {
      case "svg":
        println("[ oavp ] Loading svg: " + name);
        entities.addSvg(name);
        break;
      case "jpg":
      case "png":
        println("[ oavp ] Loading image: " + name);
        entities.addImg(name);
        break;
      case "mov":
        println("[ oavp ] Loading movie: " + name);
        entities.addMovie(name);
        break;
      default:
        break;
    }
  }

  // Activate Video Export
  if (oavp.ENABLE_VIDEO_RENDER) {
    reader = createReader(oavp.AUDIO_FILE + ".deep-analysis.txt");
    videoExport = new VideoExport(this, "export.mp4");
    videoExport.setFrameRate(oavp.MOVIE_FPS);
    videoExport.setAudioFileName(oavp.AUDIO_FILE);
    videoExport.setDebugging(false);
    videoExport.startMovie();
  }

  setupPreSketchDefaults();
  setupSketch();
  setupPostSketchDefaults();

  println("[ oavp ] Initialization complete.");
  isInitializing = false;

  // Typography Setup
  text = new OavpText(oavp, entityPosition);

  // Editor
  editor = new OavpEditor(input, objects, text);

  // Websocket Server
  server = new WebsocketServer(this, oavp.WEBSOCKET_PORT, "/commands");

  setupSketchPostEditor();

  synchronized(this) {
    delay(loadingDelay);
    loaded = true;
  }
}

void keyPressed() {
  // Log every keypress:
  // println("[ oavp ] Key pressed: " + key + " : " + keyCode);

  switch(key) {
    case ESC:
      key = 0;
      if (editor.isCreateMode) {
        editor.toggleCreateMode();
      } else if (editor.isEditMode) {
        editor.toggleEditMode();
      }
      break;
  }

  input.handleKeyPressed(keyCode);

  if (!editor.isEditMode) {
    handleEvents(keyCode);
  }
}

void mousePressed() {
  input.handleMousePressed();
}

void mouseReleased() {
  input.handleMouseReleased();
}

void setupPreSketchDefaults() {
  entities.addPulser("beat-pulser").duration(0.3);
  entities.addToggle("beat-toggle-hard").duration(0.3);
  entities.addToggle("beat-toggle-soft").duration(0.3);
  entities.addCounter("beat-counter").duration(0.3);
  entities.addPulser("spacebar-pulser").duration(0.3);
  entities.addToggle("spacebar-toggle-hard").duration(0.3);
  entities.addToggle("spacebar-toggle-soft").duration(0.3);
  entities.addCounter("spacebar-counter").duration(0.3);
  entities.addCounter("spacebar-counter-2").duration(0.3);
  entities.addCounter("spacebar-counter-4").duration(0.3);
  entities.addCounter("spacebar-counter-8").duration(0.3);
  entities.addRotator("spacebar-rotator").duration(1.0).add(0.0).add(1.0).add(2.0).add(3.0);
  entities.addRotator("spacebar-rotator-2").duration(1.0).add(0.0).add(1.0).add(2.0).add(3.0);
  entities.addRotator("spacebar-rotator-4").duration(1.0).add(0.0).add(1.0).add(2.0).add(3.0);
  entities.addRotator("spacebar-rotator-8").duration(1.0).add(0.0).add(1.0).add(2.0).add(3.0);
  entities.addPulser("quantized-pulser").duration(0.3);
  entities.addToggle("quantized-toggle-hard").duration(0.3);
  entities.addToggle("quantized-toggle-soft").duration(0.3);
  entities.addCounter("quantized-counter").duration(0.3);
  entities.addEmissions("spacebar");
  entities.addEmissions("spacebar-2");
  entities.addEmissions("spacebar-4");
  entities.addEmissions("spacebar-8");

  entities.addInterval("spacebar-pulser-interval", 10, 1);

  setupPreSketchIntervals();

  setSketchSeed(0);
}

void setGlobalDurations(float duration) {
  entities.getPulser("beat-pulser").duration(duration);
  entities.getToggle("beat-toggle-hard").duration(duration);
  entities.getToggle("beat-toggle-soft").duration(duration);
  entities.getCounter("beat-counter").duration(duration);
  entities.getPulser("spacebar-pulser").duration(duration);
  entities.getToggle("spacebar-toggle-hard").duration(duration);
  entities.getToggle("spacebar-toggle-soft").duration(duration);
  entities.getCounter("spacebar-counter").duration(duration);
  entities.getCounter("spacebar-counter-2").duration(duration);
  entities.getCounter("spacebar-counter-4").duration(duration);
  entities.getCounter("spacebar-counter-8").duration(duration);
  entities.getPulser("quantized-pulser").duration(duration);
  entities.getToggle("quantized-toggle-hard").duration(duration);
  entities.getToggle("quantized-toggle-soft").duration(duration);
  entities.getCounter("quantized-counter").duration(duration);
  emitters.useEmissions("spacebar").duration(duration);
  emitters.useEmissions("spacebar-2").duration(duration);
  emitters.useEmissions("spacebar-4").duration(duration);
  emitters.useEmissions("spacebar-8").duration(duration);
}

void handleEvents(int code) {
  if (code == 32 /* SPACE */) {
    println("[ KEY: SPACE ] Incrementing spacebar entities...");
    entities.getCounter("spacebar-counter").increment();
    entities.getPulser("spacebar-pulser").pulse();
    entities.getToggle("spacebar-toggle-hard").toggle();
    entities.getToggle("spacebar-toggle-soft").softToggle();

    int spacebarCount = entities.getCounter("spacebar-counter").getCount();
    boolean isSecondCount = spacebarCount % 2 == 0;
    boolean isFourthCount = spacebarCount % 4 == 0;
    boolean isEigthCount = spacebarCount % 8 == 0;

    entities.getCounter("spacebar-counter-2").incrementIf(isSecondCount);
    entities.getCounter("spacebar-counter-4").incrementIf(isFourthCount);
    entities.getCounter("spacebar-counter-8").incrementIf(isEigthCount);
    entities.getRotator("spacebar-rotator").rotate();
    entities.getRotator("spacebar-rotator-2").rotateIf(isSecondCount);
    entities.getRotator("spacebar-rotator-4").rotateIf(isFourthCount);
    entities.getRotator("spacebar-rotator-8").rotateIf(isEigthCount);

    emitters.useEmissions("spacebar").emit();
    emitters.useEmissions("spacebar-2").emitIf(isSecondCount);
    emitters.useEmissions("spacebar-4").emitIf(isFourthCount);
    emitters.useEmissions("spacebar-8").emitIf(isEigthCount);
  }

  if (code == 49 /* 1 */) { setGlobalDurations(0.3); globalSpeed = 0.1;   }
  if (code == 50 /* 2 */) { setGlobalDurations(1);   globalSpeed = 0.05;  }
  if (code == 51 /* 3 */) { setGlobalDurations(2);   globalSpeed = 0.01;  }
  if (code == 52 /* 4 */) { setGlobalDurations(5);   globalSpeed = 0.001; }

  if (code == KEY_Y) {
    println("[ oavp ] Exporting screenshot...");
    String screenshotName = str(day())
      + "-" + str(month())
      + "-" + str(year())
      + "-" + str(hour()) + str(minute()) + str(second());

    saveFrame("../screenshots/" + screenshotName + "-" + width + "x" + height + ".png");
    println("[ oavp ] Screenshot exported.");
  }
}

void setupPostSketchDefaults() {
  if (!objects.has("background")) {
    objects.add("background", "blank")
      .fillColor(palette.flat.black)
      .strokeColor(palette.flat.white)
      .strokeWeight(2);
  }
  if (!objects.has("camera")) {
    int perspectiveDistance = 100000 * SCALE_FACTOR;

    objects.add("camera", "blank")
      .set("x", 0)
      .set("y", 0)
      .set("z", 0)
      .set("w", 0)
      .set("h", 0)
      .set("l", 0)
      .set("paramA", perspectiveDistance)
      .set("paramB", 0)
      .set("paramC", 0);
  }
}

void updateSketchDefaults() {
  boolean isBeatOnset = analysis.isBeatOnset();
  boolean isQuantizedOnset = analysis.isQuantizedOnset();
  entities.getPulser("beat-pulser").pulseIf(isBeatOnset);
  entities.getToggle("beat-toggle-hard").toggleIf(isBeatOnset);
  entities.getToggle("beat-toggle-soft").softToggleIf(isBeatOnset);
  entities.getCounter("beat-counter").incrementIf(isBeatOnset);
  entities.getPulser("quantized-pulser").pulseIf(isQuantizedOnset);
  entities.getToggle("quantized-toggle-hard").toggleIf(isQuantizedOnset);
  entities.getToggle("quantized-toggle-soft").softToggleIf(isQuantizedOnset);
  entities.getCounter("quantized-counter").incrementIf(isQuantizedOnset);
  entities.getInterval("spacebar-pulser-interval")
    .update(entities.getPulser("spacebar-pulser").getValue());

  updateDefaultIntervals();
}

void drawSketchDefaults() {
  drawCamera();
  drawBackground();

  OavpVariable cameraVariable = objects.get("camera").variable;
}

void drawBackground() {
  OavpVariable backgroundVariable = objects.get("background").variable;
  palette.reset(
    backgroundVariable.fillColor,
    backgroundVariable.strokeColor,
    backgroundVariable.strokeWeight
  );
}

void drawCamera() {
  OavpVariable cameraVariable = objects.get("camera").variable;

  PVector eye = new PVector();
  PVector center = new PVector();
  PVector up = new PVector();

  eye.x = width/2.0 + cameraVariable.val("x");
  eye.y = height/2.0 + cameraVariable.val("y");
  eye.z = ((height/2.0) / tan(PI*30.0 / 180.0)) + cameraVariable.val("z");
  center.x = width/2.0 + + cameraVariable.val("x");
  center.y = height/2.0 + cameraVariable.val("y");
  center.z = 0 + cameraVariable.val("z");
  up.x = 0 + + cameraVariable.val("x");
  up.y = 1 + cameraVariable.val("y");
  up.z = 0 + cameraVariable.val("z");

  camera(
    eye.x * SCALE_FACTOR, eye.y * SCALE_FACTOR, eye.z * SCALE_FACTOR,
    center.x * SCALE_FACTOR, center.y * SCALE_FACTOR, center.z * SCALE_FACTOR,
    up.x * SCALE_FACTOR, up.y * SCALE_FACTOR, up.z * SCALE_FACTOR
  );

  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);

  perspective(
    fov, float(width)/float(height),
    cameraZ/10.0 * SCALE_FACTOR, (cameraZ * 10.0 + cameraVariable.val("paramA")) * SCALE_FACTOR);
}
