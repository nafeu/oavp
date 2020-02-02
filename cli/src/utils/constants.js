export const DISPLAY_SETTINGS_PATTERN = /(DISPLAY_SETTINGS_START[\s\S]+DISPLAY_SETTINGS_END)/g;
export const DISPLAY_SETTINGS_MAPPING = {
  'fullscreen': 'fullScreen(P3D, 1);',
  'default': 'size(750, 750, P3D);',
  'instagram': 'size(810, 1440, P3D);'
};
export const CODE_SETUP_PATTERN = /void setupSketch\(\) {([\s\S]+)} \/\*\-\-SETUP\-\-\*\//g;
export const CODE_UPDATE_PATTERN = /void updateSketch\(\) {([\s\S]+)} \/\*\-\-UPDATE\-\-\*\//g;
export const CODE_DRAW_PATTERN = /void drawSketch\(\) {([\s\S]+)} \/\*\-\-DRAW\-\-\*\//g;
export const CODE_KEY_PATTERN = /void keyPressed\(\) {([\s\S]+)} \/\*\-\-KEY\-\-\*\//g;
export const TEMPLATE_PATTERN = /%([A-Z]\w+(\|[\S])|())\w+%/g;
