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

#skip
Rectangle_skip|z:10000;
`

const backgroundObjects = `
#prefabs
[horizon]&[mountains]
[horizon]&[mountains]&[city]
[horizon]&[valley]
[horizon]&[city]
[horizon]&[valley]&[city]
[horizon]&[trees]
[horizon]&[trees]&[city]
[horizon]&[trees]&[mountains]

#city
Flatbox_city|xIter:12600.0;xIterFunc:sin(x);xr:90;y:-5000;yIter:400.0;yIterFunc:random 100;z:-46000;zIter:200.0;zr:45;w:600.0;h:600.0;l:10000.0;lIter:-800.0;lIterFunc:random 100;s:100.0;fillColor:-16777216;i:51;zrIter:10;

#horizon
Rectangle_horizon_accentafill|y:40000;z:-65000;w:200000.0;h:80000.0;fillColor:[black];
Rectangle_horizon_nostroke_accentafill|y:40000;z:-65000;w:200000.0;h:80000.0;fillColor:[black];

#valley
[left_valley_f]&[right_valley_b]
[left_valley_b]&[right_valley_f]
[left_valley_f]
[right_valley_f]
#left_valley_f
Triangle_leftvalley_accentbfill|x:-[left_valley_growth*a];z:-70000;w:150000.0+[left_valley_growth*a]+[valley_w];h:25000.0+[left_valley_growth];s:100.0;variation:left-right;
Triangle_leftvalley_accentbfill|x:[left_valley_growth*a];z:-70000;w:150000.0+[left_valley_growth*a]*2+[valley_w];h:25000.0+[left_valley_growth];s:100.0;variation:left-right;
#right_valley_b
Triangle_rightvalley_accentcfill|x:-[right_valley_growth*b];z:-72000;w:-150000.0-[right_valley_growth*b]*2-[valley_w];h:25000.0+[right_valley_growth*b];s:100.0;variation:left-right;
Triangle_rightvalley_accentcfill|x:[right_valley_growth*b];z:-72000;w:-150000.0-[right_valley_growth*b]-[valley_w];h:25000.0+[right_valley_growth*b];s:100.0;variation:left-right;
#left_valley_b
Triangle_leftvalley_accentbfill|x:-[left_valley_growth*a];z:-72000;w:150000.0+[left_valley_growth*a]+[valley_w];h:25000.0+[left_valley_growth];s:100.0;variation:left-right;
Triangle_leftvalley_accentbfill|x:[left_valley_growth*a];z:-72000;w:150000.0+[left_valley_growth*a]*2+[valley_w];h:25000.0+[left_valley_growth];s:100.0;variation:left-right;
#right_valley_f
Triangle_rightvalley_accentcfill|x:-[right_valley_growth*b];z:-70000;w:-150000.0-[right_valley_growth*b]*2-[valley_w];h:25000.0+[right_valley_growth*b];s:100.0;variation:left-right;
Triangle_rightvalley_accentcfill|x:[right_valley_growth*b];z:-70000;w:-150000.0-[right_valley_growth*b]-[valley_w];h:25000.0+[right_valley_growth*b];s:100.0;variation:left-right;
#left_valley_rotation
rand(8, 42)
#right_valley_rotation
rand(-50, -5)
#left_valley_growth
rand(100, 100000, 'offset_a')
#right_valley_growth
rand(100, 100000, 'offset_b')
#valley_w
rand(100, 100000)

#trees
Terrain_trees|z:-6000;zIter:930.0;w:13700.0;wIter:-3195.0;h:100.0;s:60.0;paramA:50.0;paramB:350.0;paramC:50.0;paramCIter:-30.0;paramD:50.0;variation:trees;i:3;
Terrain_trees|y:15;z:-6000;zIter:970.0;w:13700.0;wIter:-3195.0;h:100.0;s:60.0;paramB:610.0;paramCIter:140.0;paramD:135.0;variation:trees;i:3;

#mountains
[mountains_a]
[mountains_a]&[mountains_b]
[mountains_a]&[mountains_b]&[mountains_c]

