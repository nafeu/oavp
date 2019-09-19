<h1><img src="http://phrakture.com/images/github/oavp-icon-updated.png" width="72" height="72" valign="middle"/>Open Audio Visualizers for Processing</h1>

A set of tools to help build interactive audio visualizers with [processing](https://processing.org), written in Java using the Processing java-applet library with the help of Minim, Ani and the Beads project libraries.

# Getting Started / Docs

Check out the full guide and docs available [at the repo's wiki here](https://github.com/nafeu/oavp/wiki). Documentation is a still a huge work-in-progress and I would greatly appreciate if anyone was interested in helping out :)

# Requirements

- **Python 3**
- [`ffmpeg`](https://evermeet.cx/ffmpeg/)

# Setup and Installation

- Download and install the [`Processing IDE`](https://processing.org/download/)
- Open the Processing IDE (create a new sketch if one isn't already create for you) and do the following:
  - Go to `Tools` > `Install "processing-java"`
  - Go to `Sketch` > `Add Library` > `Import Library` and install the following libraries:
    - [`Minim`](https://github.com/ddf/Minim) (for realtime audio analysis)
    - [`Ani`](https://github.com/b-g/Ani) (for tweening and smooth animations)
    - [`Beads`](https://github.com/orsjb/beads) (for time/tempo synced rhythmic operations)
    - [`video`](https://github.com/processing/processing-video) (for incorporation of video)
    - [`VideoExport`](https://funprogramming.org/VideoExport-for-Processing/)

```
git clone https://github.com/nafeu/oavp.git [PROJECT_NAME]
cd [PROJECT_NAME]
```

## Creating & Running Sketches

- Run `python3 oavp.py --new-sketch [SKETCH_NAME]`
- Open/edit the generated `.oavp` file from `sketches/`
- Use `python3 oavp.py [SKETCH_NAME]` to run the sketch.

## Generating Documentation

```
python3 oavp.py --generate-docs [PATH_TO_PDE_FILE] [BASE_CLASS_NAME] --export-to [DOC_FILE_NAME]
```

## Credits

Nafeu Nasir

## License

MIT
