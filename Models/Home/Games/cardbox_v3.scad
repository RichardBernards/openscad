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

/* [Box Type] */
// Which type of box to render. Make sure to go over the settings on the bottom concerning the selected box type
boxType = 0; // [0:Cardbox, 1:Flipbox]

/* [Box Dimensions] */
// Inner width dimension of assembled box in mm.
insideWidth = 66; // [52:200]
// Inner height dimension of assembled box in mm.
insideHeight = 91; // [50:200]
// Inner depth dimension of assembled box in mm.
insideDepth = 20; // [20:100]
// Thickness for walls of box in mm
wallThickness = 3.6;
// Radius of hinge hole in mm (enlarge if filament doesn't fit or has to much friction)
hingeRadius = 1.1;

/* [Text] */
// How to render text
textRendering = 1; // [0:No text, 1:Debossing, 2:Embossing]
// Indenting depth for texts in mm
debossingDepth = 0.4;
// Embossing height for texts in mm
embossingHeight = 0.4;

// Text printed on the front of the box, leave empty for none.
frontText = "Regular";
// Font size for the text on the front
fontSizeFront = 10;

// Text printed on the side of the box, leave empty for none.
sideText = "Regular";
// Font size for the text on the side
fontSizeSide = 10;

// Text printed on the top of the box, leave empty for none.
topText = "Regular";
// Font size for the text on the top
fontSizeTop = 10;

/* [Regular Box] */
// Height dimension of the lid (indirectly determines height of hinge) in mm
lidHeight = 16; // [10:40]

/* [Flip Box] */
// Override wallthickness with following value (in mm)
wallOverride = 2.4;
// Fillet radius in mm (keep fillet radius well below wall thickness for good results)
fillet = 1.6;
// Clearance for the two halves of the flipbox in mm
clearance = 0.5;
// Whether to have a slanted outside half of the box or not
slantedOutside = false;

/* [Dividers] */
// Thickness for the dividers in mm
dividerThickness = 0.6;
// If values are above 0, these are used to render a divider using the value as an offset in mm
dividerOffsets = [0,0];

/* [Advanced Settings] */
slantAngle = 23;
filletR = 1.6;
fontString = "Agency FB:style=Bold";




/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;


/*
          TODO:
    [ ] Add flipbox type
    [ ] Add text thingies
    [ ] Roundover on lid hingeparts for cardbox
    [ ] Add divider functionality

*/



cardbox(
  type=boxType,
  dims=[insideWidth,insideDepth,insideHeight],
  lidH=lidHeight,
  wall=(boxType == 1 ? wallOverride : wallThickness),
  fillet=(boxType == 1 ? fillet : filletR),
  hingeD=(2*hingeRadius),
);



module cardbox(type=0, dims=[66,20,91], lidH=16, wall=3.6, fillet=1.6, hingeL=20, hingeD=2.2) {
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
        Tz(wall)Box(x=dims[0], y=dims[1], z=dims[2], c=fillet, s=fillet);
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
        T(-((0.5*dims[0])+(2*wall)),((0.5*dims[1])+(0.5*wall)),(dims[2]+(2.5*wall)-lidH))R(0,90,0)cylinder(d=hingeD, h=(dims[0]+(4*wall)));//filament hole
        T(-((0.5*claspW)+0.2),-((0.5*dims[1])+0.001),(dims[2]+(2*wall)-lidH-(dims[1]*tan(lidAngle))))R(90,0,90)linear_extrude(claspW+0.4) offset(delta=0.1)__claspBP(); //clasp
      }
      Tz(dims[2]+(2*wall)-lidH-(dims[1]*tan(lidAngle)))__lidNegative();
    }
  }
  module _flipBox() {
    
  }

  if(type == 0) { _cardBox(); }
  if(type == 1) { _flipBox(); }
}
