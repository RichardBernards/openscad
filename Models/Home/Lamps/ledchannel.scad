//
//    Led Channel
// Models/Home/Lamps/ledchannel.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2026-08-11    Initial version
//

/* [Led Channel] */
// Diameter of channel in mm
diam = 50;
// Length of channel-section in mm
length = 200;
// Thickness of channel in mm
wall = 3;
// Gap width for light to shine through in mm
gap = 20;
// Whether or not to add clips for an aluminium rod
addRodClips = true;
// Diameter of aluminium rod to attach led-strip to (in mm)
rod = 13;
// Length of connector part for sections in mm
connectorLength = 30;
// Which item to render
renderItem = 5; // [0:Channel Section, 1:Left Endcap, 2:Right Endcap, 3:Assembly, 4:Exploded View, 5:Printer Friendly]
// Number of items to render along two axis [x,y]
count = [1,1];

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;


use <ub.scad>;


ledchannel(
  diam=diam,
  length=length,
  wall=wall,
  gap=gap,
  addRodClips=addRodClips,
  rod=rod,
  connectorLength=connectorLength,
  renderItem=renderItem,
  count=count
);


module ledchannel(diam=50, length=200, wall=3, gap=20, addRodClips=true, rod=12, connectorLength=30, renderItem=0, count=[1,1]) {
  radius = (0.5*diam);
  gapAngle = (2* asin((0.5*gap)/radius));

