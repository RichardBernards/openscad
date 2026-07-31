//
//    DeWalt bitholder for battery powered tools
// Models/Tools/Powertools/dewalt_bitholder.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v3.0.0    2025-11-06    Start new and better customizable version
//

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;


dewalt_bitholder();


module dewalt_bitholder() {
  // Bitholder block width in mm
  bWidth = 50;
  // Bitholder height in mm
  bHeight = 20.5;
  // Clamp outer radius in mm
  cOrad = 5.1;
  // Clamp inner radius in mm
  cIrad = 3.5;
  // Clamping gap (outer reference) in mm
  cGap = 4.9;
  // Individual clamp height in mm
  cHeight = 7.1;
  // Fillet radius in mm
  fil = 0.6;
  bDepth = 6.5;
  bRad = 2;
  bIndentHeight = 11.7;
  bIndentOffset = 4;
  // Clamp offset positions in mm
  clampPositions = [3,14,25,36,47];

  module _bracket() {
    module __bluePrint() {
      offset(r=fil) { offset(delta=-fil) { difference() {
        offset(r=fil) { offset(delta=-fil) { translate([0,-bHeight]) square([bDepth,bHeight]); }}
        offset(r=bRad) { offset(delta=-bRad) { translate([bIndentOffset,-(bIndentHeight + (0.5*(bHeight-bIndentHeight)))]) square([(3*bRad),bIndentHeight]); }}
      }}}
    }
    union() {
      translate([-5,6.4,17.1]) __dewaltClip();
      difference() {
        translate([(0.5*bWidth),0,0]) rotate([-90,0,90]) union() {
          minkowski() {
            translate([0,0,fil]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
            sphere(r=fil);
          }
          translate([0,0,fil]) linear_extrude(bWidth-(2*fil)) __bluePrint();
          minkowski() {
            translate([0,0,(bWidth-1-fil)]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
            sphere(r=fil);
          }
        }
        translate([((0.5*bWidth)-4),2,2]) cp();
        translate([-((0.5*bWidth)-4),2,2]) cp();
        //screwhole
        translate([-5,-0.1,10.25]) rotate([-90,0,0]) cylinder(h=0.9, d=6.4);
        translate([-5,-0.1,10.25]) rotate([-90,0,0]) cylinder(h=5.2, d=3.3);
      }
    }
  }

  module _clamp() {
    module __bluePrint() {
      offset(r=fil) { offset(delta=-fil) {
        difference() {
          circle(r=cOrad);
          circle(r=cIrad);
          polygon([ [0,0], [-(0.5*cGap),-(cOrad+0.01)], [(0.5*cGap),-(cOrad+0.01)] ]);
        }
      }}
    }
    
    union() {
      minkowski() {
        translate([0,0,fil]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
        sphere(r=fil);
      }
      translate([0,0,fil]) linear_extrude(cHeight-(2*fil)) __bluePrint();
      minkowski() {
        translate([0,0,(cHeight-fil-1)]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
        sphere(r=fil);
      }
    }
  }

  module __dewaltClipPart() {
    union() {
      polygon([ [0,0],[6.3,0],[4.96,3.1],[4.19,3.7],[0.8,3.7],[0,2.9] ]);
      translate([4.19,2.9]) circle(r=0.8);
      translate([0.8,2.9]) circle(r=0.8);
    }
  }
  module __dewaltClip() {
    union() {
      translate([2.05,1.8,0]) linear_extrude(1.8) __dewaltClipPart();
      translate([-2.05,1.8,1.8]) rotate([0,180,0]) linear_extrude(1.8) __dewaltClipPart();
      translate([-8.35,0,0]) cube([16.7,1.8,1.8]);
    }
  }
  module cp(l=1){module _p(){hull(){linear_extrude(0.01) polygon([[0,0],[l,0],[0.5*l,l]]);translate([0.5*l,0,l]) cube(0.01);translate([0.5*l,l,-l]) cube(0.01);}}union(){_p();translate([0.6*l,l,0]) mirror([0,1,0])_p();}}



  union() {
    _bracket();
    for(clampOffset = clampPositions) {
      translate([-((0.5*bWidth)-clampOffset),-cIrad,0]) _clamp();
      translate([-((0.5*bWidth)-clampOffset),-cIrad,(bHeight-cHeight)]) _clamp();
    }
  }
}