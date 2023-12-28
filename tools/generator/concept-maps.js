/*
  Different Areas for Random Generation:

  Colors
  Background Landscape Scenery
  Sky Decorations
  Celestial Bodies
  Foreground Focal Point
  Repeating Objects In Foreground
  Motion
    - Slowly Forward
*/

const sharedValues = `
#dist
-300
-200
-100
0
100
200
300
`

const foregroundFocalPoint = `
#prefabs
[water_walkway]

#water_walkway
[water_walkwayA]+[water_walkwayB]+[water_walkwayC]

#water_walkwayA
Flatbox|x:[dist];xr:90;y:200;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:"random 100";w:150.0;h:150.0;l:110.0;s:100.0;fillColor:0;i:30;

#water_walkwayB
Rectangle|xr:90;y:215;yMod:80.0;yModType:"sine";w:15500.0;h:17100.0;fillColor:0;

#water_walkwayC
Arc|xr:90;y:191;z:300;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;fillColor:0;

`+sharedValues;

module.exports = {
  foregroundFocalPoint
}