  module __bluePrint(stretch=40) {
    polygon([
      [radius,connectorLength],
      [radius,(stretch-connectorLength)],
      [(radius-wall),(stretch-connectorLength)],
      [(radius-wall),connectorLength]
    ]);
  }
  module __rodClip() {
    T(0,-(0.5*rod),-(5+rod))difference() {
      rotate_extrude(angle=260,start=-40) polygon([
        [(0.5*rod),0],
        [((0.5*rod)+1),0],
        [((0.5*rod)+1),(10+rod)],
        [(0.5*rod),(10+rod)],
      ]);
      Tz(rod)R(45)T(0,-(2*rod))cube(4*rod,center=true);
    }
  }
  module __maleConnector() {
    polygon([
      [(radius-wall),0],
      [(radius-wall+1),0],
      [(radius-wall+1),(connectorLength-12.1)],
      [(radius-wall+2),(connectorLength-11.1)],
      [(radius-wall+1),(connectorLength-10.1)],
      [(radius-wall+1),(connectorLength-5.1)],
      [(radius-wall+2),(connectorLength-4.1)],
      [(radius-wall+1),(connectorLength-3.1)],
      
      [(radius-wall+1),(connectorLength-1.3)],
      
      [(radius-wall),(connectorLength-0.3)],
    ]);
  }
  module __femaleConnector() {
    polygon([
      [radius,0],
      [radius,connectorLength],
      [(radius-wall),connectorLength],
      [(radius-wall+1.1),(connectorLength-1.1)],
//      [(radius-wall+1.1),connectorLength],
      [(radius-wall+1.1),(connectorLength-3.1)],
      [(radius-wall+2.1),(connectorLength-4.1)],
      [(radius-wall+1.1),(connectorLength-5.1)],
      [(radius-wall+1.1),(connectorLength-10.1)],
      [(radius-wall+2.1),(connectorLength-11.1)],
      [(radius-wall+1.1),(connectorLength-12.1)],
      [(radius-wall+1.1),0],
    ]);
  }
  module _ledChannel(cnt=[1,1]) {
    for(ix=[0:1:(cnt[0]-1)]) { for(iy=[0:1:(cnt[1]-1)]) {
      T((ix*(diam+1)),(iy*(diam+1)))union() {
        //right side of channel
        rotate_extrude(angle=(180-gapAngle), start=-(90-(0.5*gapAngle))) __femaleConnector();
        rotate_extrude(angle=(180-gapAngle), start=-(90-(0.5*gapAngle))) __bluePrint(length);
        Tz(length-connectorLength)rotate_extrude(angle=(170-gapAngle), start=-(90-(0.5*gapAngle))) __maleConnector();
        //flat top part of channel
        T(-(0.5*gap),(((0.5*gap)/tan(0.5*gapAngle))-wall))cube([gap,wall,(length-connectorLength-0.2)]);
        //left side of channel
        rotate_extrude(angle=(180-gapAngle), start=(90+(0.5*gapAngle))) __femaleConnector();
        rotate_extrude(angle=(180-gapAngle), start=(90+(0.5*gapAngle))) __bluePrint(length);
        Tz(length-connectorLength)rotate_extrude(angle=(170-gapAngle), start=(100+(0.5*gapAngle))) __maleConnector();
        //Add rodclips
        if(addRodClips) {
          T(0,(((0.5*gap)/tan(0.5*gapAngle))-wall),(length-connectorLength-10))__rodClip();
          T(0,(((0.5*gap)/tan(0.5*gapAngle))-wall),(connectorLength+(10+rod)))__rodClip();
        }
      }
    }}
  }
  module _leftCap(cnt=[1,1]) {
    for(ix=[0:1:(cnt[0]-1)]) { for(iy=[0:1:(cnt[1]-1)]) {
      T((ix*(diam+1)),(iy*(diam+1)))union() {
        Tz(wall)rotate_extrude(angle=(170-gapAngle), start=-(90-(0.5*gapAngle))) __maleConnector();
        Tz(wall)rotate_extrude(angle=(170-gapAngle), start=(100+(0.5*gapAngle))) __maleConnector();
        difference() {
          Tz((0.5*wall)+1)Pille(l=(wall+2),d=diam,rad=1);
          Tz(diam+wall)cube(2*diam, center=true);
          T(0,(diam+((0.5*gap)/tan(0.5*gapAngle))))cube(2*diam, center=true);
        }
      }
    }}
  }
  module _rightCap(cnt=[1,1]) {
    for(ix=[0:1:(cnt[0]-1)]) { for(iy=[0:1:(cnt[1]-1)]) {
      T((ix*(diam+1)),(iy*(diam+1)))union() {
        Tz(wall)union() {
          Tz(connectorLength)R(180)rotate_extrude(angle=(180-gapAngle), start=-(90-(0.5*gapAngle))) __femaleConnector();
          T(-(0.5*gap),(((0.5*gap)/tan(0.5*gapAngle))-wall))cube([gap,wall,connectorLength]);
          Tz(connectorLength)R(180)rotate_extrude(angle=(180-gapAngle), start=(90+(0.5*gapAngle))) __femaleConnector();
        }
        difference() {
          Tz((0.5*wall)+1)Pille(l=(wall+2),d=diam,rad=1);
          Tz(diam+wall)cube(2*diam, center=true);
          T(0,(diam+((0.5*gap)/tan(0.5*gapAngle))))cube(2*diam, center=true);
        }
      }
    }}
  }
  module _assembly() {
    _leftCap(cnt=count);
    Tz(wall)_ledChannel(cnt=count);
    T((count[0]-1)*(diam+1))Tz(wall+length)R(0,180)_rightCap(cnt=count);
  }
  module _exploded() {
    Tz(2*diam)union() {
      T(-((0.5*length)+connectorLength+20))R(45)R(0,90)_leftCap(cnt=count);
      T(-(0.5*length))R(45)R(0,90)_ledChannel(cnt=count);
      T(((0.5*length)+connectorLength+20))R(45)T(0,0,-((count[0]-1)*(diam+1)))R(0,-90)_rightCap(cnt=count);
    }
  }
  module _printerFriendly() {
    T(0,(count[1]>2 ? (diam+2) : 0))union() {
      T(-((diam*cos(30))+1),((diam*sin(30))+1))_leftCap([1,1]);
      T(-((diam*cos(30))+1),-((diam*sin(30))+1)) _rightCap([1,1]);
    }
    _ledChannel(count);
  }

  if(renderItem == 0) { _ledChannel(); }
  if(renderItem == 1) { _leftCap(); }
  if(renderItem == 2) { _rightCap(); }
  if(renderItem == 3) { _assembly(); }
  if(renderItem == 4) { _exploded(); }
  if(renderItem == 5) { _printerFriendly(); }
}