#mountains_a
Terrain_mountains_accentastroke|y:-300;z:-70000;w:150000.0;h:20000.0;s:10760.0;paramA:[mountains_height];paramB:[mountains_density];paramC:[mountains_phase];
#mountains_b
Terrain_mountains_accentbfill_accentcstroke|y:-300;z:-75000;w:200000.0;h:20000.0;s:10760.0;paramA:2000+[mountains_height];paramB:[mountains_density];paramC:[mountains_phase];
#mountains_c
Terrain_mountains_accentdfill|y:-300;z:-77000;w:250000.0;h:20000.0;s:10760.0;paramA:4000+[mountains_height];paramB:[mountains_density];paramC:[mountains_phase];
#mountains_height
rand(-5000, 3000)
#mountains_density
rand(850, 2050)
rand(300, 500)
#mountains_phase
rand(0, 4000)

`+sharedValues;

const celestialObjects = `
#prefabs
[station]
[planet]
[fleet]
[tesseract]
[nebula]

#planet
[body]
[body]&[shadow]
[body]&[rings]
[body]&[shadow]&[rings]
[skip]

#body
Circle_planetbody|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-100000;w:100.0;h:100.0;s:[planet_s*celestial3];fillColor:[black];
#planet_x
rand(-25000, 25000, 'celestial1')
#planet_y
rand(-35000, -7000, 'celestial2')
#planet_s
rand(5000, 75000, 'celestial3')
#shadow
Circle_planetshadow_nostroke_backgroundfill|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-100000+[shadow_z_offset];w:100.0;h:100.0;s:[planet_s*celestial3]-[shadow_s_offset];
#shadow_z_offset
rand(500, 2000)
#shadow_s_offset
rand(500, 2000)

#rings
[ring]
[ring]&[ring]
[ring]&[ring]&[ring]
[ring]&[ring]&[ring]&[ring]
[ring]&[ring]&[ring]&[ring]&[ring]
#ring
Circle_planetring_nofill|x:[planet_x*celestial1];y:[planet_y*celestial2];z:-100000;w:100.0;h:100.0;s:[planet_s*f3]+[ring_s_offset];xr:[ring_xr*celestial4];yr:[ring_xr*celestial5];zr:[ring_xr*celestial6];
#ring_s_offset
rand(1000, 20000)
#ring_xr
rand(0, 180, 'celestial4')
#ring_yr
rand(0, 180, 'celestial5')
#ring_zr
rand(0, 180, 'celestial6')

#station
[station_base]&[station_ring]&[station_square]
#station_base
Pyramid_station_base_accentbstroke_accentdfill|x:[station_x*a];y:-40000;yIter:[station_dimensions*a]+1000;yr:45+[station_zr*a];z:-85000;zrIter:180.0;w:[station_dimensions*a];h:[station_dimensions*a];l:[station_dimensions*a];s:100.0;i:2;wIter:-[station_dimensions_iter*a];lIter:-[station_dimensions_iter*a];
#station_square
Box_station_square_nofill_accentcstroke|x:[station_x*a];y:-25000;yIter:1600.0;yr:45+[station_zr*a];z:-85000;w:[station_dimensions*a];wIter:-2000.0;h:1100.0;l:[station_dimensions*a];lIter:-2000.0;s:100.0;i:3;
#station_ring
Circle_station_ring_nofill_accentastroke|x:[station_x*a];xIter:200.0;xr:60;y:-31000;yIter:-200.0;yr:[station_ring_yr];z:-85000;w:100.0;h:100.0;s:[station_dimensions*a]*2;sIter:2000;i:3;
#station_x
rand(-45000, 45000, 'x')
#station_dimensions
rand(10000, 20000, 'sd')
#station_dimensions_iter
rand(1000, 2000, 'sdi')
#station_zr
rand(0, 180, 'szr')
#station_ring_yr
rand(-75, 45)

