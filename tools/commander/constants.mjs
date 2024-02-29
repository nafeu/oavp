export const OAVP_EDITOR_TOOL = {
  MOVE: 0,
  RESIZE: 1,
  TRANSFORM: 2,
  ROTATE: 3,
  COLOR: 4,
  WEIGHT: 5,
  MODIFIER: 6,
  VARIATION: 7,
  PARAMS: 8,
  MOD_DELAY: 9,
  ITERATION: 10,
  ITERATION_COUNT: 11
}

export const OAVP_OBJECT_PROPERTIES = [
  { property: "x", defaultValue: 0, type: "int", tool: OAVP_EDITOR_TOOL.MOVE },
  { property: "xMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "xModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "xIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "xIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "xr", defaultValue: 0, type: "int", tool: OAVP_EDITOR_TOOL.ROTATE },
  { property: "xrMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "xrModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "xrIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "xrIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "y", defaultValue: 0, type: "int", tool: OAVP_EDITOR_TOOL.MOVE },
  { property: "yMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "yModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "yIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "yIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "yr", defaultValue: 0, type: "int", tool: OAVP_EDITOR_TOOL.ROTATE },
  { property: "yrMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "yrModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "yrIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "yrIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "z", defaultValue: 0, type: "int", tool: OAVP_EDITOR_TOOL.MOVE },
  { property: "zMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "zModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "zIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "zIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "zr", defaultValue: 0, type: "int", tool: OAVP_EDITOR_TOOL.ROTATE },
  { property: "zrMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "zrModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "zrIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "zrIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "w", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.TRANSFORM },
  { property: "wMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "wModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "wIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "wIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "h", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.TRANSFORM },
  { property: "hMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "hModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "hIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "hIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "l", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.TRANSFORM },
  { property: "lMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "lModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "lIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "lIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "s", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.RESIZE },
  { property: "sMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "sModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "sIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "sIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "strokeColor", defaultValue: -1, type: "color", tool: OAVP_EDITOR_TOOL.COLOR },
  { property: "strokeColorMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "strokeColorModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "strokeColorIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "strokeColorIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "strokeWeight", defaultValue: 2.0, type: "float", tool: OAVP_EDITOR_TOOL.WEIGHT },
  { property: "strokeWeightMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "strokeWeightModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "strokeWeightIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "strokeWeightIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "fillColor", defaultValue: -16777216, type: "color", tool: OAVP_EDITOR_TOOL.COLOR },
  { property: "fillColorMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "fillColorModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "fillColorIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "fillColorIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramA", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.PARAMS },
  { property: "paramAMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramAModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramAIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramAIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramB", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.PARAMS },
  { property: "paramBMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramBModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramBIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramBIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramC", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.PARAMS },
  { property: "paramCMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramCModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramCIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramCIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramD", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.PARAMS },
  { property: "paramDMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramDModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramDIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramDIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramE", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.PARAMS },
  { property: "paramEMod", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramEModType", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.MODIFIER },
  { property: "paramEIter", defaultValue: 0.0, type: "float", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "paramEIterFunc", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.ITERATION },
  { property: "modDelay", defaultValue: 0, type: "int", tool: OAVP_EDITOR_TOOL.MOD_DELAY },
  { property: "variation", defaultValue: "none", type: "String", tool: OAVP_EDITOR_TOOL.VARIATION },
  { property: "i", defaultValue: 1, type: "int", tool: OAVP_EDITOR_TOOL.ITERATION_COUNT },
];

const palette = {
  flat: {
    white: -1,
    black: -1618884
  }
}

export const OAVP_OBJECT_DEFAULTS = {
  "Arc": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "strokeColor", value: palette.flat.white },
    { property: "paramA", value: 0 },
    { property: "paramB", value: 180 }
  ],
  "Box": [
    { property: "s", value: 100 },
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "l", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Bullseye": [
    { property: "s", value: 100 },
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Circle": [
    { property: "s", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "CurvedLine": [
    { property: "w", value: 100 },
    { property: "s", value: 0 },
    { property: "paramB", value: -50 },
    { property: "paramD", value: 50 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Flatbox": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "l", value: 100 },
    { property: "strokeColor", value: palette.flat.white },
    { property: "fillColor", value: palette.flat.black }
  ],
  "GoldenRatio": [
    { property: "s", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Gradient": [
    { property: "w", value: 100 }
  ],
  "GridInterval": [
    { property: "w", value: 100 }
  ],
  "Line": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "s", value: 0 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Orbital": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "s", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Pyramid": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "l", value: 100 },
    { property: "strokeColor", value: palette.flat.white },
    { property: "fillColor", value: palette.flat.black }
  ],
  "RadialSpectrum": [
    { property: "w", value: 100 }
  ],
  "Rectangle": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "strokeColor", value: palette.flat.white },
    { property: "s", value: 0 }
  ],
  "Shader": [
    // Note: skip for the time being
    { property: "w", value: 100 }
  ],
  "Spectrum": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "SpectrumMesh": [
    { property: "s", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Sphere": [
    { property: "s", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Splash": [
    { property: "s", value: 100 },
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Terrain": [
    { property: "s", value: 10 },
    { property: "paramA", value: 50 },
    { property: "paramB", value: 100 },
    { property: "paramC", value: 100 },
    { property: "paramD", value: 50 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Triangle": [
    { property: "s", value: 100 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Vegetation": [
    { property: "s", value: 20 },
    { property: "h", value: 0 },
    { property: "paramA", value: 500 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "Waveform": [
    { property: "w", value: 100 },
    { property: "h", value: 100 },
    { property: "s", value: 5 },
    { property: "strokeColor", value: palette.flat.white }
  ],
  "ZRectangles": [
    { property: "s", value: 100 },
    { property: "radius", value: 50 },
    { property: "strokeColor", value: palette.flat.white }
  ]
}

export const OAVP_AVAILABLE_SHAPES = [
  "Arc",
  "Box",
  "Bullseye",
  "Circle",
  "CurvedLine",
  "Flatbox",
  "GoldenRatio",
  "Gradient",
  "GridInterval",
  "Line",
  "Orbital",
  "Pyramid",
  "RadialSpectrum",
  "Rectangle",
  "Shader",
  "Spectrum",
  "SpectrumMesh",
  "Sphere",
  "Splash",
  "Terrain",
  "Triangle",
  "Vegetation",
  "Waveform",
  "ZRectangles",
];

export const OAVP_AVAILABLE_SHAPE_INDEX_MAPPING = OAVP_AVAILABLE_SHAPES.reduce((mapping, item, index) => {
  mapping[item] = index;

  return mapping;
}, {});

export const OAVP_SNAP_LEVEL_STANDARD = 'STANDARD';
export const OAVP_SNAP_LEVEL_ROTATIONAL = 'ROTATIONAL';
export const OAVP_SNAP_LEVEL_CARDINAL = 'CARDINAL';
export const OAVP_SNAP_LEVEL_SINGULAR = 'SINGULAR';

export const OAVP_SNAP_LEVEL_TYPES = [
  OAVP_SNAP_LEVEL_STANDARD,
  OAVP_SNAP_LEVEL_ROTATIONAL,
  OAVP_SNAP_LEVEL_CARDINAL,
  OAVP_SNAP_LEVEL_SINGULAR
]

export const OAVP_SNAP_LEVELS = {
  [OAVP_SNAP_LEVEL_STANDARD]: { off: 1, low: 5, medium: 50, high: 200 },
  [OAVP_SNAP_LEVEL_ROTATIONAL]: { off: 1, low: 5, medium: 15, high: 30 },
  [OAVP_SNAP_LEVEL_CARDINAL]: { off: 1, low: 5, medium: 10, high: 20 },
  [OAVP_SNAP_LEVEL_SINGULAR]: { off: 1, low: 1, medium: 1, high: 1 }
}

export const OAVP_SNAP_LEVELS_PROPERTY_MAPPING = {
  [OAVP_SNAP_LEVEL_STANDARD]: [
    'h',
    'hIter',
    'hMod',
    'l',
    'lIter',
    'lMod',
    'paramA',
    'paramAIter',
    'paramAMod',
    'paramB',
    'paramBIter',
    'paramBMod',
    'paramC',
    'paramCIter',
    'paramCMod',
    'paramD',
    'paramDIter',
    'paramDMod',
    'paramE',
    'paramEIter',
    'paramEMod',
    's',
    'sIter',
    'sMod',
    'w',
    'wIter',
    'wMod',
    'x',
    'xIter',
    'xMod',
    'y',
    'yIter',
    'yMod',
    'z',
    'zIter',
    'zMod',
  ],
  [OAVP_SNAP_LEVEL_ROTATIONAL]: [
    'xr',
    'xrIter',
    'xrMod',
    'yr',
    'yrIter',
    'yrMod',
    'zr',
    'zrIter',
    'zrMod',
  ],
  [OAVP_SNAP_LEVEL_CARDINAL]: [
    'modDelay',
    'i'
  ],
  [OAVP_SNAP_LEVEL_SINGULAR]: [
    'strokeColor',
    'fillColor',
    'fillColorIterFunc',
    'fillColorModType',
    'hIterFunc',
    'hModType',
    'lIterFunc',
    'lModType',
    'paramAIterFunc',
    'paramAModType',
    'paramBIterFunc',
    'paramBModType',
    'paramCIterFunc',
    'paramCModType',
    'paramDIterFunc',
    'paramDModType',
    'paramEIterFunc',
    'paramEModType',
    'sIterFunc',
    'sModType',
    'strokeColorIterFunc',
    'strokeColorModType',
    'strokeWeight',
    'strokeWeightIterFunc',
    'strokeWeightModType',
    'variation',
    'wIterFunc',
    'wModType',
    'xIterFunc',
    'xModType',
    'xrIterFunc',
    'xrModType',
    'yIterFunc',
    'yModType',
    'yrIterFunc',
    'yrModType',
    'zIterFunc',
    'zModType',
    'zrIterFunc',
    'zrModType',
  ]
}

export const OAVP_PROPERTY_SNAP_LEVELS_MAPPING = OAVP_SNAP_LEVEL_TYPES.reduce((mapping, snapLevelType) => {
  OAVP_SNAP_LEVELS_PROPERTY_MAPPING[snapLevelType].forEach(property => {
    mapping[property] = OAVP_SNAP_LEVELS[snapLevelType]
  });

  return mapping;
}, {})

export const OAVP_ITER_FUNCS = [
  'none',
  'fib 20',
  'sin(x)',
  'sqrt(x)',
  '2x',
  'x/2',
  'x/3',
  'x/4',
  'x*(x/10)',
  '1/x',
  'x^2',
  'mod 3',
  'floor(x/3)',
  'mod 5',
  'floor(x/5)',
  'mod 10',
  'floor(x/10)',
  'mod 25',
  'floor(x/25)',
  'random 100'
]

export const OAVP_MOD_TYPES = [
  'none',
  'spacebar-pulser',
  'spacebar-toggle-hard',
  'spacebar-toggle-soft',
  'spacebar-counter',
  'spacebar-counter-2',
  'spacebar-counter-4',
  'spacebar-counter-8',
  'spacebar-rotator',
  'spacebar-rotator-2',
  'spacebar-rotator-4',
  'spacebar-rotator-8',
  'framecount',
  'level',
  'osc-fast',
  'osc-normal',
  'osc-slow',
  'sine',
  'square',
  'sawtooth',
  // 'lows',
  // 'mid-lows',
  // 'mid-highs',
  // 'highs',
  // 'beat-pulser',
  // 'beat-toggle-hard',
  // 'beat-toggle-soft',
  // 'beat-counter',
  // 'quantized-pulser',
  // 'quantized-toggle-hard',
  // 'quantized-toggle-soft',
  // 'quantized-counter',
  'mouse-x',
  'mouse-y'
]

export const SINGLE_LINE_PARAMETER_SET_DELIMITER = "&";
export const OBJECT_NAME_AND_PROPERTIES_DELIMITER = "|";
export const OBJECT_NAME_AND_TAGS_DELIMITER = "_";
export const SKETCH_WEBSOCKET_SERVER_URL = "ws://localhost:6287/commands";
export const WEBSERVER_PORT = 3001;
export const COMMANDER_WEBSOCKET_SERVER_PORT = 3002;
export const DIRECTORY_PATH = "./";
export const TARGET_FILE_NAME = "target.txt";
export const DUMP_FILE_PATH = "preset-dump.txt";
export const EXPORT_FILE_NAME = "export.txt";
export const EXPORT_IMAGE_NAME = "export.png";
export const EXPORT_FILE_DIR = "../../exports";
export const GENOBJ_FILE_NAME = "genobj.json";
export const IMAGE_COPY_TIMEOUT_DURATION = 500;
export const FILE_COPY_TIMEOUT_DURATION = 500;
export const OVERRIDE_VALUES_DELIMITER = ";";
export const PROPERTY_VALUE_DELIMITER = ":";
export const OBJECT_NAME_REGEX = /\.add\("[^"]+","([^"]+)"\)/;
export const OBJECT_NAME_AND_SHAPE_REGEX = /objects\.add\("([^"]+)",\s*"([^"]+)"\)/;
export const OBJECT_PROPERTIES_REGEX = /\.set\("([^"]+)",\s*([^)]+)\)/g;
export const OBJECT_PROPERTY_KEY_AND_VALUE_REGEX = /\("([^"]+)","?([^"]+)"?\)/;
export const COLOR_EXTRACTION_REGEX = /\((-?\d+)\)/;

export const INVALID_TAGS = [
  'nofill',
  'nostroke',
  'backgroundstroke',
  'notbackgroundstroke',
  'accentastroke',
  'notaccentastroke',
  'accentbstroke',
  'notaccentbstroke',
  'accentcstroke',
  'notaccentcstroke',
  'accentdstroke',
  'notaccentdstroke',
  'backgroundfill',
  'notbackgroundfill',
  'accentafill',
  'notaccentafill',
  'accentbfill',
  'notaccentbfill',
  'accentcfill',
  'notaccentcfill',
  'accentdfill',
  'notaccentdfill',
  'accenta',
  'accentb',
  'accentc',
  'accentd',
  'accente',
  'main',
  'background',
  'camera',
  'left',
  'right',
  'middle',
  'a 1',
  'a 2',
  'a 3',
  'b 1',
  'b 2',
  'b 3',
  'c 1',
  'c 2',
  'c 3',
  'a',
  'b'
]

export const ANIMATION_SPEED_MULTIPLIER = {
  slowest: 0.25,
  slower:  0.5,
  fixed:   1,
  faster:  3,
  fastest: 5
}

export const BROLL_CAMERA_PRESETS = [
  {
    cameraPresetName: 'Stationary',
    modValue: 0,
    orientation: 'forward',
    easing: 'linear'
  },
  {
    cameraPresetName: 'FixedForward',
    modValue: -1000,
    orientation: 'forward',
    easing: 'linear'
  },
  {
    cameraPresetName: 'FastestBackward',
    modValue: -5000,
    orientation: 'backward',
    easing: 'linear'
  },
  {
    cameraPresetName: 'SlowerForward',
    modValue: -500,
    orientation: 'forward',
    easing: 'linear'
  },
  {
    cameraPresetName: 'EaseInFasterBackward',
    modValue: -3000,
    orientation: 'backward',
    easing: 'easeInQuad'
  }
]
