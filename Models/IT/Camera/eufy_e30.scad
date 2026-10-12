//
//    Eufy E30 Camera Mount
// Models/IT/Camera/eufy_e30_mount.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2026-10-12    Release version
//


/* [Dimensions] */
// Height of the mount in mm
height = 9;
// Fillet radius for the mount in mm
fillet = 0.8;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;


eufy_e30_mount(height=height, fillet=fillet);


module eufy_e30_mount(height=9, fillet=0.8) {
  diameter = 50;

  screwDiameter = 7;
  insertDiameter = 4.1;
  insertOffset = 2;
  nutRadius = 6.48;
  nutOffset = 0.6;
  nutHeight = 5.9;

  module _screwHole() {
    rotate_extrude() polygon([
      [0, -1],
      [((0.5*screwDiameter)+1+fillet), -1],
      [(0.5*screwDiameter), fillet],
      [(0.5*screwDiameter), (height-fillet)],
      [((0.5*screwDiameter)+1+fillet), (height+1)],
      [0, (height+1)],
    ]);
  }
  module _insertHole() {
    rotate_extrude() polygon([
      [0, insertOffset],
      [(0.5*insertDiameter), insertOffset],
      [(0.5*insertDiameter), (height-fillet)],
      [((0.5*insertDiameter)+1+fillet), (height+1)],
      [0, (height+1)],
    ]);
  }

  difference() {
    Pille(l=height,d=diameter,rad=fillet,center=false);
    _screwHole();
    //remove nut
    Tz(nutOffset) linear_extrude(nutHeight) circle(r=nutRadius, $fn=6);
    //remove inserts
    T(-12)_insertHole();
    T(12)_insertHole();
  }
}