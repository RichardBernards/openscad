//
//    Truss cable clamp
// Models/Tools/Consumables/trussclamp.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2026-05-21    Release version
//      v0.0.1    2026-03-04    Initial version
//


/* [Clamp Settings] */
// Diameter for clamp in mm
trussDiameter = 50;
// Clamping force applied (reduces diameter of the clamp)
clampingForce = 1; // [0:Light, 1:Medium, 2:Strong]
// Thickness of clamp in mm
walls = 3.4;
// Width and depth of cableholder in mm
cableHolder = [46,26];
// Height of clamp in mm
clampHeight = 36;
// Fillet for clamp on all sides in mm
fillet = 0.8;
// Degrees for the opening of the clamp
clampOpening = 90;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;




trussclamp(trussDiameter=trussDiameter, clampingForce=clampingForce, walls=walls, cableHolder=cableHolder, clampHeight=clampHeight, fillet=fillet, clampOpening=clampOpening);

module trussclamp(trussDiameter = 50, clampingForce = 1, walls = 3.4, cableHolder = [46,26], clampHeight = 36, fillet = 0.8, clampOpening = 90) {
  clampingOffsets = [0.5,0.08,0.12];
  trussDia = (trussDiameter - (clampingOffsets[clampingForce] * trussDiameter));

  module _clamp() {
    module __bluePrint() {
      union() {
        circle(d=(trussDia+(2*walls)));
        translate([0,-((0.75*trussDia)-walls)]) scale([1,(cableHolder[1]/cableHolder[0]),1]) { circle(d=(cableHolder[0]+(2*walls))); }
        translate([0,-(0.5*trussDia)]) square([(0.8*trussDia),(6*walls)], center=true);
        
        intersection() {
          circle(d=(trussDia+(4*walls)));
          polygon([
            [0,0],
            [(sin(0.5*clampOpening)*trussDia),(cos(0.5*clampOpening)*trussDia)],
            [-(sin(0.5*clampOpening)*trussDia),(cos(0.5*clampOpening)*trussDia)],
          ]);
        }
      }
    }

    offset(r=fillet) {
      offset(delta=-fillet) {
        difference() {
          __bluePrint();
          offset(delta=-walls) { __bluePrint(); }

          polygon([
            [0,0],
            [(sin(0.5*clampOpening)*trussDia)-(2*walls),(cos(0.5*clampOpening)*trussDia)],
            [-(sin(0.5*clampOpening)*trussDia)+(2*walls),(cos(0.5*clampOpening)*trussDia)],
          ]);
        }
      }
    }
  }
  module _trussPipe() {
    color("green") translate([0,0,(-100+(0.5*clampHeight))]) cylinder(h=200,d=trussDia);
  }

//  %trussPipe();
  minkowski() {
    translate([0,0,fillet]) linear_extrude(clampHeight-(2*fillet)) offset(delta=-fillet) { _clamp(); }
    sphere(r=fillet);
  }
}