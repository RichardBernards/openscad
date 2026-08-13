//
//    Parametric Box for cardgames
// Models/Home/Games/cardbox.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v3.0.0    2026-08-12    Complete refactored version
//      v2.1.0    2025-10-20    Refactored text, add dividers, cleanup for release
//      v2.0.0    2025-10-18    Refactored boxes
//      v1.0.0    2024-11-16    Release version
//

/* [Render Settings] */
// Which type of box to render. Make sure to go over the settings on the bottom concerning the selected box type
boxType = 1; // [0:Cardbox, 1:Flipbox]

/* [Box Dimensions] */
// Inner width dimension of assembled box in mm.
insideWidth = 66; // [52:200]
// Inner height dimension of assembled box in mm.
insideHeight = 91; // [50:200]
// Inner depth dimension of assembled box in mm.
insideDepth = 20; // [20:100]
// Thickness for walls of box in mm (3.6 for cardbox, 2.4 for flipbox)
wallThickness = 3.6;
// Fillet radius in mm (keep fillet radius well below wall thickness for good results)
fillet = 1.6;
// If values are above 0, these are used to render a divider using the value as an offset in mm
dividerOffsets = [10,15];
// Diameter of hinge hole in mm (enlarge if filament doesn't fit or has to much friction)
hingeD = 2.2;

/* [Cardbox Settings] */
// Height dimension of the lid (indirectly determines height of hinge) in mm
lidHeight = 16; // [10:40]

/* [Flipbox Settings] */
// Whether to have a slanted outside half of the box or not
slantedOutside = true;

/* [Advanced Settings] */
fontString = "Agency FB:style=Bold";




/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;


/*
          TODO:
    [x] Add flipbox type
    [x] Add flipbox slant
    [x] Add "stop-bumps" on flipbox
    [x] Roundover on lid hingeparts for cardbox
    [x] Add divider functionality
    [ ] Add text thingies
    [x] filament hole channel in box of flipbox

*/



cardbox(
  type=boxType,
  dims=[insideWidth,insideDepth,insideHeight],
  lidH=lidHeight,
  wall=wallThickness,
  fillet=fillet,
  hingeD=hingeD,
  dividers=dividerOffsets,
  flipSlanted=slantedOutside,
);



module cardbox(type=0, dims=[66,20,91], lidH=16, wall=3.6, fillet=1.6, hingeL=20, hingeD=2.2, dividers=[0,0], flipSlanted=false) {
  diThick = 0.6;
  module _cardBox() {
    claspW=10;
    lidAngle=23;
    hingePartOffset=6;
    module __lidNegative() {
      T(-(0.5*(dims[0]+(4*wall))),-(wall+(0.5*dims[1])))R(90,0,90)linear_extrude(dims[0]+(4*wall)) polygon([[-0.1,0],[wall,0],[(wall+dims[1]),(dims[1]*tan(lidAngle))],[(dims[1]+(2*wall)),( (dims[1]*tan(lidAngle))-(wall*tan(lidAngle)) )],[(dims[1]+(2*wall)+0.1),( (dims[1]*tan(lidAngle))-(wall*tan(lidAngle)) )],[(dims[1]+(2*wall)+0.1),((dims[1]*tan(lidAngle))+(2*lidH))],[-0.1,((dims[1]*tan(lidAngle))+(2*lidH))]]);
    }
    module __claspBP() { polygon([[0,0],[0,-10],[1,-9],[1,3.6],[0.6,4],[-1,4],[-(1+(1.3*tan(45))),(2+(1.3*tan(45)))],[-1,2],[-1,0]]); }
    module __hingeBP(del=true) {
      difference() {
        union() {
          translate([(0.5*wall),(0.5*wall),0]) circle(d=wall);
          polygon([ [0,0],[wall,-(wall*tan(lidAngle))],[wall,(0.5*wall)],[0,(0.5*wall)] ]);
        }
        if(del) {
          T((0.5*wall),(0.5*wall))circle(d=hingeD);
        }
      }
    }
//    !__hingeBP();
    
