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

const foregroundObjects = `
#prefabs
[walkway]
[walkway]+[poles]
[poles]

#walkway
Flatbox|x:[dist];xr:90;y:200;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:150.0;l:110.0;s:100.0;fillColor:0;i:30;
Flatbox|xr:90;y:150;z:645;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:150.0;l:110.0;s:100.0;i:30;
Flatbox|xr:90;y:150;z:645;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:[walkway_h].0;l:110.0;s:100.0;i:30;

#poles
[base_pole]+[pole_tip]

#base_pole
Flatbox|x:[pole_x*pole_a];xr:90;y:200;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h].0;l:1110.0;s:100.0;i:105;fillColor:0;

#pole_tip
Flatbox|x:[pole_x*pole_a];xr:90;y:-415;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h].0;l:110.0;s:100.0;i:105;fillColor:0;

#pole_h
50
100
150
200
250
300

#pole_x
-400
150
-200
500

#walkway_h
150
100
50

`+sharedValues;

const surroundingObjects = `
#prefabs
[water_waves]
[water]

#water_waves
[water]+[waves]
[waves]

#water
Rectangle|xr:90;y:215;yMod:80.0;yModType:sine;w:15500.0;h:17100.0;fillColor:0;

#waves
Arc|xr:90;y:191;z:500;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;zMod:200;zModType:sawtooth;fillColor:0;
Arc|xr:90;y:191;yIter:-2.0;z:900;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;

`+sharedValues;

const backgroundObjects = `
#prefabs
[background]

#background
[horizon]+[city]
[horizon]+[mountain_split]+[pillars]
[horizon]+[mountain_split]+[city]

#city
Flatbox|xIter:12600.0;xIterFunc:sin(x);xr:90;y:-5000;yIter:400.0;yIterFunc:random 100;z:-46000;zIter:200.0;zr:45;w:600.0;h:600.0;l:10000.0;lIter:-800.0;lIterFunc:random 100;s:100.0;fillColor:-16777216;i:51;zrIter:10;

#pillars
Flatbox|xr:90;y:-2000;z:-30000;zr:45;w:1000.0;h:1000.0;l:4000.0;s:100.0;fillColor:-16777216;

#horizon
Rectangle|y:20000;z:-30000;w:200000.0;h:40000.0;fillColor:-16777216;

#mountain_split
[left_mountain]+[right_mountain]

#left_mountain
Rectangle|y:20000;z:-40991;zr:[left_mountain_rotation];w:200000.0;h:40000.0;fillColor:-16777216;

#right_mountain
Rectangle|y:20000;z:-39967;zr:[right_mountain_rotation];w:200000.0;h:40000.0;fillColor:-16777216;

#left_mountain_rotation
8
12
16
22
26
30
34
38
42

#right_mountain_rotation
-50
-45
-40
-35
-30
-25
-20
-15
-10
-5

`+sharedValues;

const conceptMaps = [
  foregroundObjects,
  surroundingObjects,
  backgroundObjects
]

module.exports = { conceptMaps };
