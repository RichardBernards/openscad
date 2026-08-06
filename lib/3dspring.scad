//
//    3D printable spring
// Lib/3dspring.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2026-08-06    Release version
//

// Width of spring in mm
springW=30;
// Thickness of spring in mm
springT=5;
// Outer diameter of single loop in mm
springOD=10;
// Thickness of loops in mm
springTh=2;
// Number of loops in spring
loops=8;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

// N.B.: Length of uncompressed string is ( (loops*springOD) - ((loops-1)*springTh) )

spring(springW=springW, springT=springT, springOD=springOD, springTh=springTh, loops=loops);

module spring(springW=30,springT=5,springOD=10,springTh=2,loops=8) {
  sWidth = (springW-springOD);
  springOR = (0.5*springOD);
  springIR = (springOR-springTh);

  module _springLoop(sOR=5,sW=20,sIR=3) {
    difference() {
      hull() {
        circle(r=sOR);
        translate([sW,0,0])
        circle(r=sOR);
      }
      hull() {
        circle(r=sIR);
        translate([sW,0,0])
        circle(r=sIR);
      }
    }
  }

  translate([-(0.5*sWidth),springOR,0]) linear_extrude(height=springT, center=false) union() {
    for (i=[0:(loops-1)]) {
      translate([0,(springOD-springTh)*i,0])
      difference() {
        _springLoop(sOR=springOR, sW=sWidth, sIR=springIR);
        translate([-springOR+(sWidth+springOD)*(i%2),0,0]) square(springOD, center=true);
      }
    }
  }
}
    
