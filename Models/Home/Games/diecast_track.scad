//
//    Parametric Hot Diecast Track Parts
// Models/Home/Games/diecast_track.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.1.0    2026-11-01    New Curve implementation
//      v1.0.0    2026-10-28    Release version
//      v0.9.0    2026-10-27    Add fillets to all track types
//      v0.8.0    2026-10-26    Add Curve trackType
//      v0.5.0    2026-10-12    Add Connector part
//      v0.1.0    2026-10-12    Add Straight trackType
//      v0.0.1    2025-04-20    Initial version, configurable length glueable track
//

/* [Track Settings] */
// Which type of track to render
trackType = 0; // [0:Straight, 1:Curve, 2:Connector]
// Length of track in mm (only used for Straight track)
length = 200;
// Angle of curve to render in degrees (only used for Curve track)
angle = 90;
// Radius of curve to render in mm (only used for Curve track)
radius = 180;

/* [Advanced Settings] */
// Fillet radius for track in mm
filletRadius = 0.5;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;
include <BOSL2/std.scad>;
include <BOSL2/skin.scad>;


diecast_track(
  trackType=trackType,
  length=length,
  angle=angle,
  radius=radius,
  filletRadius=filletRadius
);


module diecast_track(trackType=0, length=200, angle=60, radius=160, filletRadius=0.5) {
  _fullTrack = [ [0,0],[40,0],[40,15],[37.5,15],[37.5,5],[2.5,5],[2.5,15],[0,15] ];
  _cutoutTrack = [ [0,0],[10,0],[10,1],[7.2,1],[7.2,3.2],[33.4,3.2],[33.4,1],[30,1],[30,0],[40,0],[40,15],[37.5,15],[37.5,5],[2.5,5],[2.5,15],[0,15] ];
  _cutoutNegative = [ [10,-1],[10,1],[7.2,1],[7.2,3.2],[33.4,3.2],[33.4,1],[30,1],[30,-1] ];

  module _connectorPiece(length=35) {
    difference() {
      R(90)Tz(-length)linear_extrude(length) union() {
        offset(r=filletRadius) { offset(delta=-filletRadius) { polygon(_cutoutTrack); }}
        intersection() {
          polygon(_cutoutTrack);
          T(filletRadius,-0.5)square([(40-(2*filletRadius)), 4]);
        }
      }
      T(20,15.5)cylinder(h=20, d=5);
      T(20)cylinder(h=20,d=14);
    }
  }
  module _connectorNegative(length=35) {
    union() {
      R(90)Tz(-length)linear_extrude(length+0.1) polygon(_cutoutNegative);
      T(20,15.5,-1)cylinder(h=20, d=5);
      T(20,0,-1)cylinder(h=20,d=14);
    }
  }
  module _straight(length=200) {
    assert(length > 70, "Length needs to be greater than 70mm to account for connector cutouts.");
    union() {
      _connectorPiece(length=35.1);
      T(0,(length-35))R(90)linear_extrude(length-70) offset(r=filletRadius) { offset(delta=-filletRadius) { polygon(_fullTrack); }}
      T(0,length)mirror([1,0,0])R(0,0,180)_connectorPiece(length=35.1);
    }
  }
  module _curve(angle=60, radius=165) {
    //using angle for steps makes for a nice enough rendering. For connector pieces, angle needs to be at least 30 degrees...
    assert(angle>=30, "For connector pieces, the angle of the curve needs to be at least 30 degrees.");
    pathForSweep = arc(n=angle, r=radius, angle=angle);
    orig_rgn = [_fullTrack];
    min_rgn = offset(orig_rgn, delta=-filletRadius, closed=true);
    rgn = offset(min_rgn, r=filletRadius, closed=true);

    difference() {
      path_sweep(rgn, pathForSweep);
      T(radius-40)_connectorNegative();
      R(0,0,angle)T(radius-40)mirror([0,1,0])_connectorNegative();
    }
  }
  module _connector() {
    module __outline() {
      polygon([ [7,0],[59,0],[66,4],[66,22],[59,26],[7,26],[0,22],[0,4] ]);
    }
    module __cutout() {
      union() {
        hull() {
          T(11,6.4)circle(d=5.9);
          T(23,4.6)square([0.001,2.6]);
        }
        polygon([ [23,4.6],[23,7.2],[33,6.2],[33,4.6] ]);
        polygon([ [33,6.2],[43,7.2],[43,4.6],[33,4.6] ]);
        hull() {
          T((43-0.001),4.6)square([0.001,2.6]);
          T(55,6.4)circle(d=5.9);
        }
      }
    }
    module __slantPost() {
      difference() {
        cylinder(h=1.6,d=4.4);
        T(2.2)R(0,-45)T(0,-5)cube(10);
      }
    }

    union() {
      difference() {
        linear_extrude(1.6)__outline();
        //bottom cutout
        Tz(-1)linear_extrude(10)__cutout();
        //top cutout
        T(66,26,-1)R(0,0,180)linear_extrude(10)__cutout();
      }
      T(16.95,13,1.6)R(0,0,180)__slantPost();
      T(48.45,13,1.6)__slantPost();
      T(33,13,1.6)cylinder(h=1.6,d=13.5);
    }
  }

  if(trackType == 0) { _straight(length); }
  if(trackType == 1) { _curve(angle=angle, radius=radius); }
  if(trackType == 2) { _connector(); }
}