//
//    Simple cable clamp
// Models/Tools/Consumables/cableclamp.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Usage]
//      use <cableclamp.scad>
//      cableclamp(length=20);
//
//  [Parameters] (parameter name is optional)
//      shD       Screw head diameter (in mm)
//      sD        Screw diameter (in mm) add clearance when needed
//      cD        Cable diameter (in mm)
//      width     Width of clamp (in mm)
//      thick     Least amount of 'meat' in clamp (in mm)
//
//  [Example]
//      cableclamp();
//      cableclamp(9,4.2,8,14,2);
//      cableclamp(shD=9, sD=4.2, cD=8, width=14, thick=2);
//
//  [Version history]
//      v1.0.0    2025-08-20    Initial version
//


// Screw head diameter (in mm)
shD = 9;
// Screw diameter (in mm) add clearance when needed
sD = 4.2;
// Cable diameter (in mm)
cD = 8;

// Width of clamp (in mm)
width = 14;
// Least amount of 'meat' in clamp (in mm)
thick = 2;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

cableclamp(
  shD = shD,
  sD = sD,
  cD = cD,
  width = width,
  thick = thick
);

module cableclamp(
  shD = 9,
  sD = 4.2,
  cD = 8,
  width = 14,
  thick = 2
) {
  depth = ((thick + cD + thick + sD + thick) + (0.4*width));
  height = (cD+thick);

  module _blueprint() {
    union() {
      circle(d=width);
      translate([0,-(0.5*width)]) square([(depth-width),width]);
      translate([(depth-width),0]) circle(d=width);
    }
  }
  module _screwHole(meat=2, length=30) {
    rotate_extrude() polygon([
      [0,0],
      [(0.5*sD),0],
      [(0.5*sD),meat],
      [(0.5*shD),(meat+(0.5*(shD-sD)))],
      [(0.5*shD),(length-1.6)],
      [((0.5*shD)+1.6),length],
      [0,length]
    ]);
  }
  module _screwHoleOld(meat=2,length=30) {
    union() {
      cylinder(d=sD,h=(meat+0.1));
      translate([0,0,meat]) cylinder(d=shD,h=(length-meat));
    }
  }
  module _cableHole(length=20) {
    linear_extrude(length) union() {
      translate([0,(0.5*cD)]) circle(d=cD);
      translate([-(0.5*cD),-(0.1*cD)]) square([cD,(0.6*cD)]);
    }
  }

  difference() {
    linear_extrude(height) _blueprint();
    translate([((depth-width)+((0.5*(width-shD))-thick)),0,-1]) _screwHole(((1.5*thick)+1), (height+2));
    translate([0,((0.5*width)+1),0]) rotate([90,0,0]) _cableHole(width+2);
  }
}