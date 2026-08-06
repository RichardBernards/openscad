//
//    Paper Towel Holder
// Models/Home/Kitchen/papertowelholder.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v1.0.0    2026-06-17    Release version
//      v0.9.0    2026-06-17    Fix library paths and preset config
//      v0.3.0    2026-06-17    Add preset configurations
//      v0.2.0    2026-06-17    Add segmentation of renders
//      v0.1.0    2026-06-17    Major update in parameterizing
//      v0.0.1    2026-06-08    Initial version
//


/* [Settings] */
// Paper towel preset dimensions (hole diameter - diameter - width in mm)
preset = 0; // [0:38-150-220, 1:38-120-220, 2:manual]
// Which item to render
renderItem = 0; // [0:All, 1:Holder, 2:Button, 3:Spring, 4:Assembly]
// Wall thickness in mm
walls = 2.6;

/* [Manual Dimension Settings] */
// Hole diameter in mm
hole = 38;
// Outer diameter of paper towel roll in mm
outerDiam = 150;
// Width of paper towels in mm (in orientation translates to height)
height = 220;

/* [Advanced Settings] */
// Modify the sides with this factor to have some aesthetic clearance
sideModifier = 0.75;

// Used for 3D printing dimensions and as cut-off for the button (in mm)
maxHeight = 180;
// Space inside pin to accomodate for spring in mm
coilSpacing = 60;

// Factors used to generate smaller diameters for stem and button (in mm)
buttonDiamSteps = [0.5,0.7];
// Height of keyed steps in button and stem (in mm)
buttonHeightSteps = [20,50];
// Dimensions for button (top diameter, topside fillet radius, bottomside fillet radius, top cylinder height) all in mm
buttonDims = [80,1,3,11];

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;



use <ub.scad>;
use <../../../lib/3dspring.scad>;

papertowelholder(preset=preset, renderItem=renderItem, walls=walls, sideModifier=sideModifier, maxHeight=maxHeight, coilSpacing=coilSpacing, manual=[hole,outerDiam,height], buttonDiamSteps=buttonDiamSteps, buttonHeightSteps=buttonHeightSteps, buttonDims=buttonDims);

module papertowelholder(preset=0, renderItem=0, walls=2.6, sideModifier=0.75, maxHeight=180, coilSpacing=60, manual=[38,150,220], buttonDiamSteps=[0.5,0.7], buttonHeightSteps=[20,50], buttonDims=[80,1,3,11]) {

  //presets
  p = [
    [38,150,220],
    [38,120,220],
  ];

  dims = ((preset == 2) ? [hole, outerDiam, height] : p[preset]);
  sideHeight = (sideModifier * dims[2]);
  stemHeight = min((dims[2]+walls),maxHeight);
  hDiff = ((dims[2]+walls)-stemHeight);


  module _springBrake() {
    rotate([90,0,0]) difference() {
      T(0,3.5)union() {
        spring(springT=10,springOD=5,springTh=1,loops=(ceil(coilSpacing/5)+1));
        T(0,1)rotate([90,0,0]) cylinder(h=4,d=((0.5*dims[0])-0.3));
        T(0,52)rotate([-90,0,0]) cylinder(h=4,d=((0.5*dims[0])-0.3));
      }
      //remove bottom and top of cylinders
      T(-25,-5,-25)cube([50,100,20]);
      T(-25,-5,5)cube([50,100,20]);
    }
  }
  module _stem() {
    difference() {
      cylinder(h=stemHeight, d=dims[0]);

      Tz(stemHeight-(buttonHeightSteps[1]-buttonHeightSteps[0])-coilSpacing)cylinder(h=((buttonHeightSteps[1]-buttonHeightSteps[0])+1+coilSpacing), d=(buttonDiamSteps[0]*dims[0]));
      Tz(stemHeight-buttonHeightSteps[0])cylinder(h=(buttonHeightSteps[0]+1), d=(buttonDiamSteps[1]*dims[0]));T(-0.75,0,20)_cp();
    }
  }
  module _button() {
    topR = (0.5*buttonDims[0]);
    difference() { union() {
      Tz(hDiff-2)rotate_extrude() union() {
        T((topR-buttonDims[2]),buttonDims[2])circle(r=buttonDims[2]);
        square([(topR-buttonDims[2]),buttonDims[2]]);
        T(0,buttonDims[2])square([topR,(buttonDims[3]-buttonDims[1]-buttonDims[2])]);
        T((topR-buttonDims[1]),(buttonDims[3]-buttonDims[1]))circle(r=buttonDims[1]);
        T(0,(buttonDims[3]-buttonDims[1]))square([(topR-buttonDims[1]),buttonDims[1]]);
      }
      cylinder(h=hDiff,d=dims[0]);
      Tz(-(buttonHeightSteps[1]-0.2))cylinder(h=(buttonHeightSteps[1]-0.2), d=((buttonDiamSteps[0]*dims[0])-0.3));
      Tz(-(buttonHeightSteps[0]-0.2))cylinder(h=(buttonHeightSteps[0]-0.2), d=((buttonDiamSteps[1]*dims[0])-0.3));
    } T(-0.75,0,((hDiff-2)+(0.5*buttonDims[3])))_cp(); }
  }
  module _cp(l=1){module _p(){hull(){linear_extrude(0.01) polygon([[0,0],[l,0],[0.5*l,l]]);translate([0.5*l,0,l]) cube(0.01);translate([0.5*l,l,-l]) cube(0.01);}}union(){_p();translate([0.6*l,l,0]) mirror([0,1,0])_p();}}
  module _cylinderize(h=100, d=150, id=5, flt=1) {
    c = (PI * d);
    count = ceil(c / id);
    r = (0.5*dims[1]);
//    echo(c=c, count=count);

    union() {
      for(i=[0:1:(count-5)]) {
        rotate([0,0,((360/count)*i)]) translate([-(0.5*d),0,flt]) union() {
          cylinder(h=h, d=id);
          if(flt > 0) {
            scale([1,1,(flt/(0.5*id))]) sphere(d=id);
            translate([0,0,h]) scale([1,1,(flt/(0.5*id))]) sphere(d=id);
          }
        }
      }
      rotate_extrude(angle=((360/count)*(count-5))) polygon([
        [-r,0],
        [-(r+walls),0],
        [-(r+walls),h],
        [-r,h]
      ]);
    }
  }
  module _cannister() {
    difference() {
      union() {
        //bottom
        cylinder(h=walls, d=(dims[1]+(2*walls)));
        //cylinder walls
        _cylinderize(h=(sideHeight+walls), d=(dims[1]+(2*walls)), id=5, flt=0);
      }
      T(0,2.5,walls)rotate([90,0,-90]) linear_extrude((0.5*dims[1])+10) difference() {
        T(-2)square((2*sideHeight)+4);
        //rix doublecheck radius
        T(2*sideHeight)circle(r=(2*sideHeight));
      }
    }
  }

  union() {
    if(renderItem == 0 || renderItem == 4 || renderItem == 1) {
      union() {
        _cannister();
        _stem();
      }
    }
    if(renderItem == 0 || renderItem == 2) {
      T(dims[1],0,(9+hDiff))rotate([180,0,0]) _button();
    }
    if(renderItem == 0 || renderItem == 3) {
      T(120,120,5)rotate([90,0,0])_springBrake();
    }
    if(renderItem == 4) {
      Tz(stemHeight+0.2)_button();
      Tz(stemHeight-coilSpacing-(buttonHeightSteps[1]-buttonHeightSteps[0]))_springBrake();
    }
  }
}