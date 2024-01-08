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
[square_arch]
[poles]
[turnway]

#turnway
[turnway_left]&[turnway_right]
[turnway_stretched_left]&[turnway_stretched_right]
#turnway_left
Flatbox_turnway_left_accentafill_accentbstroke|xIter:-200.0;xr:90;y:250;yIter:-25.0;yIterFunc:random 100;zIter:-200.0;zr:45;w:100.0;h:100.0;l:300.0;s:100.0;i:80;lIter:50.0;lIterFunc:random 100;
#turnway_right
Flatbox_turnway_right_accentafill_accentbstroke|xIter:200.0;xr:90;y:250;yIter:-25.0;yIterFunc:random 100;zIter:-200.0;zr:45;w:100.0;h:100.0;l:300.0;s:100.0;i:80;lIter:50.0;lIterFunc:random 100;
#turnway_stretched_left
Flatbox_turnway_left_accentafill_accentbstroke|xIter:-200.0;xr:90;y:250;zIter:-200.0;zr:45;w:100.0;h:100.0;hIter:[turnway_stretch*a];l:300.0;s:100.0;i:80
#turnway_stretched_right
Flatbox_turnway_right_accentafill_accentbstroke|xIter:200.0;xr:90;y:250;zIter:-200.0;zr:45;w:100.0;wIter:[turnway_stretch*a];h:100.0;l:300.0;s:100.0;i:80
#turnway_stretch
rand(0, 3, 'stretch')*50

#walkway
Flatbox_walkway|x:[dist];xr:90;y:200;z:345;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:150.0;l:110.0;s:100.0;fillColor:0;i:30;
Flatbox_walkway|xr:90;y:150;z:645;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:150.0;l:110.0;s:100.0;i:30;
Flatbox_walkway|xr:90;y:150;z:645;zIter:-295.0;zrIter:65.0;zrIterFunc:random 100;w:150.0;h:[walkway_h];l:110.0;s:100.0;i:30;
#walkway_h
rand(50, 150)

#poles
[base_pole]&[pole_tip]
#base_pole
Flatbox_basepole_accentafill_accentbstroke|x:[pole_x*a];xr:90;y:200;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:1110.0;s:100.0;i:100;fillColor:0;xIter:[pole_xiter*a];
Flatbox_basepole_accentcfill_accentdstroke|x:[pole_x*a];xr:90;y:200;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:1110.0;s:100.0;i:100;fillColor:0;xIter:[pole_xiter*a];
#pole_tip
Flatbox_poletip_accentbfill_accentastroke|x:[pole_x*a];xr:90;y:-415;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:110.0;s:100.0;i:100;fillColor:0;xIter:[pole_xiter*a];
Flatbox_poletip_accentdfill_accentcstroke|x:[pole_x*a];xr:90;y:-415;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:110.0;s:100.0;i:100;fillColor:0;xIter:[pole_xiter*a];
#pole_h
rand(50, 300)
#pole_x
rand(-1000, -300, 'x')
rand(300, 1000, 'x')
#pole_ziter
rand(300, 800, 'ziter')
#pole_xiter
rand(1, 10, 'xiter')*20

#square_arch
[square_arch_a1]&[square_arch_a2]&[square_arch_b1]&[square_arch_b2]&[square_arch_c1]&[square_arch_c2]&[square_arch_top]
#square_arch_a1
Flatbox_squarearch_a1_accentdfill_accentastroke|x:-[square_arch_x_offset*a];xr:90;y:100;zIter:-[square_arch_ziter*a];w:50.0;h:[square_arch_a_h*a];l:170.0;s:100.0;fillColor:[black];i:100;z:600;zr:[square_arch_a_zr*a];
#square_arch_a2
Flatbox_squarearch_a2_accentdfill_accentastroke|x:[square_arch_x_offset*a];xr:90;y:100;zIter:-[square_arch_ziter*a];w:50.0;h:[square_arch_a_h*a];l:170.0;s:100.0;fillColor:[black];i:100;z:600;zr:-[square_arch_a_zr*a];
#square_arch_a_h
rand(50, 245, 'a_h')
#square_arch_a_zr
rand(1, 3, 'a_zr')*15
#square_arch_b1
Flatbox_squarearch_b1_accentafill_accentbstroke|x:-[square_arch_x_offset*a];xr:90;y:-55;zIter:-[square_arch_ziter*a];zr:-45;w:25.0;h:35.0;l:145.0;s:100.0;fillColor:[black];i:100;z:600;
#square_arch_b2
Flatbox_squarearch_b2_accentafill_accentbstroke|x:[square_arch_x_offset*a];xr:90;y:-55;zIter:-[square_arch_ziter*a];zr:45;w:25.0;h:35.0;l:145.0;s:100.0;fillColor:[black];i:100;z:600;
#square_arch_c1
Flatbox_squarearch_c1_accentbfill_accentcstroke|x:[square_arch_x_offset*a];xr:90;y:-225;zIter:-[square_arch_ziter*a];w:25.0;h:10.0;l:195.0;s:100.0;fillColor:[black];i:100;z:600;
#square_arch_c2
Flatbox_squarearch_c2_accentbfill_accentcstroke|x:-[square_arch_x_offset*a];xr:90;y:-225;zIter:-[square_arch_ziter*a];w:25.0;h:10.0;l:195.0;s:100.0;fillColor:[black];i:100;z:600;
#square_arch_top
Flatbox_squarearch_top_accentcfill_accentdstroke|y:-340;yr:90;zIter:-[square_arch_ziter*a];w:[square_arch_top_w];h:25.0;l:425.0+[square_arch_x_offset*a];s:100.0;fillColor:[black];i:100;z:600;
#square_arch_top_w
rand(40, 240)
rand(15, 25)
#square_arch_x_offset
rand(195, 400, 'x_offset')
#square_arch_ziter
rand(300, 600, 'ziter')
`+sharedValues;

const surroundingObjects = `
#prefabs
[water]&[waves]
[waves]
[water]
[floor]

