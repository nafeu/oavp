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

Once you run the sketch, give it a few seconds to fully launch, then press `e` to activate edit mode. Refer to the keybindings table below for usage instructions:

| Key | Description | Usage |
|-|-|-|
| `e` | Activate edit mode |  |
| `n` | Create new object | `↕` then `enter` to select an object to create |
| `[` | Select previous object in list |  |
| `]` | Select next object in list |  |
| `d` | Duplicate selected object |  |
| `w` | Delete selected object (cannot delete special objects like `Camera` or `Background`) |  |
| `q` | Toggle snap grid intensity | toggle between *low*, *medium*, *high* or *disabled* |
| `m` | Select Move Tool: Move object origin in xyz dimensions | `↔` to move in **x** dimension<br />`↕` to move in **y** dimension<br />`↕` + `shift` to move in **z** dimension |
| `s` | Select Resize Tool: Resize the object (only applies to a few objects, use **transform** option otherwise) | `↕` to change **s** value |
| `t` | Select Transform Tool: Transform object width, height or length | `↔` to change **w**<br />`↕` to change **h**<br />`↕` + `shift` to change **l** |
| `r` | Select Rotate Tool: Rotate object around xyz dimensions | `↔` eto change **xr**<br />`↕` to change **yr**<br />`↕` + `shift` to change **zr** |
| `c` | Select Colour Tool: Change object stroke and fill colours | `↔` to change selected colour<br />`↕` to change selected palette<br />`enter` to apply selection to stroke<br />`shift` + `enter` to apply selection to fill<br />`ctrl` + `enter` to apply selection to stroke and fill<br />`delete/backspace` to remove stroke<br />`shift` + `delete/backspace` to remove fill<br />`ctrl` + `delete/backspace` reset colours<br />`backslash` to select random palette<br />`shift` + `backslash` to apply random stroke and fill combination from selected palette |
| `b` | Select Weight Tool: Change object's stroke weight | `↕` to change **strokeWeight** |
| `z` | Select Modifiers Tool: Augment or animate object properties with different modifier types | `↕` to select an object property<br />`↔` to change value<br />`enter` to select modifier type |
| `v` | Select Variation Tool: Select different object variation | `↕` to change object variation (only applies to some objects) |
| `p` | Select Params Tool: Change additional object parameters (only applies to some objects) | `↕` to select an object parameter<br />`↔` to change value |
| `o` | Select Mod Delay Tool: Change frame delay for modifiers (animations or augmentations) | `↕` to change **modDelay** |
| `a` | Select Iter Count Tool: Change number of object iterations being drawn | `↕` to change **i** |
| `i` | Select Iterations Tool: Augment object properties based on which iteration is being drawn with an iteration function | `↕` to select an object property<br />`↔` to change value<br />`enter` to select iteration function |
| `x` | Export sketch to console |  |
| `y` | Take screenshot | _\*only works if not in edit mode_ |

# Documentation

Check out the full guide and docs available [at the repo's wiki here](https://github.com/nafeu/oavp/wiki). Documentation is a still a huge work-in-progress and I would greatly appreciate if anyone was interested in helping out. PRs are welcome!

*2022 Update: the oavp wiki docs are very outdated and due for an overhaul.*

## Credits

Nafeu Nasir

## License

MIT
