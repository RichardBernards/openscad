//
//    DeWalt Battery Holder
// Models/Tools/Powertools/dewalt_batteryholder.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2025-10-14    Release version
//      v0.9.2    2025-09-01    Multiple holders
//      v0.9.1    2025-08-13    Initial version
//


/* [DeWalt Battery Holder] */
// Select holder type
batteryHolderType = 0; // [0:Regular, 1:Minimal, 2:Minimal with lock]
// Number of battery holders next to eachother
batteryCount = 3;
// For multiple battery holders, the width of the battery used... Increasing this will increase the distance between holders (in mm)
usedBatteryWidth = 86;
// Which mounting options needs to be implemented?
mountingType = 2; // [0:None, 1:Screwholes, 2:Skadis T-clip]

/* [Screw Mounting Settings] */
// Screw diameter in mm
screwDiameter = 3;
// Whether or not to countersink the screwholes
screwCountersink = true;

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;


dewalt_batteryholder(batteryHolderType=batteryHolderType, batteryCount=batteryCount, usedBatteryWidth=usedBatteryWidth, mountingType=mountingType, screwDiameter=screwDiameter, screwCountersink=screwCountersink);


module dewalt_batteryholder(batteryHolderType = 0, batteryCount = 3, usedBatteryWidth = 86, mountingType = 2, screwDiameter = 3, screwCountersink = true) {
  verboseFlag = false;
  holderWidth = 60;
  holderHeight = 18.6;
  holderWall = 4;
  floorHeight = 7.6;
  floorLength = 61;
  guideRailLength = 42;
  guideRailGirth = 5;
  guideRailOffsetZ = 2.2;
  lockWidth = 26;
  lockDepth = 7;
  lockOffsetX = 53;
  lipLength = 15.534;
  lipHeight = 2.5;
  lipChamfer = 0.7;
  lipOffsetX = 1;
  lipAngledOffsetX = 8.1;
  wallFilletR = 8;
  handlingFilletR = 0.6;
  backCurveD = 26;
  backCurveE = 40;
  backOffsetX = 11.8;

  __fullHolderWidth = ((holderWidth * batteryCount) + ((batteryCount-1) * (usedBatteryWidth - holderWidth)));
  __dewalt_bh_dimensions = function() (
      (batteryHolderType == 0) ? [((0.5*backCurveD)+floorLength+lipLength),holderWidth,holderHeight,__fullHolderWidth] : ( 
      (batteryHolderType == 1) ? [guideRailLength,holderWidth,holderHeight,__fullHolderWidth] : (
      (batteryHolderType == 2) ? [floorLength,holderWidth,holderHeight,__fullHolderWidth] : [0,0,0,0] ))
      );

      
  module __multipleConnector(batDistance=0) {
    module __filletedConnector(dimensions=[1,1]) {
      translate([0,batDistance,0]) rotate([90,0,0]) linear_extrude(batDistance) offset(r=handlingFilletR) { offset(delta=-handlingFilletR) {
        square([dimensions[0],dimensions[1]]);
      }}
    }
    if(batteryHolderType == 0) {
      translate([backOffsetX,0,0]) __filletedConnector([floorLength,floorHeight]);
    }
    if(batteryHolderType == 1) {
      translate([0,0,0]) __filletedConnector([guideRailLength,floorHeight]);
    }
    if(batteryHolderType == 2) {
      translate([0,0,0]) __filletedConnector([floorLength,floorHeight]);
    }
  }
  module _dewalt_bh(type=0) {
    module __minimalBatteryHolder(withLock=false) {
      difference() {
        translate([0,holderWidth,0]) rotate([90,0,0]) linear_extrude(holderWidth) offset(r=handlingFilletR) { offset(delta=-handlingFilletR) {
          polygon([
            [0,0],
            [(withLock ? floorLength : guideRailLength),0],
            [(withLock ? floorLength : guideRailLength),holderHeight],
            [0,holderHeight]
          ]);
        }}
        translate([-0.01,0,0]) __batteryNegative();
      }
    }
    module __fullBatteryHolder() {
      translate([backOffsetX,0,0]) difference() {
        union() {
          cube([(floorLength+lipLength),holderWidth,holderHeight]);
          translate([-backOffsetX,0,0]) __backFilling();
        }
        translate([-0.01,0,0]) __batteryNegative();
      }
    }
    module __batteryNegative() {
      difference() {
        union() {
          //lock
          translate([lockOffsetX,(0.5*(holderWidth-lockWidth)),-0.1]) cube([lockDepth, lockWidth, (floorHeight+0.1)]);
          //base
          translate([0,holderWall,floorHeight]) cube([(floorLength+0.1), (holderWidth-(2*holderWall)), (holderHeight-floorHeight+0.1)]);
          translate([(floorLength-lipOffsetX),0,0]) cube([(lipLength+lipOffsetX+0.1),holderWidth,(holderHeight+0.1)]);
        }

        //guiderail left
        translate([0,(holderWidth-holderWall),(holderHeight-guideRailOffsetZ)]) __guideRail(true);
        //guiderail right
        translate([0,holderWall,(holderHeight-guideRailOffsetZ)]) __guideRail(false);
        //remove filleted walls and lip
        union() {
          translate([floorLength,-0.1,0]) __filletedTopWall(length=(holderWall+0.1));
          intersection() {
            translate([floorLength,0,0]) __filletedTopWall(length=holderWidth);
            translate([floorLength,0,0]) __lip();
          }
          translate([floorLength,(holderWidth-holderWall),0]) __filletedTopWall(length=(holderWall+0.1));
        }
      }
    }
    module __filletedTopWall(length=1) {
      module __basicShape() {
        difference() {
          polygon([ [-lipOffsetX,holderHeight],[(holderWall-lipOffsetX),holderHeight],[(lipLength), lipChamfer],[(lipLength-lipChamfer),0],[-lipOffsetX,0] ]);
          translate([-(lipOffsetX+0.1),holderHeight,0]) square([(2*lipLength),(2*holderWall)]);
        }
      }

