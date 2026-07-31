//
//    Bowden plug
// Models/Tools/Consumables/bowdenplug.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Usage]
//      use <bowdenplug.scad>
//      bowdenplug(length=20);
//
//  [Parameters] (parameter name is optional)
//      length    Additional length on top of plug (in mm)
//
//  [Example]
//      bowdenplug();
//      bowdenplug(20);
//      bowdenplug(length=20);
//
//  [Version history]
//      v1.0.0    2025-08-20    Initial version
//

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

translate([-10,0,0]) bowdenplug();
translate([10,0,0]) bowdenplug(length=13);

module bowdenplug(length=5) {
  module cp(l=1){module _p(){hull(){linear_extrude(0.01) polygon([[0,0],[l,0],[0.5*l,l]]);translate([0.5*l,0,l]) cube(0.01);translate([0.5*l,l,-l]) cube(0.01);}}union(){_p();translate([0.6*l,l,0]) mirror([0,1,0])_p();}}
  difference() {
    rotate_extrude() polygon([
      [1.2,0],
      [2,0],
      [2,15],
      [5,18],
      [5,(18+length-1)],
      [4,(18+length)],
      [0,(18+length)],
      [0,(18+length-2)],
      [1.2,(18+length-3.2)],
    ]);
    translate([-0.5,-0.5,20])cp();
  }
}