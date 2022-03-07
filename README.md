<h1><img src="http://phrakture.com/images/github/oavp-icon-updated.png" width="72" height="72" valign="middle"/>Open Audio Visualizers for Processing</h1>

A set of tools to help build interactive audio visualizers with [processing](https://processing.org), written in Java using the Processing java-applet library with the help of Minim, Ani and the Beads project libraries.

# Getting Started / Docs

Check out the full guide and docs available [at the repo's wiki here](https://github.com/nafeu/oavp/wiki). Documentation is a still a huge work-in-progress and I would greatly appreciate if anyone was interested in helping out :)

# Requirements

- [`ffmpeg`](https://evermeet.cx/ffmpeg/)
- [`youtube-dl`](https://evermeet.cx/ffmpeg/)

# Setup and Installation

```
git clone https://github.com/nafeu/oavp.git [PROJECT_NAME]
cd [PROJECT_NAME]
```

- Download and install the [`Processing IDE`](https://processing.org/download/)
- Open the Processing IDE (create a new sketch if one isn't already create for you) and do the following:
  - Go to `Tools` > `Install "processing-java"`
  - Go to `Processing` > `Preferences...` and set Sketchbook location to the `[PATH_TO_OAVP_FOLDER]/src`:
- Run the processing sketch

## Creating & Running Sketches

...

## Using MP3 Files For Visualization

```
youtube-dl -x --audio-format mp3 https://www.youtube.com/watch?v=3jZqAqVMKvo
```

## Credits

Nafeu Nasir

## License

MIT
