//
//    Qwixx Game Box
// Models/Home/Games/qwixxbox.scad (https://github.com/RichardBernards/openscad/)
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


/* [Scorecard Dimensions] */
// Big Blocks width, depth and height in mm
bigBlock = [106,150,55];
// Regular Blocks width, depth and height in mm
smallBlock = [76,122,31];
/* [Additional settings] */
// Orientation for scorecards in box
orientation = 0; // [0:Horizontal, 1:Vertical]
// Walls in mm
wall = 2.4;
// Fillet radius in mm
fillet = 1.2;
// Finger cutout diameter in mm
fingerD = 14;
// Additional clearance in mm
cl = 0.4;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;


qwixxBox(orientation=orientation, bigBlock=bigBlock, smallBlock=smallBlock, wall=wall, fillet=fillet, fingerD=fingerD, cl=cl);

module qwixxBox(orientation=0, bigBlock=[106,150,54], smallBlock=[76,122,31], wall=2.4, fillet=1.2, fingerD=14, cl=0.4) {
  module _horizontal() {
    fullWidth = (smallBlock[2]+bigBlock[2]+(3*wall)+(4*cl));
    fullDepth = (bigBlock[1]+(2*wall)+(2*cl));
    diffDepth = (fullDepth-(smallBlock[1]+(2*cl))-(3*wall));
    module __case() {
      T(-((0.5*fullWidth)+(0.5*wall)))difference() {
        //shell
        Box(x=fullWidth, y=fullDepth, z=(bigBlock[0]+wall+cl), c=fillet, s=fillet);
        //small blocks
        T(-((0.5*fullWidth)-(0.5*smallBlock[2])-cl-wall),-((0.5*fullDepth)-(0.5*smallBlock[1])-cl-wall),wall)Box(x=(smallBlock[2]+(2*cl)), y=(smallBlock[1]+(2*cl)), z=(bigBlock[0]+(2*wall)+(2*cl)), c=fillet, s=fillet);
        //big blocks
        T(((0.5*fullWidth)-(0.5*bigBlock[2])-cl-wall),0,wall)Box(x=(bigBlock[2]+(2*cl)), y=(bigBlock[1]+(2*cl)), z=(bigBlock[0]+(2*wall)+(2*cl)), c=fillet, s=fillet);
        //additional cutoff
        T(-((0.5*fullWidth)-(0.5*bigBlock[2])-cl-wall),-(0.5*(diffDepth+wall)),(wall+smallBlock[0]))Box(x=(bigBlock[2]+(2*cl)), y=(bigBlock[1]+(2*cl)-diffDepth-wall), z=(bigBlock[0]+(2*wall)+(2*cl)), c=fillet, s=fillet);
        //finger space
        T(-((0.5*fullWidth)-smallBlock[2]-(2*wall)),0,(wall+smallBlock[0]))R(0,90)cylinder(h=(4*wall), d=fingerD, center=true);
        //dice space
        T(-((0.5*fullWidth)-(0.5*smallBlock[2])-cl-wall),((0.5*fullDepth)-(0.5*diffDepth)-wall),wall)Box(x=(smallBlock[2]+(2*cl)), y=diffDepth, z=(bigBlock[0]+(2*wall)+(2*cl)), c=fillet, s=fillet);
      }
    }
    module __lid() {
      T((0.5*fullWidth)+(1.5*wall))difference() {
        //shell
        Box(x=(fullWidth+(2*cl)+(2*wall)), y=(fullDepth+(2*cl)+(2*wall)), z=(bigBlock[0]+(2*wall)+(2*cl)), c=fillet, s=fillet);
        Tz(wall)Box(x=(fullWidth+(2*cl)), y=(fullDepth+(2*cl)), z=(bigBlock[0]+(2*wall)+(2*cl)), c=fillet, s=fillet);
      }
    }

    __case();
    __lid();
  }
  module _vertical() {
    fullWidth = (bigBlock[0]+(2*cl)+(2*wall));
    fullDepth = (bigBlock[1]+(2*cl)+(2*wall));
    module __case() {
      offX = ( (0.5*bigBlock[0])-(0.5*smallBlock[0]) );
      offY = ( (0.5*bigBlock[1])-(0.5*smallBlock[1])-wall );
      T(-((0.5*fullWidth)+(0.5*wall)))difference() {
        //shell
        Box(x=fullWidth, y=fullDepth, z=(bigBlock[2]+smallBlock[2]+(2*cl)+wall), c=fillet, s=fillet);
        //small blocks on bottom
        T(-offX,-offY,wall)Box(x=(smallBlock[0]+(2*cl)), y=(smallBlock[1]+(2*cl)), z=(smallBlock[2]+(2*cl)), c=fillet, s=fillet);
        //dice channels on bottom
        T(0,((0.5*bigBlock[1])-offY+cl),wall)Box(x=(bigBlock[0]+(2*cl)), y=(2*offY), z=(smallBlock[2]+(2*cl)), c=fillet, s=fillet);
        T(((0.5*bigBlock[0])-offX+wall),0,wall)Box(x=((2*offX)-wall), y=(bigBlock[1]+(2*cl)), z=(smallBlock[2]+(2*cl)), c=fillet, s=fillet);
        //big blocks on top
        Tz(wall+smallBlock[2])Box(x=(bigBlock[0]+(2*cl)), y=(bigBlock[1]+(2*cl)), z=(bigBlock[2]+smallBlock[2]+(2*cl)+wall), c=fillet, s=fillet);
        //finger slit along side to pick out books
        T(0,-((0.5*bigBlock[1])-wall),wall)R(90)linear_extrude(4*wall) T(0,(0.5*fingerD))union() {
          circle(d=fingerD);
          T(-(0.5*fingerD))square([fingerD,(bigBlock[2]+smallBlock[2])]);
        }
      }
    }
    module __lid() {
      T((0.5*fullWidth)+(1.5*wall))difference() {
        Box(x=(fullWidth+cl+(2*wall)), y=(fullDepth+cl+(2*wall)), z=(bigBlock[2]+smallBlock[2]+(2*cl)+(3*wall)), c=fillet, s=fillet);
        Tz(wall+1)Box(x=(bigBlock[0]+(3*cl)+(2*wall)), y=(bigBlock[1]+(3*cl)+(2*wall)), z=(bigBlock[2]+smallBlock[2]+(3*cl)+wall+5), c=fillet, s=fillet);
      }
    }

    __case();
    __lid();
  }


  if(orientation == 0) { _horizontal(); }
  if(orientation == 1) { _vertical(); }
}
