//
//    Eufy S350 Camera Mount
// Models/IT/Camera/eufy_s350_mount.scad (https://github.com/RichardBernards/openscad/)
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


eufy_s350_mount(height=height, fillet=fillet);


module eufy_s350_mount(height=9, fillet=0.8) {
  diameter = 63;
  pinRadius = 2.75;
  pinHeight = 3.8;
  pinLength = 8;
  pinChamfer = 0.7;
  pinSlotWidth = 1.7;
  pinSlotOffset = 2.4;
  pinYoffset = 29; //26.6 in accordance with other model
  pinXoffset = 6.5;

  screwDiameter = 7;
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
  module _mountPin() {
    T(0,-4)difference() {
      hull() {
        T(0,((0.5*pinLength)-pinRadius))rotate_extrude() polygon([ [0,0],[pinRadius,0],[pinRadius,(pinHeight-pinChamfer)],[(pinRadius-pinChamfer),pinHeight],[0,pinHeight] ]);
        T(0,-((0.5*pinLength)-pinRadius))rotate_extrude() polygon([ [0,0],[pinRadius,0],[pinRadius,(pinHeight-pinChamfer)],[(pinRadius-pinChamfer),pinHeight],[0,pinHeight] ]);
      }
      T((0.5*pinSlotWidth),-((0.5*pinLength)+pinSlotOffset),-0.1)cube([5,pinLength,(pinSlotOffset+0.1)]);
      T(-(5+(0.5*pinSlotWidth)),-((0.5*pinLength)+pinSlotOffset),-0.1)cube([5,pinLength,(pinSlotOffset+0.1)]);
    }
  }

  difference() {
    union() {
      Pille(l=height,d=diameter,rad=fillet,center=false);
      T(((0.5*diameter)-pinXoffset-pinRadius),((0.5*diameter)-pinYoffset),height)_mountPin();
      T(-((0.5*diameter)-pinXoffset-pinRadius),((0.5*diameter)-pinYoffset),height)_mountPin();
    }
    _screwHole();
    translate([0,0,nutOffset]) linear_extrude(nutHeight) circle(r=nutRadius, $fn=6);
  }
}