#fleet
[fleet_main]&[fleet_shields]&[fleet_lights]
#fleet_main
Box_fleet_main_accentafill_backgroundstroke|x:0+[fleet_x*a];xIter:-[fleet_xiter*a];xr:[fleet_xr*a];y:-30000+[fleet_y*a];yIter:[fleet_yiter*a];z:-90000;zIter:-[fleet_ziter*a];w:[fleet_w*a];wIter:-4010.0;h:[fleet_h*a];hIter:-10.0;l:5100.0;lIter:-10.0;s:100.0;i:[fleet_i*a];yr:[fleet_yr*a];
#fleet_shields
Box_fleet_shields_nofill_accentbstroke|x:-200+[fleet_x*a];xIter:-[fleet_xiter*a];xr:[fleet_xr*a];y:-29400+[fleet_y*a];yIter:[fleet_yiter*a];z:-90000;zIter:-[fleet_ziter*a];w:[fleet_w*a];wIter:-4010.0;h:[fleet_h*a];hIter:-10.0;l:5100.0;lIter:-10.0;s:100.0;i:[fleet_i*a];yr:[fleet_yr*a];
#fleet_lights
Rectangle_fleet_lights_nostroke_accentcfill|x:1600+[fleet_x*a];xIter:-[fleet_xiter*a];xr:[fleet_xr*a];y:-27000+[fleet_y*a];yIter:[fleet_yiter*a];z:-86000;zIter:-[fleet_ziter*a];w:[fleet_w*a]*0.5;wIter:-4010.0;h:500.0;hIter:-10.0;l:5100.0;lIter:-10.0;s:100.0;i:[fleet_i*a];yr:[fleet_yr*a];
#fleet_i
rand(3, 5, 'i')
#fleet_x
rand(-50000, 50000, 'fx')
#fleet_y
rand(-10000, 2500, 'fy')
#fleet_w
rand(15000, 35500, 'fw')
#fleet_h
rand(1000, 4000, 'fh')
#fleet_l
rand(3000, 7345, 'fyiter')
#fleet_ziter
rand(650, 4000, 'fziter')
#fleet_yiter
[fleet_h*a]
#fleet_xiter
rand(0, 8000, 'fxiter')
#fleet_yr
rand(45, -45, 'fyr')
#fleet_xr
rand(-45, 30, 'fxr')

#tesseract
Box_tesseract_accentdstroke_nofill|x:[tesseract_x];xr:[tesseract_r];y:[tesseract_y];yr:[tesseract_r];z:-90000;zr:[tesseract_r];w:[tesseract_dimensions*a];wIter:-1000.0;wIterFunc:x^2;h:[tesseract_dimensions*a];hIter:-1000.0;hIterFunc:x^2;l:[tesseract_dimensions*a];lIter:-1000.0;lIterFunc:x^2;s:100.0;i:6;
#tesseract_x
rand(-50600, 50600, 'tx')
#tesseract_y
rand(-19800, -30000, 'ty')
#tesseract_dimensions
rand(5000, 20100, 'tdim')
#tesseract_r
rand(-180, 180)

#nebula
CurvedLine_nebula_accentastroke|x:40000;xIter:-607.0;y:-20000;z:-90000;zr:60;w:130100.0;wIter:-350.0;h:100.0;strokeWeight:1.0;paramB:-1250.0;paramBIter:-185.0;paramCIter:-200.0;paramD:7050.0;i:100;
CurvedLine_nebula_accentbstroke|x:40000;xIter:-807.0;y:-20000;z:-90000;zr:150;w:130100.0;wIter:50.0;h:100.0;strokeWeight:1.0;paramB:-1250.0;paramBIter:-185.0;paramCIter:-200.0;paramD:7050.0;i:100;
CurvedLine_nebula_accentcstroke|x:40000;xIter:-807.0;y:-20000;z:-90000;zr:60;zrIter:-1.0;w:390100.0;wIter:-755.0;h:100.0;strokeWeight:1.0;paramB:-1250.0;paramBIter:-1385.0;paramCIter:-200.0;paramD:7050.0;variation:two-point;i:100;
CurvedLine_nebula_accentdstroke|x:-40200;xIter:-607.0;y:-20000;z:-90000;zr:60;zrIter:-1.0;w:390100.0;wIter:1045.0;h:100.0;strokeWeight:5.0;paramB:-1250.0;paramBIter:-2185.0;paramD:7050.0;variation:two-point;i:100;

