//
//    Headrest car phone holder
// Models/IT/Mobile Phone/Car headrest phone holder/phoneholder.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2025-09-30    Release version
//      v0.0.1    2023-01-10    Initial version
//


/* [Phone Dimensions] */
// Height of phone in mm
phoneHeight = 153;
// Width of phone in mm
phoneWidth = 75;
// Depth (thickness) of phone in mm
phoneDepth = 13.8;
// Clearance in holder around phone in mm
phoneClearance = 0.6;

/* [Headrest Mount] */
// Diameter of headrest support rods in mm
rodDiameter = 15;
// Distance between headrest support rods in mm
rodDistance = 150;
// Clearance for grips around headrest support rods in mm
rodClearance = 0.2;
// Number of degrees to close grip around headrest support rod
gripAngle = 250;

/* [Advanced settings] */
// Wall thickness in mm
wall = 3;
// Phone holder fillet radius in mm
phFilletR = 3;
// Lips of phone holder in mm [left, bottom, right]
phLips = [6,2.4,6];

// Height of frame in mm
frameHeight = 30;
// Depth of frame in mm (distance between headrest mount and phone-holder)
frameDepth = 75;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

rodRadius = (0.5*rodDiameter);
phW = (phoneHeight + (2*phoneClearance));
phD = (phoneDepth + (2*phoneClearance));



union() {
  translate([0,(0.5*frameDepth),0]) headrestMount();
  frame();
  translate([0,-(0.5*frameDepth),0]) phoneHolder();
}

module phoneHolder() {
  translate([-(0.5*phW),-(phD+phFilletR),0]) difference() {
    linear_extrude((0.7*phoneWidth)) minkowski() {
      square([phW,phD]);
      circle(r=phFilletR);
    }
    translate([0,0,wall]) cube([phW,phD,(0.7*phoneWidth)]);
    translate([phLips[0],-(phD-1),(wall+phLips[1])]) cube([((0.5*phW)+1), phD, (0.7*phoneWidth)]);
    translate([(phW-phLips[2]-((0.5*phW)+1)),-(phD-1),(wall+phLips[1])]) cube([((0.5*phW)+1), phD, (0.7*phoneWidth)]);
    for(xs=[0:1:2]){translate([(-20+(xs*20)),-(0.5*phoneDepth),1]) rotate_extrude() polygon([[0,-0.4],[0.4,0],[0,0.4]]);}
  }
}

module frame() {
  strutRotation = atan( ((0.5*rodDistance)-wall) / frameDepth );
  union() {
    frameArc();
    mirror([1,0,0]) frameArc();
    linear_extrude(frameHeight) difference() {
      square([((0.5*rodDistance)-wall),frameDepth], center=true);
      square([((0.5*rodDistance)-(3*wall)), frameDepth], center=true);
    }
    rotate([0,0,strutRotation])frameStrut();
    rotate([0,0,-strutRotation])frameStrut();
  }
}
module frameStrut() {
  linear_extrude(frameHeight) square([wall, ( sqrt( pow(frameDepth,2) + pow(((0.5*rodDistance)-wall),2)) -wall -1 )], center=true);
}
module frameArc() {
  outsideR = (frameDepth);
  
  translate([-(outsideR + (0.25*rodDistance)),0,0]) linear_extrude(frameHeight) difference() {
    circle(r=(outsideR+wall));
    circle(r=outsideR);
    difference() {
      square((3*outsideR), center=true);
      translate([0,-(0.5*frameDepth),0]) square([(2*outsideR),frameDepth]);
    }
  }
}

module headrestMount() {
  braceWidth = (rodDistance-rodDiameter-rodClearance);
  union() {
    translate([-(0.5*rodDistance),0,0]) headrestGrip();
    translate([(0.5*rodDistance),0,0]) mirror([1,0,0]) headrestGrip();
    translate([-(0.5*braceWidth),0,0]) cube([braceWidth, wall, frameHeight]);
  }
}
module headrestGrip() {
  rotate_extrude(angle=gripAngle) polygon([
    [(rodRadius+(0.5*rodClearance)), 0],
    [(rodRadius+(0.5*rodClearance)+wall), 0],
    [(rodRadius+(0.5*rodClearance)+wall), frameHeight],
    [(rodRadius+(0.5*rodClearance)), frameHeight],
  ]);
}