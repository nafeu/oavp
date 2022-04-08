<img src="https://nafeu.github.io/oavp/oavp-logo-banner.png"/>

A custom editor with scriptable objects to help build audio visualizers and generative art. Built with [Processing Java](https://processing.org), along with the Minim, Ani and ControlP5 libraries.

# Setup and Installation

### Mac/Linux

```
git clone https://github.com/nafeu/oavp.git
cd oavp
cp sample-sketch.txt src/sketch.pde
```

### PC

1. Download this repo onto your machine and navigate to the `src` folder.
2. Create a new file inside `oavp/src` called `sketch.pde`
3. Copy the contents of `sample-sketch.txt` into `sketch.pde`

### Dependency Installation (All Systems)

1. Download and install the [`Processing IDE`](https://processing.org/download/)
2. Open the Processing IDE (create a new sketch if one isn't already create for you) and do the following:
  - Go to `Tools` > `Install "processing-java"`

  <img src="https://nafeu.github.io/oavp/oavp-install-processing-java.png"/>

  - Go to `Sketch` > `Import Library` and install the following libraries:
    - [`Ani`](http://www.looksgood.de/libraries/Ani/)
    - [`Minim`](https://code.compartmental.net/minim/)
    - [`ControlP5`](https://sojamo.de/libraries/controlP5/)
    - [`Video Export`](https://funprogramming.org/VideoExport-for-Processing/)
    - [`Processing Video`](https://processing.org/reference/libraries/video/index.html)

  <img src="https://nafeu.github.io/oavp/oavp-add-library.png"/>

3. Open the `oavp/src` folder in the **Processing IDE** and run the sketch.

Alternatively you can also use [`processing-sublime`](https://github.com/b-g/processing-sublime) to build and run oavp using Sublime Text or use [this](https://marketplace.visualstudio.com/items?itemName=Tobiah.language-pde) vscode plugin.

## Creating & Running Sketches

After launching the editor you can press `e` to activate edit mode.

TODO: Update these docs and add all keybinds here

# Documentation

Check out the full guide and docs available [at the repo's wiki here](https://github.com/nafeu/oavp/wiki). Documentation is a still a huge work-in-progress and I would greatly appreciate if anyone was interested in helping out. PRs are welcome!

*2022 Update: the oavp wiki docs are very outdated and due for an overhaul.*

## Credits

Nafeu Nasir

## License

MIT