    // Box
    union() {
      difference() {
        Box(x=(dims[0]+(2*wall)), y=(dims[1]+(2*wall)), z=(dims[2]+(2*wall)), c=fillet, s=fillet);
        difference() {
          Tz(wall)Box(x=dims[0], y=dims[1], z=dims[2], c=fillet, s=fillet);
          for(di=dividers) { if(di > 0) { T(0,-((0.5*dims[1])-di-(0.5*diThick)),((0.5*(dims[2]-lidH))-0.05))cube([(dims[0]+0.2),diThick,(dims[2]-lidH+0.1)], center=true); } }//dividers
        }
        Tz(dims[2]+(2*wall)-lidH-(dims[1]*tan(lidAngle)))__lidNegative();
      }
      T(-(0.5*claspW),-(0.5*dims[1]),(dims[2]+(2*wall)-lidH-(dims[1]*tan(lidAngle))))R(90,0,90)linear_extrude(claspW)__claspBP(); //clasp
      T(-(hingeL+hingePartOffset),(0.5*dims[1]),(dims[2]+(2*wall)-lidH-0.001))R(90,0,90)linear_extrude(hingeL)__hingeBP(); //left hinge part
      T(hingePartOffset,(0.5*dims[1]),(dims[2]+(2*wall)-lidH-0.001))R(90,0,90)linear_extrude(hingeL)__hingeBP(); //right hinge part
    }
    // Lid
    R(0,180)T(0,(dims[1]+(2*wall)+1),-(dims[2]+(2*wall)))intersection() {
      difference() {
        Box(x=(dims[0]+(2*wall)), y=(dims[1]+(2*wall)), z=(dims[2]+(2*wall)), c=fillet, s=fillet);
        Tz(wall)Box(x=dims[0], y=dims[1], z=dims[2], c=fillet, s=fillet);
        T(-(0.5*(dims[0]+(2*wall)+0.2)),(0.5*dims[1]),-lidH)cube([(dims[0]+(2*wall)+0.2),(dims[1]+(2*wall)),(dims[2]+(2*wall))]); //straighten hingepart
        T(-(hingeL+hingePartOffset+0.2),((0.5*dims[1])-0.1),(dims[2]+(2*wall)-lidH-wall))cube([(hingeL+0.4),(2*wall),(2*wall)]); //remove left hinge
        T((hingePartOffset-0.2),((0.5*dims[1])-0.1),(dims[2]+(2*wall)-lidH-wall))cube([(hingeL+0.4),(2*wall),(2*wall)]); //remove right hinge
        T(-((0.5*dims[0])+wall+0.1),((0.5*dims[1])+(0.5*wall)),(dims[2]+(2.5*wall)-lidH))R(0,90)linear_extrude(dims[0]+(2*wall)+0.2)difference() {
          square(wall);
          circle(d=wall);
        }
        //hinge roundover
        T(-((0.5*dims[0])+(2*wall)),((0.5*dims[1])+(0.5*wall)),(dims[2]+(2.5*wall)-lidH))R(0,90,0)cylinder(d=hingeD, h=(dims[0]+(4*wall)));//filament hole
        T(-((0.5*claspW)+0.2),-((0.5*dims[1])+0.001),(dims[2]+(2*wall)-lidH-(dims[1]*tan(lidAngle))))R(90,0,90)linear_extrude(claspW+0.4) offset(delta=0.1)__claspBP(); //clasp
      }
      Tz(dims[2]+(2*wall)-lidH-(dims[1]*tan(lidAngle)))__lidNegative();
    }
  }
  module _flipBox() {
    slantH=20;
    flipClearance=0.5;
    slantOffset=14;
    stops=[[15,9],[15,12]];
    // Box
    union() {
      difference() {
        Box(x=(dims[0]+(2*wall)), y=(dims[1]+(2*wall)), z=(dims[2]+(2*wall)), c=fillet, s=fillet);
        difference() {
          Tz(wall)Box(x=dims[0], y=dims[1], z=dims[2], c=fillet, s=fillet);
          for(di=dividers) { if(di > 0) { T(0,-((0.5*dims[1])-di-(0.5*diThick)),((0.5*(dims[2]-lidH))-0.05))cube([(dims[0]+0.2),diThick,(dims[2]-lidH+0.1)], center=true); } }
          T(-((0.5*dims[0])-wall),0,(2*wall))R(90)union() {//hinge filament channel
            cylinder(d=(hingeD+1.2),h=(dims[1]+0.2),center=true);
            T(-wall)cube([(2*wall),(hingeD+1.2),(dims[1]+0.2)],center=true);
            T(-5,-wall)cube([(hingeD+1.2+10),(2*wall),(dims[1]+0.2)],center=true);
          }
        }
        T(0,((0.5*dims[1])+wall+0.1))R(90)linear_extrude(dims[1]+(2*wall)+0.2)polygon([[-(0.1+(0.5*dims[0])+wall),(dims[2]+(2*wall)-slantH-0.1)],[-((0.5*dims[0])+wall),(dims[2]+(2*wall)-slantH)],[((0.5*dims[0])-(2*wall)),(dims[2]+wall-1)],[(0.5*dims[0]),(dims[2]+wall-1)],[(0.5*dims[0]),(dims[2]+(2*wall)+0.1)],[-(0.1+(0.5*dims[0])+wall),(dims[2]+(2*wall)+0.1)]]);
        T(-((0.5*dims[0])+wall-hingeD),((0.5*dims[1])+wall+0.1),hingeD)R(90)cylinder(d=hingeD,h=(dims[1]+(2*wall)+0.2));//filament hole
      }
      for(st=stops) {//stops
        T(((0.5*dims[0])-wall-st[0]),((0.5*dims[1])+wall),(dims[2]+wall-st[1]))sphere(d=1);
        T(((0.5*dims[0])-wall-st[0]),-((0.5*dims[1])+wall),(dims[2]+wall-st[1]))sphere(d=1);
      }
    }
    // Lid
    T(0,(dims[1]+(3*wall)+flipClearance+1))difference() {
      Box(x=(dims[0]+(2*wall)), y=(dims[1]+(4*wall)+flipClearance), z=(dims[2]+(2*wall)), c=fillet, s=fillet);
      T(-wall,0,wall)Box(x=(dims[0]+(2*wall)), y=(dims[1]+(2*wall)+flipClearance), z=(dims[2]+(2*wall)), c=fillet, s=fillet);
      T(((0.5*dims[0])-hingeD-0.2),((0.5*dims[1])+(2*wall)+(0.5*flipClearance)+0.1),(dims[2]+(2*wall)-hingeD))R(90)cylinder(d=hingeD,h=(dims[1]+(4*wall)+flipClearance+0.2));//filament hole
      if(flipSlanted) {
        T(0,((0.5*dims[1])+(2*wall)+(0.5*flipClearance)+0.1))R(90)linear_extrude(dims[1]+(4*wall)+flipClearance+0.2)polygon([[-((0.5*dims[0])+wall+0.1),(wall+slantOffset)],[-((0.5*dims[0])+wall),(wall+slantOffset)],[((0.5*dims[0])-slantOffset),(dims[2]+(2*wall))],[((0.5*dims[0])-slantOffset),(dims[2]+(2*wall)+0.1)],[-((0.5*dims[0])+wall+0.1),(dims[2]+(2*wall)+0.1)]]);
      }
      for(stop=stops) {//stops
        T(-((0.5*dims[0])-stop[0]),((0.5*dims[1])+wall+flipClearance),(wall+stop[1]))sphere(d=1);
        T(-((0.5*dims[0])-stop[0]),-((0.5*dims[1])+wall+flipClearance),(wall+stop[1]))sphere(d=1);
      }
    }
  }

  if(type == 0) { _cardBox(); }
  if(type == 1) { _flipBox(); }
}