      translate([0,length,0]) rotate([90,0,0]) linear_extrude(length) union() {
        intersection() {
          __basicShape();
          translate([-(lipOffsetX+0.1),(holderHeight-wallFilletR),0]) intersection() {
            circle(r=wallFilletR);
            square(wallFilletR+1);
          }
        }
        difference() {
          __basicShape();
          translate([-(lipOffsetX+0.1), (holderHeight-(0.5*wallFilletR)),0]) square([(2*lipLength),holderHeight]);
        }
      }
    }
    module __lip() {
      union() {
        translate([0,(holderWidth-holderWall-0.1),0]) rotate([90,0,0]) linear_extrude(holderWidth-(2*holderWall)+0.2) polygon([
          [-0.1,-0.1],
          [(lipLength-lipChamfer-0.1),-0.1],
          [lipLength,lipChamfer],
          [lipLength,lipHeight], //do something fancy with intersect
          [lipAngledOffsetX,lipHeight],
          [0,floorHeight],
          [-0.1,floorHeight],
        ]);
        translate([-(lipOffsetX+0.1),(holderWall-0.1),0]) cube([(lipOffsetX+0.1),(holderWidth-(2*holderWall)+0.2),floorHeight]);
      }
    }
    module __guideRail(left=true) {
      module __bluePrint() {
        polygon([
          [0.1,0],
          [0,0],
          [-guideRailGirth,0],
          [0,-guideRailGirth],
          [0.1,-guideRailGirth]
        ]);
      }
      module __bluePrintComposit(addDelta=0) {
        offset(delta=addDelta) {
        union() {
          offset(r=handlingFilletR) { offset(delta=-handlingFilletR) {
            __bluePrint();
          }}
          difference() {
            __bluePrint();
            translate([-guideRailGirth,-((0.5*guideRailGirth)-0.1),0]) square(0.5*guideRailGirth);
          }
        }
        }
      }
      module __grBase() {
        translate([-0.1,0,0]) rotate([90,0,90]) union() {
          linear_extrude(guideRailLength+0.1) __bluePrintComposit();
        }
      }
      if(left) {
        __grBase();
      }
      if(!left) {
        mirror([0,1,0]) __grBase();
      }
    }
    module __backFilling() {
      translate([(0.5*backCurveD),0,0]) linear_extrude(holderHeight) intersection() {
        translate([-(backCurveD+0.1),-0.1,-0.1]) square([(backCurveD+0.1), (holderWidth+0.2)]);
        union() {
          translate([0,(holderWidth-(0.5*backCurveE)),0]) resize([backCurveD,backCurveE,0]) circle(d=backCurveD);
          translate([0,(0.5*backCurveE),0]) resize([backCurveD,backCurveE,0]) circle(d=backCurveD);
          translate([-(0.5*backCurveD),(0.5*backCurveE),0]) square([(0.5*backCurveD), (holderWidth-backCurveE)]);
        }
      }
    }
    if(type == 0) { __fullBatteryHolder(); }
    if(type == 1) { __minimalBatteryHolder(false); }
    if(type == 2) { __minimalBatteryHolder(true); }
  }
  module _screwcutout(length=0) {
    rotate_extrude() polygon([
      [0,(0.1+length)],
      [(screwCountersink ? screwDiameter : (0.5*screwDiameter)),(0.1+length)],
      [(screwCountersink ? screwDiameter : (0.5*screwDiameter)),0.1],
      [(0.5*screwDiameter),(0.1 - (0.5*screwDiameter))],
      [(0.5*screwDiameter),-(20+length)],
      [0,-(20+length)],    
    ]);
  }
  module _tclipcutout(length=0) {
    module _bowl(height=0) {
      union() {
        translate([0,-5.5,0]) rotate([-90,0,0]) rotate_extrude() polygon([
          [0,0],
          [11,0],
          [8,3],
          [0,3]
        ]);
        if(height > 0) {
          translate([0,-5.5,0]) rotate([90,0,0]) cylinder(h=height, r=11);
        }
      }
    }
    module _key(height=2.7) {
      translate([0,(height-2.6),0]) rotate([90,0,0]) linear_extrude(height) union() {
        translate([0,5,0]) circle(d=5.2);
        square([5.2,10], center=true);
        translate([0,-5,0]) circle(d=5.2);
      }
    }

