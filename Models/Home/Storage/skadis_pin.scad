//
//    Cutout for Skadis-t-clips
// Models/Home/Storage/skadis_pin.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Usage]
//      use <skadis_pin.scad>
//      skadis_pin(d=22, l=55);
//
//  [Parameters] (parameter name is optional)
//      d         Pin diameter in mm
//      l         Pin length in mm
//      zOffset   Height positional offset for pin in mm
//      xOffset   X positional offset for pin in mm
//
//  [Example]
//      skadis_pin();
//      skadis_pin(22);
//      skadis_pin(d=10, l=55, zOffset=1, xOffset=2);
//
//  [Version history]
//      v1.0.0    2026-11-14    Initial version
//

/* [Settings] */
// Pin diameter in mm
diameter = 22;
// Pin length in mm
length = 55;
// Height position offset of pin in mm
zOffset = 0;
// X position offset of pin in mm
xOffset = 0;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;
use <ub.scad>;


skadis_pin(d=diameter, l=length, zOffset=zOffset, xOffset=xOffset);


module skadis_pin(d=22, l=55, zOffset=0, xOffset=0) {
  module _tclipcutout(length=0) {
    module _bowl(height=0) {
      union() {
        translate([0,-5.5,0]) rotate([-90,0,0]) rotate_extrude() polygon([
          [0,0],
          [11,0],
          [8,3],
          [0,3]
        ]);
        if(height > 0) {
          translate([0,-5.5,0]) rotate([90,0,0]) cylinder(h=height, r=11);
        }
      }
    }
    module _key(height=2.7) {
      translate([0,(height-2.6),0]) rotate([90,0,0]) linear_extrude(height) union() {
        translate([0,5,0]) circle(d=5.2);
        square([5.2,10], center=true);
        translate([0,-5,0]) circle(d=5.2);
      }
    }

    union() {
      _key();
      _bowl(length);
    }
  }

  union() {
    T(xOffset,zOffset)Pille(l=l, d=d, rad=2, center=false);
    difference() {
      hull() {
        Pille(l=5.5, d=(d>22 ? d : 22), rad=2, center=false);
        T(0,((0.5*(d>22 ? d : 22))+(0.5*22)))Pille(l=5.5, d=22, rad=2, center=false);
      }
      T(0,((0.5*(d>22 ? d : 22))+(0.5*22)))R(-90)_tclipcutout(1);
    }
  }
}