#artifact
Arc_artifact|y:-30000;z:-90000;w:30100.0;wIter:-1000.0;h:30100.0;hIter:-1000.0;s:100.0;paramAIter:-25.0;paramB:180.0;paramBIter:-25.0;i:5;

`+sharedValues;

// [ship]
const skyObjects = `
#prefabs
[lightbeams]&[trail]
[trail]
[trail]&[trail]
[bigsmoke]
[bigsmoke]&[lightbeams]
[birds]

#ship
[cockpit]&[thruster]&[wings]
#cockpit
Pyramid_ship_cockpit|xr:90;z:-150;w:150.0;h:350.0;l:50.0;s:100.0;
#thruster
Pyramid_ship_thruster|xr:90;w:130.0;h:150.0;l:30.0;s:100.0;
#wings
Flatbox_ship_wings|xr:90;z:20;w:350.0;h:100.0;l:10.0;s:100.0;

#lightbeams
[lightbeam]
[lightbeam]&[lightbeam]
[skip]

#lightbeam
Line_lightbeam_nofill_accentdstroke|x:[lightbeam_x];y:-[lightbeam_y];z:-99999;w:300000.0;h:100.0;zr:[lightbeam_r];
#lightbeam_r
rand(-10, 10)
#lightbeam_x
rand(-20000, 20000)
#lightbeam_y
rand(8000, 30000)

#trail
Arc_trail_nofill_accenta|x:[trail_x];y:-[trail_y];zIter:-200.0;zrIter:25.0;w:[trail_size*a];h:[trail_size*a];s:100.0;paramB:180.0;i:100;
#trail_size
rand(25, 100, 'size')
#trail_x
rand(-3600, 3600)
#trail_y
rand(1750, 3000)

#bigsmoke
Arc_bigsmoke_nofill_accentastroke|x:[trail_x];y:-[trail_y];zIter:-200.0;zrIter:25.0;w:[trail_size*a];h:[trail_size*a];s:100.0;paramB:180.0;i:100;yIter:[bigsmoke_y];yIterFunc:random 100;
#bigsmoke_y
rand(500, 1200)

#birds
CurvedLine_birds_accentastroke|x:[birds_x];xIter:-[birds_xiter];xIterFunc:random 100;xr:90;y:-[birds_y];z:-[birds_z];zIter:-[birds_ziter];w:30.0;h:100.0;paramB:-15.0;paramD:50.0;i:31;
#birds_x
rand(-600, 600)
#birds_y
rand(400, 900)
#birds_z
rand(0, 2000)
#birds_xiter
rand(200, 500)
#birds_ziter
rand(30, 100)
`+sharedValues;

const surroundingObjects = `
#prefabs
[water]&[waves]
[waves]
[water]
[floor]
[skip]

#water
Rectangle_water|xr:90;y:[water_level];yMod:[tide];yModType:sine;z:-20000;w:100000.0;h:60000.0;fillColor:0;
#water_level
rand(150, 220)
#tide
rand(80, 200)
#waves
Arc_waves_nofill|xr:90;y:190;z:700;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;zMod:200;zModType:sawtooth;fillColor:0;
Arc_waves_nofill|xr:90;y:190;z:700;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;fillColor:0;
Arc_waves_nofill|xr:90;y:190;yIter:-2.0;z:900;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;
Arc_waves_nofill|xr:90;y:190;yIter:-2.0;z:900;zr:180;w:100.0;wIter:200.0;h:100.0;hIter:200.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;
Arc_waves_nofill|xr:90;y:91;z:1000;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:400.0;h:100.0;hIter:400.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;
Arc_waves_nofill|xr:90;y:400;yIter:-4.0;z:1001;zMod:200.0;zModType:sawtooth;zr:180;w:100.0;wIter:400.0;h:100.0;hIter:400.0;s:100.0;strokeWeight:1.0;paramB:180.0;i:100;