    union() {
      _key();
      _bowl(length);
    }
  }
  module _renderHolders() {
    dims = __dewalt_bh_dimensions();

    if(verboseFlag) {
      echo(dims=dims);
      translate([(dims[0]+30),0,0]) cube([2,dims[3],2]);
      translate([(dims[0]+40),((0.5*dims[3])-5),0]) linear_extrude(2) text(str(dims[3]));
      translate([0,-30,0]) cube([dims[0], 2,2]);
      translate([((0.5*dims[0])-10),-50,0]) linear_extrude(2) text(str(dims[0]));
    }

    _grBounds = [ for(b=[0:1:(batteryCount-1)]) [((holderWall+guideRailGirth)+(b*usedBatteryWidth)),(dims[1] - (holderWall+guideRailGirth) + (b*usedBatteryWidth))] ];

    if(verboseFlag) {
      echo(_grBounds=_grBounds);
      for(_bnd = _grBounds) {
        translate([-100,_bnd[0],0]) cube([2,(_bnd[1]-_bnd[0]),2]);
        translate([-130,(_bnd[0]-5),0]) linear_extrude(2) text(str(_bnd[0]));
        translate([-130,(_bnd[1]-5),0]) linear_extrude(2) text(str(_bnd[1]));
      }
    }

    difference() {
      if(batteryCount > 1) {
        batDistance = (usedBatteryWidth - dims[1]);
        union() {
          for(batCount = [0:1:(batteryCount-1)]) {
            translate([0,(batCount*(dims[1]+batDistance)),0]) _dewalt_bh(batteryHolderType);
            if(batCount > 0) {
              translate([0,((batCount*(dims[1]+batDistance))-batDistance),0]) __multipleConnector(batDistance);
            }
          }
        }
      }
      else {
        _dewalt_bh(batteryHolderType);
      }

      if(mountingType == 1) { // screwholes
        for(screwLine = [0:1:(batteryCount-1)]) {
          translate([((0.5*dims[0])-(3*screwDiameter)),((0.5*dims[1])+(screwLine*usedBatteryWidth)),floorHeight]) _screwcutout(dims[1]);
          translate([((0.5*dims[0])+(3*screwDiameter)),((0.5*dims[1])+(screwLine*usedBatteryWidth)),floorHeight]) _screwcutout(dims[1]);
        }
      }
      if(mountingType == 2) { // skadis tclip cutouts
        countSkadisMounts = (floor(dims[3] / 40) + 1);
        skadisYoffset = (0.5 * (dims[3] - (countSkadisMounts*40)));
        if(verboseFlag) { echo(skadisYoffset=skadisYoffset, countSkadisMounts=countSkadisMounts, fullwidth=dims[3], flooredDivision=floor(dims[3] / 40)); }
        for(skadisYpos = [0:1:(countSkadisMounts-1)]) {
          translationPos = (skadisYoffset + (skadisYpos * 40));
          // check whether it is between the guiderails and remove material
          skBounds = [(translationPos-11),(translationPos+11)];
          for(check = _grBounds) {
            if( (check[0] < skBounds[0]) && (check[1] > skBounds[1]) ) {
              xPos = (
                batteryHolderType == 0 ? (backOffsetX+11+holderWall) : (
                batteryHolderType == 1 ? (guideRailLength-11-holderWall) : (
                batteryHolderType == 2 ? (guideRailLength-11-holderWall) : 50 )
              ));
              translate([xPos,translationPos,-0.01]) rotate([-90,0,-90]) _tclipcutout(50);
            }
          }
        }
      }
    }
  }

  _renderHolders();
}