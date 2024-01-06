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
rand(-300, 300)

#black
-16777216
`

const foregroundObjects = `
#prefabs
[walkway]
[walkway]&[poles]
[poles]

#walkway
Flatbox_walkway|x:[dist];xr:90;y:200;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:150.0;l:110.0;s:100.0;fillColor:0;i:30;
Flatbox_walkway|xr:90;y:150;z:645;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:150.0;l:110.0;s:100.0;i:30;
Flatbox_walkway|xr:90;y:150;z:645;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:[walkway_h];l:110.0;s:100.0;i:30;

#poles
[base_pole]&[pole_tip]

#base_pole
Flatbox_basepole|x:[pole_x*foreground1];xr:90;y:200;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:1110.0;s:100.0;i:105;fillColor:0;

#pole_tip
Flatbox_poletip|x:[pole_x*foreground1];xr:90;y:-415;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:110.0;s:100.0;i:105;fillColor:0;

#pole_h
rand(50, 300)

#pole_x
rand(-500, -200, 'foreground1')
rand(200, 500, 'foreground1')

#walkway_h
rand(50, 150)

`+sharedValues;

const surroundingObjects = `
#prefabs
[water_waves]
[water]

#water_waves
[water]&[waves]
[waves]

#water
Rectangle_water|xr:90;y:215;yMod:80.0;yModType:sine;w:15500.0;h:17100.0;fillColor:0;

#waves
Arc_waves|xr:90;y:191;z:500;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;zMod:200;zModType:sawtooth;fillColor:0;
Arc_waves|xr:90;y:191;yIter:-2.0;z:900;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;

`+sharedValues;

const backgroundObjects = `
#prefabs
[background]

#background
[horizon]&[city]
[horizon]&[mountain_split]&[pillars]
[horizon]&[mountain_split]&[city]
[horizon]&[trees]

#city
Flatbox_city|xIter:12600.0;xIterFunc:sin(x);xr:90;y:-5000;yIter:400.0;yIterFunc:random 100;z:-46000;zIter:200.0;zr:45;w:600.0;h:600.0;l:10000.0;lIter:-800.0;lIterFunc:random 100;s:100.0;fillColor:-16777216;i:51;zrIter:10;

#pillars
Flatbox_pillars|xr:90;y:-2000;z:-30000;zr:45;w:1000.0;h:1000.0;l:4000.0;s:100.0;fillColor:[black];

#horizon
Rectangle_horizon|y:20000;z:-30000;w:200000.0;h:40000.0;fillColor:[black];

#mountain_split
[left_mountain]&[right_mountain]

#left_mountain
Rectangle_leftmountain|y:20000;z:-40991;zr:[left_mountain_rotation];w:200000.0;h:40000.0;fillColor:[black];

#right_mountain
Rectangle_rightmountain|y:20000;z:-39967;zr:[right_mountain_rotation];w:200000.0;h:40000.0;fillColor:[black];

#left_mountain_rotation
rand(8, 42)

#right_mountain_rotation
rand(-50, -5)

#trees
Terrain_trees|z:-6000;zIter:930.0;w:13700.0;wIter:-3195.0;h:100.0;s:60.0;strokeColor:-12318166;fillColor:-12318166;paramA:50.0;paramB:350.0;paramC:50.0;paramCIter:-30.0;paramD:50.0;variation:trees;i:3;
Terrain_trees|y:15;z:-6000;zIter:970.0;w:13700.0;wIter:-3195.0;h:100.0;s:60.0;strokeColor:-12318166;fillColor:-12318166;paramB:610.0;paramCIter:140.0;paramD:135.0;variation:trees;i:3;

`+sharedValues;

const celestialObjects = `
#prefabs
[planet]

#planet
[body]&[rings]
[body]&[shadow]&[rings]

#body
Circle_planetbody|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-50000;w:100.0;h:100.0;s:[planet_s*celestial3];fillColor:[black];

#shadow
Circle_planetshadow_nostroke_backgroundfill|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-50000+[shadow_z_offset];w:100.0;h:100.0;s:[planet_s*celestial3]-[shadow_s_offset];

#rings
[ring]
[ring]&[ring]
[ring]&[ring]&[ring]
[ring]&[ring]&[ring]&[ring]
[ring]&[ring]&[ring]&[ring]&[ring]

#ring
Circle_planetring_nofill|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-50000;w:100.0;h:100.0;s:[planet_s*f3]+[ring_s_offset];xr:[ring_xr*celestial4];yr:[ring_xr*celestial5];zr:[ring_xr*celestial6];

#planet_x
rand(-25000, 25000, 'celestial1')

#planet_y
rand(-20000, -7000, 'celestial2')

#planet_s
rand(5000, 20000, 'celestial3')

#shadow_z_offset
rand(500, 1000)

#shadow_s_offset
rand(500, 1000)

#ring_s_offset
rand(1000, 5000)

#ring_xr
rand(0, 180, 'celestial4')

#ring_yr
rand(0, 180, 'celestial5')

#ring_zr
rand(0, 180, 'celestial6')
`+sharedValues;

const conceptMaps = [
  foregroundObjects,
  surroundingObjects,
  backgroundObjects,
  celestialObjects
]

module.exports = { conceptMaps };