#floor
Rectangle_floor_accentcfill|xr:90;y:[floor_y];z:-20000;w:100000.0;h:60000.0;fillColor:0;
#floor_y
rand(50, 500)
`+sharedValues;

const foregroundObjects = `
#prefabs
[walkway]
[square_arch]
[poles]
[skip]
[travelling_platforms]
[posts]
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
Flatbox_walkway|xr:90;y:350;yIter:-20.0;yIterFunc:mod 3;zIter:-500.0;w:500.0;h:500.0;l:50.0;s:100.0;i:100;
Flatbox_walkway|xr:90;y:350;yIter:-20.0;yIterFunc:mod 3;z:800;zIter:-500.0;w:500.0;h:500.0;l:50.0;s:100.0;i:100;
#walkway_h
rand(50, 150)

#travelling_platforms
[travelling_platform_base]&[travelling_platform_beams]&[travelling_platform_wall]

#travelling_platform_base
Flatbox_travellingplatforms_accentcfill_accentbstroke|x:1000;xIter:-1000.0;xr:90;y:150;yIterFunc:mod 3;z:1200;zIter:-500.0;w:300.0;h:400.0;l:25.0;s:100.0;i:100;xIterFunc:sqrt(x);
#travelling_platform_beams
Flatbox_travellingplatforms_accentbfill_accentcstroke|x:1000;xIter:-1000.0;xr:90;y:575;yIterFunc:mod 3;z:1200;zIter:-500.0;w:50.0;h:50.0;l:825.0;s:100.0;i:100;xIterFunc:sqrt(x);
#travelling_platform_wall
Flatbox_travellingplatforms_accentcfill_accentdstroke|x:650;xIter:-1000.0;xr:90;y:550;yIterFunc:mod 3;z:1200;zIter:-500.0;w:50.0;h:400.0;l:4225.0;s:100.0;i:100;xIterFunc:sqrt(x);

#poles
[base_pole]&[pole_tip]
#base_pole
Flatbox_basepole_accentafill_accentbstroke|x:[pole_x*a];xr:90;y:200;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:1110.0;s:100.0;i:75;fillColor:0;xIter:[pole_xiter*a];
Flatbox_basepole_accentcfill_accentdstroke|x:[pole_x*a];xr:90;y:200;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:1110.0;s:100.0;i:75;fillColor:0;xIter:[pole_xiter*a];
#pole_tip
Flatbox_poletip_accentbfill_accentastroke|x:[pole_x*a];xr:90;y:-415;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:110.0;s:100.0;i:75;fillColor:0;xIter:[pole_xiter*a];
Flatbox_poletip_accentdfill_accentcstroke|x:[pole_x*a];xr:90;y:-415;z:345;zIter:-[pole_ziter*a];zrIter:65.0;zrIterFunc:random 100;w:-50.0;h:[pole_h];l:110.0;s:100.0;i:75;fillColor:0;xIter:[pole_xiter*a];
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
Flatbox_squarearch_a1_accentdfill_accentastroke|x:-[square_arch_x_offset*a];xr:90;y:100;zIter:-[square_arch_ziter*a];w:50.0;h:[square_arch_a_h*a];l:170.0;s:100.0;fillColor:[black];i:50;z:600;zr:[square_arch_a_zr*a];
#square_arch_a2
Flatbox_squarearch_a2_accentdfill_accentastroke|x:[square_arch_x_offset*a];xr:90;y:100;zIter:-[square_arch_ziter*a];w:50.0;h:[square_arch_a_h*a];l:170.0;s:100.0;fillColor:[black];i:50;z:600;zr:-[square_arch_a_zr*a];
#square_arch_a_h
rand(50, 245, 'a_h')
#square_arch_a_zr
rand(1, 3, 'a_zr')*15
#square_arch_b1
Flatbox_squarearch_b1_accentafill_accentbstroke|x:-[square_arch_x_offset*a];xr:90;y:-55;zIter:-[square_arch_ziter*a];zr:-45;w:25.0;h:35.0;l:145.0;s:100.0;fillColor:[black];i:50;z:600;
#square_arch_b2
Flatbox_squarearch_b2_accentafill_accentbstroke|x:[square_arch_x_offset*a];xr:90;y:-55;zIter:-[square_arch_ziter*a];zr:45;w:25.0;h:35.0;l:145.0;s:100.0;fillColor:[black];i:50;z:600;
#square_arch_c1
Flatbox_squarearch_c1_accentbfill_accentcstroke|x:[square_arch_x_offset*a];xr:90;y:-225;zIter:-[square_arch_ziter*a];w:25.0;h:10.0;l:195.0;s:100.0;fillColor:[black];i:50;z:600;
#square_arch_c2
Flatbox_squarearch_c2_accentbfill_accentcstroke|x:-[square_arch_x_offset*a];xr:90;y:-225;zIter:-[square_arch_ziter*a];w:25.0;h:10.0;l:195.0;s:100.0;fillColor:[black];i:50;z:600;
#square_arch_top
Flatbox_squarearch_top_accentcfill_accentdstroke|y:-340;yr:90;zIter:-[square_arch_ziter*a];w:[square_arch_top_w];h:25.0;l:425.0+[square_arch_x_offset*a];s:100.0;fillColor:[black];i:50;z:600;
#square_arch_top_w
rand(40, 240)
rand(15, 25)
#square_arch_x_offset
rand(195, 400, 'x_offset')
#square_arch_ziter
rand(300, 600, 'ziter')

