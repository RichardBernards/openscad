//
//    Storage organiser for watch dial boxes
// Models/Home/Storage/dialbox_organiser.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Usage]
//      use <dialbox_organiser.scad>
//      dialbox_organiser(diameter=52, height=13);
//
//  [Parameters] (parameter name is optional)
//      diameter  Diameter of watchdial box (in mm)
//      height    Height of watchdial box (in mm)
//
//  [Example]
//      dialbox_organiser();
//      dialbox_organiser(52,13);
//      dialbox_organiser(diameter=52, height=13);
//
//  [Version history]
//      v1.0.0    2026-06-15    Initial version
//




/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;

dialbox_organiser();

module dialbox_organiser(diameter = 52.4, height = 13) {
  module _dialBox() {
    Tz(0.5*diameter)rotate([90,0,0]) Pille(l=height,d=diameter,rad=1);
  }
  module cp(l=1){module _p(){hull(){linear_extrude(0.01) polygon([[0,0],[l,0],[0.5*l,l]]);translate([0.5*l,0,l]) cube(0.01);translate([0.5*l,l,-l]) cube(0.01);}}union(){_p();translate([0.6*l,l,0]) mirror([0,1,0])_p();}}
  difference() {
    Box(x=(diameter+4), y=((4*height)+(3*2)+4), z=((0.5*diameter)+2));

    Tz(2)union() {
      T(0,-((1.5*height)+3))_dialBox();
      T(0,-((0.5*height)+1))_dialBox();
      T(0,((0.5*height)+1))_dialBox();
      T(0,((1.5*height)+3))_dialBox();
    }

    T(((0.5*diameter)-2),0,4)cp();
  }
}