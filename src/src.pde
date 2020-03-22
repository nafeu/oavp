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

void setup() {
  context = this;

  println("[ oavp ] Version 0.1 - github.com/nafeu/oavp");

  // DISPLAY_SETTINGS_START
  fullScreen(P3D, 2);
  // size(750, 750, P3D);
  // DISPLAY_SETTINGS_END

  // Frame Setup
  frameRate(60);
  surface.setTitle("oavp");

  try {
    thread("loadApplication");
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
    textSize(25);
    fill(255);
    textAlign(CENTER, CENTER);
    text("[ loading ]", oavp.width(0.5), oavp.height(0.5));
  } else {
    try {
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
  entityPosition = new OavpPosition(0, 0, oavp.GRID_SCALE);
  entities = new OavpEntityManager(context, minim);

  // Objects Setup
  objects = new OavpObjectManager();

  // Default Camera Setup
  defaultCamera = new OavpCamera();
  defaultCamera.view();

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

  setupSketchDefaults();
  setupSketch();

  // Typography Setup
  text = new OavpText(oavp, entityPosition);

  // Editor
  editor = new OavpEditor(input, objects, text);

  synchronized(this) {
    loaded = true;
  }
}

void keyPressed() {
  input.handleKeyPressed(keyCode);
}

void mousePressed() {
  input.handleMousePressed();
}

void mouseReleased() {
  input.handleMouseReleased();
}

void setupSketchDefaults() {
  objects.add("background", "blank")
    .fillColor(palette.flat.black)
    .strokeColor(palette.flat.white)
    .strokeWeight(2);

  entities.addPulser("beat-pulser").duration(0.3);
  entities.addToggle("beat-toggle-hard").duration(0.3);
  entities.addToggle("beat-toggle-soft").duration(0.3);
  entities.addCounter("beat-counter").duration(0.3);
  entities.addPulser("quantized-pulser").duration(0.3);
  entities.addToggle("quantized-toggle-hard").duration(0.3);
  entities.addToggle("quantized-toggle-soft").duration(0.3);
  entities.addCounter("quantized-counter").duration(0.3);
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
}

void drawSketchDefaults() {
  OavpVariable backgroundVariable = objects.get("background").variable;
  palette.reset(
    backgroundVariable.fillColor,
    backgroundVariable.strokeColor,
    backgroundVariable.strokeWeight
  );
}