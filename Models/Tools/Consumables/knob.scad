//
//    Knob - Gigity
// Models/Tools/Consumables/knob.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v2.2.0    2026-06-26    Add knurling
//      v2.1.0    2026-06-26    Add adjustable shaft length
//      v2.0.0    2026-06-26    Reworked version
//      v1.0.0    2024-06-09    Initial version
//


/* [Knob - Gigity] */
// Which type of knob to render
renderItem = 0; // [0:Regular, 1:Ribbed, 2:Dimpled, 3:finger]
// Set to true to add knurling to sides of knob
knurling = false;

/* [Dimensions] */
// Knob diameter in mm
knobDiameter = 50;
// Knob height in mm
knobHeight = 18;
// Thickness of top layer in mm
topLayer = 5;
// Outer wall thickness in mm
wall = 1.4;

/* [Shaft] */
// Diameter of shaft in mm, use 6.3 for EC11 or KY-040
shaftDiameter = 6.3;
// Cutoff for shaft in mm, use same as shaftDiameter for open hole (in mm)
shaftCutoff = 4.8;
// Wall thickness around shaft in mm
shaftWall = 2;
// Override to customize the shaft length. Set to 0 for default (in mm)
shaftLengthOverride = 0;

/* [Indicator] */
// Whether or not to put on an indicator
indicator = true;
// Whether to recess the indicator, or lay on top
indicatorRecessed = true;
// Length of the indicator in mm
indicatorLength = 10;
// Thickness of indicator (or depth when recessed) in mm
indicatorHeight = 1;
// Width of the indicator in mm
indicatorWidth = 1;

/* [Regular] */
// Fillet radius on top and bottom in mm
regularFillet = 0.6;

/* [Ribbed] */
// Number of ribs, or number of dimples depending on renderItem
ribCount = 100;
// Whether or not the ribs are closed on the top and the bottom of the knob
ribsOpen = false;
// Fillet radius on top and bottom in mm
ribsFillet = 1;

/* [Dimpled] */
// Number of pimples on the surface of the knob
dimpleCount = 10;
// diameter of spheres which appear as pimples on the surface (in mm)
dimpleDiameter = 5;


/* [Hidden] */
include <ub.scad>;
include <knurledFinishLib_v2.scad>;

knob(
  type=renderItem,
  knurling=knurling,
  knobDiameter=knobDiameter,
  knobHeight=knobHeight,
  topLayer=topLayer,
  wall=wall,
  shaftDiameter=shaftDiameter,
  shaftCutoff=shaftCutoff,
  shaftWall=shaftWall,
  shaftLengthOverride=shaftLengthOverride,
  indicator=indicator,
  indicatorRecessed=indicatorRecessed,
  indicatorLength=indicatorLength,
  indicatorHeight=indicatorHeight,
  indicatorWidth=indicatorWidth,
  regularFillet=regularFillet,
  ribCount=ribCount,
  ribsOpen=ribsOpen,
  ribsFillet=ribsFillet,
  dimpleCount=dimpleCount,
  dimpleDiameter=dimpleDiameter
);


module knob(
  type = 0,
  knurling = false,
  knobDiameter = 50,
  knobHeight = 18,
  topLayer = 5,
  wall = 1.4,
  shaftDiameter = 6.3,
  shaftCutoff = 4.8,
  shaftWall = 2,
  shaftLengthOverride = 0,
  indicator = true,
  indicatorRecessed = true,
  indicatorLength = 10,
  indicatorHeight = 1,
  indicatorWidth = 1,
  regularFillet = 0.6,
  ribCount = 100,
  ribsOpen = false,
  ribsFillet = 1,
  dimpleCount = 10,
  dimpleDiameter = 5
) {
  module _regular() {
    _basicShapeKnob();
  }

  module _forPleasure() {
    difference() {
      _basicShapeKnob();
      for(angle=[0:(360/ribCount):360]) {
        R(0,0,angle)T((0.5*knobDiameter),0)Tz(ribsOpen?-0.1:max(1,ribsFillet))cylinder(d=1,h=(ribsOpen ? (knobHeight+0.2) : (knobHeight-(2*max(1,ribsFillet)))));
      }
    }
  }

  module _bubblyPleasure() {
    union() {
      difference() {
        _basicShapeKnob();
        Tz(-((2.2*knobDiameter)-2))sphere(d=(4.4*knobDiameter));
      }
      for(dimple=[0:1:(dimpleCount-1)]) {
        R(0,0,(dimple*(360/dimpleCount)))T(0,(0.375*knobDiameter),(0.4*dimpleDiameter))sphere(d=dimpleDiameter);
      }
    }
  }

  module _femPleasure() {
    difference() {
      _basicShapeKnob();
      T(0,((0.5*knobDiameter)-10),-18.8)sphere(d=40);
    }
  }

  module _basicShapeKnob() {
    filletUsed = (renderItem == 0 ? regularFillet : (renderItem == 1 ? ribsFillet : 0));
    union() {
      difference() {
        union() {
          if(filletUsed > 0) {
            Pille(l=knobHeight,d=knobDiameter,rad=filletUsed,center=false);
          } else {
            cylinder(d=knobDiameter, h=knobHeight);
          }
          if(knurling && renderItem != 1) {
            Tz(filletUsed)knurl(k_cyl_hg=(knobHeight-(2*filletUsed)),	k_cyl_od=(knobDiameter+(2*max(filletUsed,0.7))));
          }
        }
        Tz(topLayer)cylinder(d=(knobDiameter-(2*wall)), h=knobHeight);
        if(indicator && indicatorRecessed) { _pointer(); }
      }
      if(indicator && !indicatorRecessed) { _pointer(); }
      _shaft(shaftLengthOverride);
    }
  }

  module _shaft(length=0) {
    shaftLength = ((length != 0) ? length : (knobHeight-topLayer));
    Tz(topLayer)difference() {
      cylinder(d=(shaftDiameter+(2*shaftWall)), h=(shaftLength+0.1));
      Tz(-0.1)difference() {
        cylinder(d=shaftDiameter,h=(shaftLength+0.4));
        T((-((0.5*shaftDiameter)+1)+shaftCutoff-(0.5*shaftDiameter)+(0.5*(shaftDiameter+1))),-((0.5*shaftDiameter)+1),-0.1)cube([(shaftDiameter+1),(shaftDiameter+1),(shaftLength+0.8)]);
      }
    }
  }

  module _pointer() {
    if(indicator) {
      kR = (0.5*knobDiameter);
      iH = (indicatorHeight+0.1);
      zO = (indicatorRecessed ? -0.1 : -indicatorHeight);

      Tz(zO)difference() {
        cylinder(r=(kR-1), h=iH);
        Tz(-0.1)cylinder(r=(kR-1-indicatorLength), h=(iH+0.2));
        T((0.5*indicatorWidth),-(0.5*knobDiameter),-0.1)cube([knobDiameter,knobDiameter,(iH+0.2)]);
        T(-(knobDiameter+(0.5*indicatorWidth)),-(0.5*knobDiameter),-0.1)cube([knobDiameter,knobDiameter,(iH+0.2)]);
        T(-(0.5*knobDiameter),-knobDiameter,-0.1)cube([knobDiameter,knobDiameter,(iH+0.2)]);
      }
    }
  }

  if(type == 0) { _regular(); }
  if(type == 1) { _forPleasure(); }
  if(type == 2) { _bubblyPleasure(); }
  if(type == 3) { _femPleasure(); }
}