#posts
[posts_left]&[posts_right]
#posts_left
[post_base_left]&[post_middle_left]&[post_extra_a_left]&[post_extra_b_left]
#posts_right
[post_base_right]&[post_middle_right]&[post_extra_a_right]&[post_extra_b_right]
#post_base_left
Flatbox_post_base_accentcfill_accentdstroke|x:-[post_x*a];xr:90;y:100-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:-45;w:[post_w*a];h:50.0;l:[post_l*a];s:100.0;fillColor:-16777216;i:30;
#post_middle_left
Flatbox_post_middle_accentbfill_accentcstroke|x:-[post_x*a];xr:90;y:-100-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:-45;w:25.0;h:25.0;l:150.0;s:100.0;fillColor:-16777216;i:30;
#post_extra_a_left
Box_post_extra_a_nofill_accentastroke|x:-[post_x*a];xr:90;y:-100-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:-45;w:[post_box_dimensions_a*a];h:[post_box_dimensions_a*a];l:100.0+([post_l*a]/2);s:100.0;i:30;
#post_extra_b_left
Box_post_extra_b_nofill_backgroundstroke|x:-[post_x*a];xr:90;y:-75-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:-45;w:[post_box_dimensions_b*a];h:[post_box_dimensions_b*a];l:35.0;s:100.0;i:30;
#post_base_right
Flatbox_post_base_accentcfill_accentdstroke|x:[post_x*a];xr:90;y:100-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:45;w:[post_w*a];h:50.0;l:[post_l];s:100.0;fillColor:-16777216;i:30;
#post_middle_right
Flatbox_post_middle_accentbfill_accentcstroke|x:[post_x*a];xr:90;y:-100-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:45;w:25.0;h:25.0;l:150.0;s:100.0;fillColor:-16777216;i:30;
#post_extra_a_right
Box_post_extra_a_nofill_accentastroke|x:[post_x*a];xr:90;y:-100-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:45;w:[post_box_dimensions_a*a];h:[post_box_dimensions_a*a];l:100.0+([post_l*a]/2);s:100.0;i:30;
#post_extra_b_right
Box_post_extra_b_nofill_backgroundstroke|x:[post_x*a];xr:90;y:-75-([post_l*a]/2);z:500;zIter:-[post_ziter*a];zr:45;w:[post_box_dimensions_b*a];h:[post_box_dimensions_b*a];l:35.0;s:100.0;i:30;
#post_ziter
rand(500, 2000, 'ziter')
#post_box_dimensions_a
rand(75, 80, 'dima')
#post_box_dimensions_b
rand(55, 65, 'dimb')
#post_w
rand(50, 200, 'pw')
#post_l
rand(5, 4000, 'pl')
#post_x
rand(300, 4000, 'px')
`+sharedValues;

const conceptMaps = [
  backgroundObjects,
  celestialObjects,
  skyObjects,
  surroundingObjects,
  foregroundObjects
]

module.exports = { conceptMaps };