#water
Rectangle_water|xr:90;y:[water_level];yMod:[tide];yModType:sine;z:-20000;w:100000.0;h:60000.0;fillColor:0;
#water_level
rand(150, 220)
#tide
rand(80, 200)
#waves
Arc_waves_nofill|xr:90;y:190;z:500;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;zMod:200;zModType:sawtooth;fillColor:0;
Arc_waves_nofill|xr:90;y:190;z:500;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;fillColor:0;
Arc_waves_nofill|xr:90;y:190;yIter:-2.0;z:900;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;
Arc_waves_nofill|xr:90;y:190;yIter:-2.0;z:900;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;
Arc_waves_nofill|xr:90;y:91;z:1000;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:400.0;h:100.0;hIter:400.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;
Arc_waves_nofill|xr:90;y:400;yIter:-4.0;z:1001;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:400.0;h:100.0;hIter:400.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;

#floor
Rectangle_floor_accentcfill|xr:90;y:[floor_y];z:-20000;w:100000.0;h:60000.0;fillColor:0;
#floor_y
rand(50, 500)
`+sharedValues;

const backgroundObjects = `
#prefabs
[horizon]
[horizon]&[city]
[horizon]&[mountain_split]&[city]
[horizon]&[trees]
[trees]

#city
Flatbox_city|xIter:12600.0;xIterFunc:sin(x);xr:90;y:-5000;yIter:400.0;yIterFunc:random 100;z:-46000;zIter:200.0;zr:45;w:600.0;h:600.0;l:10000.0;lIter:-800.0;lIterFunc:random 100;s:100.0;fillColor:-16777216;i:51;zrIter:10;

#horizon
Rectangle_horizon_accentafill|y:40000;z:-95000;w:200000.0;h:80000.0;fillColor:[black];
Rectangle_horizon_nostroke_accentafill|y:40000;z:-95000;w:200000.0;h:80000.0;fillColor:[black];

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
Terrain_trees|z:-6000;zIter:930.0;w:13700.0;wIter:-3195.0;h:100.0;s:60.0;paramA:50.0;paramB:350.0;paramC:50.0;paramCIter:-30.0;paramD:50.0;variation:trees;i:3;
Terrain_trees|y:15;z:-6000;zIter:970.0;w:13700.0;wIter:-3195.0;h:100.0;s:60.0;paramB:610.0;paramCIter:140.0;paramD:135.0;variation:trees;i:3;
`+sharedValues;

const celestialObjects = `
#prefabs
[planet]

#planet
[body]
[body]&[shadow]
[body]&[rings]
[body]&[shadow]&[rings]
#body
Circle_planetbody|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-50000;w:100.0;h:100.0;s:[planet_s*celestial3];fillColor:[black];
#planet_x
rand(-25000, 25000, 'celestial1')
#planet_y
rand(-20000, -7000, 'celestial2')
#planet_s
rand(5000, 20000, 'celestial3')
#shadow
Circle_planetshadow_nostroke_backgroundfill|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-50000+[shadow_z_offset];w:100.0;h:100.0;s:[planet_s*celestial3]-[shadow_s_offset];
#shadow_z_offset
rand(500, 1000)
#shadow_s_offset
rand(500, 1000)

#rings
[ring]
[ring]&[ring]
[ring]&[ring]&[ring]
[ring]&[ring]&[ring]&[ring]
[ring]&[ring]&[ring]&[ring]&[ring]
#ring
Circle_planetring_nofill|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-50000;w:100.0;h:100.0;s:[planet_s*f3]+[ring_s_offset];xr:[ring_xr*celestial4];yr:[ring_xr*celestial5];zr:[ring_xr*celestial6];
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
