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
// renderSettings
$fs = 0.2;
$fa = 2;

// Cardbox settings
walls = (boxType == 1 ? wallOverride : wallThickness);
iSize = [insideWidth,insideDepth,insideHeight];
oSize = [(insideWidth+(2*walls)),(insideDepth+(2*walls)),(insideHeight+(2*walls))];

if(boxType == 0) {
  cardbox();
}
else if(boxType == 1) {
  flipbox();
}

function __textdata() = 
  let(tmF = textmetrics(frontText, font=fontString, size=fontSizeFront))
  let(tmS = textmetrics(sideText, font=fontString, size=fontSizeSide))
  let(tmT = textmetrics(topText, font=fontString, size=fontSizeTop))
  let(sOffset = (2.5*walls))
  [
    [ //cardbox
      [ //debossing
        [[(0.5*(oSize[0]-tmF.size[0])),debossingDepth,(0.5*(oSize[2]-tmF.size[1]))],[90,0,0],[(debossingDepth+0.1)],[frontText],[fontSizeFront]], //front
        [[debossingDepth,(0.5*(oSize[1]-tmS.size[1])),sOffset],[0,-90,0],[(debossingDepth+0.1)],[sideText],[fontSizeSide]], //side
        [[(0.5*(oSize[0]-tmT.size[0])),(0.5*(oSize[1]-tmT.size[1])),(oSize[2]-debossingDepth)],[0,0,0],[(debossingDepth+0.1)],[topText],[fontSizeTop]] //top
      ],
      [ //embossing
        [[(0.5*(oSize[0]-tmF.size[0])),0.1,(0.5*(oSize[2]-tmF.size[1]))],[90,0,0],[(embossingHeight+0.1)],[frontText],[fontSizeFront]], //front
        [[0.1,(0.5*(oSize[1]-tmS.size[1])),sOffset],[0,-90,0],[(embossingHeight+0.1)],[sideText],[fontSizeSide]], //side
        [[(0.5*(oSize[0]-tmT.size[0])),(0.5*(oSize[1]-tmT.size[1])),(oSize[2]-0.1)],[0,0,0],[(embossingHeight+0.1)],[topText],[fontSizeTop]] //top
      ]
    ],
    [ //flipbox
      [ //debossing
        [[((0.5*(oSize[0]-tmF.size[0]))+tmF.size[0]),debossingDepth,(0.5*(oSize[2]-tmF.size[1]))],[90,180,0],[(debossingDepth+0.1)],[frontText],[fontSizeFront]], //front
        [[(oSize[0]-debossingDepth),(0.5*((oSize[1] + (2*walls) + clearance)-tmS.size[1])),(oSize[2]-sOffset)],[0,90,0],[(debossingDepth+0.1)],[sideText],[fontSizeSide]], //side
        [[((0.5*(oSize[0]-tmT.size[0]))+tmT.size[0]),(0.5*((oSize[1] + (2*walls) + clearance)-tmT.size[1])),debossingDepth],[180,0,180],[(debossingDepth+0.1)],[topText],[fontSizeTop]] //top
      ],
      [ //embossing
        [[((0.5*(oSize[0]-tmF.size[0]))+tmF.size[0]),0.1,(0.5*(oSize[2]-tmF.size[1]))],[90,180,0],[(embossingHeight+0.1)],[frontText],[fontSizeFront]], //front
        [[(oSize[0]-0.1),(0.5*((oSize[1] + (2*walls) + clearance)-tmS.size[1])),(oSize[2]-sOffset)],[0,90,0],[(embossingHeight+0.1)],[sideText],[fontSizeSide]], //side
        [[((0.5*(oSize[0]-tmT.size[0]))+tmT.size[0]),(0.5*((oSize[1] + (2*walls) + clearance)-tmT.size[1])),0.1],[180,0,180],[(embossingHeight+0.1)],[topText],[fontSizeTop]] //top
      ]
    ]
  ];

module __renderDividers() {
  for(do = dividerOffsets) {
    if(do > 0) {
      translate([walls,(walls+do),walls]) cube([insideWidth,dividerThickness,insideHeight]);
    }
  }
}

module __renderTexts(onlyTop=false,excludeTop=false) {
  if(textRendering > 0) {
    _textdata = __textdata();
    
    //front
    if(!onlyTop) {
      translate([_textdata[boxType][(textRendering-1)][0][0][0],_textdata[boxType][(textRendering-1)][0][0][1],_textdata[boxType][(textRendering-1)][0][0][2]]) rotate([_textdata[boxType][(textRendering-1)][0][1][0],_textdata[boxType][(textRendering-1)][0][1][1],_textdata[boxType][(textRendering-1)][0][1][2]]) linear_extrude(_textdata[boxType][(textRendering-1)][0][2][0]) text(_textdata[boxType][(textRendering-1)][0][3][0], font=fontString, size=_textdata[boxType][(textRendering-1)][0][4][0]);
    }
    if(!onlyTop) {
      //side
      translate([_textdata[boxType][(textRendering-1)][1][0][0],_textdata[boxType][(textRendering-1)][1][0][1],_textdata[boxType][(textRendering-1)][1][0][2]]) rotate([_textdata[boxType][(textRendering-1)][1][1][0],_textdata[boxType][(textRendering-1)][1][1][1],_textdata[boxType][(textRendering-1)][1][1][2]]) linear_extrude(_textdata[boxType][(textRendering-1)][1][2][0]) text(_textdata[boxType][(textRendering-1)][1][3][0], font=fontString, size=_textdata[boxType][(textRendering-1)][1][4][0]);
    }
    if(!excludeTop) {
      //top
      translate([_textdata[boxType][(textRendering-1)][2][0][0],_textdata[boxType][(textRendering-1)][2][0][1],_textdata[boxType][(textRendering-1)][2][0][2]]) rotate([_textdata[boxType][(textRendering-1)][2][1][0],_textdata[boxType][(textRendering-1)][2][1][1],_textdata[boxType][(textRendering-1)][2][1][2]]) linear_extrude(_textdata[boxType][(textRendering-1)][2][2][0]) text(_textdata[boxType][(textRendering-1)][2][3][0], font=fontString, size=_textdata[boxType][(textRendering-1)][2][4][0]);
    }
  }
}

module cardbox() {
  module _filamentRemoval() {
    translate([-(2*walls),( (oSize[1]-walls) + (0.5*walls) ),( (oSize[2]-lidHeight) + (0.5*walls) )]) rotate([0,90,0]) cylinder(r=hingeRadius, h=(oSize[0]+(4*walls)));
  }
  module _lidNegative() {
    translate([-walls,0,( (oSize[2]-lidHeight) - (iSize[1]*tan(slantAngle)) )]) rotate([90,0,90]) linear_extrude(oSize[0]+(2*walls)) polygon([ [-0.1, 0],[walls, 0],[(walls+iSize[1]), (iSize[1]*tan(slantAngle))],[oSize[1], ( (iSize[1]*tan(slantAngle)) - (walls*tan(slantAngle)) )],[(oSize[1]+0.1), ( (iSize[1]*tan(slantAngle)) - (walls*tan(slantAngle)) )],[(oSize[1]+0.1), ( (iSize[1]*tan(slantAngle)) + (2*lidHeight) )],[-0.1, ( (iSize[1]*tan(slantAngle)) + (2*lidHeight) )] ]);
  }
  module _lidRemoval() {
    hingeRoundoverRadius = 0.7;
    translate([-walls,(oSize[1]-walls),(oSize[2]-lidHeight)]) rotate([90,0,90]) linear_extrude(oSize[0]+(2*walls)) difference() {
      polygon([ [0,0],[0,-walls],[(walls+0.1),-walls],[(walls+0.1),hingeRoundoverRadius],[(walls-hingeRoundoverRadius),hingeRoundoverRadius],[(walls-hingeRoundoverRadius),0] ]);
      translate([(walls-hingeRoundoverRadius),hingeRoundoverRadius]) circle(r=hingeRoundoverRadius);
    }
  }
  module _boxHingepart(length=20) {
    rotate([90,0,90]) linear_extrude(length) union() {
      translate([(0.5*walls),(0.5*walls),0]) circle(d=walls);
      polygon([ [0,0],[walls,-(walls*tan(slantAngle))],[walls,(0.5*walls)],[0,(0.5*walls)] ]);
    }
  }
  module _clasp() {
    polygon([ [0,0],[0,-10],[1,-9],[1,3.6],[0.6,4],[-1,4],[-(1+(1.3*tan(45))),(2+(1.3*tan(45)))],[-1,2],[-1,0] ]);
  }
  
  _boxHingeLength = 20;

  //box
  union() {
    difference() {
      union() {
        __rcube(size=oSize, radius=filletR);
      }
      __insideNegative(iSize);
      union() {
        difference() {
          _lidNegative();
          translate([((0.5*oSize[0])-6-_boxHingeLength),(oSize[1]-walls),(oSize[2]-lidHeight-0.001)]) _boxHingepart(_boxHingeLength);
          translate([((0.5*oSize[0])+6),(oSize[1]-walls),(oSize[2]-lidHeight-0.001)]) _boxHingepart(_boxHingeLength);
        }
        _filamentRemoval();
      }
      if(textRendering == 1) { __renderTexts(excludeTop=true); }
    }
    translate([((0.5*oSize[0])-5),walls,(oSize[2]-lidHeight-(iSize[1]*tan(slantAngle)))]) rotate([90,0,90]) linear_extrude(10) _clasp();
    if(textRendering == 2) { __renderTexts(excludeTop=true); }
  }
  
  //lid
  translate([oSize[0],((2*oSize[1])+10),0]) rotate([180,0,180]) translate([0,-oSize[1],-oSize[2]]) union() {
    difference() {
      intersection() {
        difference() {
          __rcube(size=oSize, radius=filletR);
          __insideNegative(iSize,false);
        }
        _lidNegative();
      }
      _lidRemoval();
      _filamentRemoval();
      translate([((0.5*oSize[0])-5.2),(walls+0.001),(oSize[2]-lidHeight-(iSize[1]*tan(slantAngle)))]) rotate([90,0,90]) linear_extrude(10.4) offset(delta=0.1) { _clasp(); }
      translate([((0.5*oSize[0])-6-_boxHingeLength-0.2),(oSize[1]-(1.25*walls)),(oSize[2]-lidHeight-0.1)]) cube([(_boxHingeLength+0.4),(1.5*walls),(walls+0.1)]);
      translate([((0.5*oSize[0])+6-0.2),(oSize[1]-(1.25*walls)),(oSize[2]-lidHeight-0.1)]) cube([(_boxHingeLength+0.4),(1.5*walls),(walls+0.1)]);
      if(textRendering == 1) { __renderTexts(onlyTop=true); }
    }
    if(textRendering == 2) { __renderTexts(onlyTop=true); }
  }
}

module __insideNegative(insideSize=[10,10,10], includeDividers=true) {
  difference() {
    translate([walls,walls,walls]) cube(size=insideSize);
    if(includeDividers) {
      __renderDividers();
    }
  }
}



//    Rounded cube without minkowski
// lib/rcube.scad (https://github.com/RichardBernards/openscad/)
module __rcube(size=[1,1,1], radius=0.2) {
  assert( ((0.5*size[0]) > radius), "Width must not be larger than twice the radius" );
  assert( ((0.5*size[1]) > radius), "Depth must not be larger than twice the radius" );
  assert( ((0.5*size[2]) > radius), "Height must not be larger than twice the radius" );

  diameter = (2*radius);
  module __rsquare(_size=[1,1], _radius=0.2) {
    offset(r=_radius) { offset(delta=-_radius) { square([_size[0],_size[1]]); }}
  }
  
  union() {
    translate([radius,0,0]) rotate([90,0,90]) linear_extrude(size[0]-diameter) __rsquare([size[1],size[2]],radius); //X
    translate([0,radius,0]) rotate([-90,0,0]) linear_extrude(size[1]-diameter) translate([0,-size[2],0]) __rsquare([size[0],size[2]],radius); //Y
    translate([0,0,radius]) linear_extrude(size[2]-diameter) __rsquare([size[0],size[1]],radius); //Z
    for(zPosF = [0:1]) { for(xPosF = [0:1]) { for(yPosF = [0:1]) {
      translate([(radius+(xPosF*(size[0]-diameter))),(radius+(yPosF*(size[1]-diameter))),(radius+(zPosF*(size[2]-diameter)))]) sphere(r=radius);
    }}}
  }
}

module flipbox() {
  _lidDepth = (oSize[1] + (2*walls) + clearance);
  module __boxSlantRemoval() {
    _slantingHeight = 20;
    translate([0,(oSize[1]+walls),(oSize[2]-_slantingHeight)]) rotate([90,0,0]) linear_extrude(oSize[1]+(2*walls)) polygon([ [-0.1,0],[0,0],[(oSize[0]-(4*walls)),(_slantingHeight-walls-0.01)],[(oSize[0]-walls),(_slantingHeight-walls-0.01)],[(oSize[0]-walls),(_slantingHeight+0.1)],[-0.1,(_slantingHeight+0.1)] ]);
  }
  //box
  difference() {
    union() {
      __rcube(oSize, fillet);
      //bumps
      bBumpLoc = [[(oSize[0]-15),(oSize[2]-9)],[(oSize[0]-15),(oSize[2]-12)]];
      for(bBLoc = bBumpLoc) {
        translate([bBLoc[0],0,bBLoc[1]]) sphere(r=0.5);
        translate([bBLoc[0],oSize[1],bBLoc[1]]) sphere(r=0.5);
      }
    }
    __insideNegative(iSize);
    __boxSlantRemoval();
    translate([((2*hingeRadius)+0.2),-(2*walls),((2*hingeRadius)+0.2)]) rotate([-90,0,0]) cylinder(r=hingeRadius, h=(oSize[1]+(4*walls)));
  }
  //lid
  translate([0,(oSize[1]+5-(0.5*clearance)),0]) difference() {
    union() {
      __rcube([oSize[0],_lidDepth,oSize[2]], fillet);
      if(textRendering == 2) { __renderTexts(); }
    }
    translate([-(2*walls),(0.5*clearance),0]) __insideNegative([oSize[0],(oSize[1]+clearance),oSize[2]], false);
    translate([(oSize[0]-((2*hingeRadius)+0.4)-walls),-(2*walls),(oSize[2]-((2*hingeRadius)+0.2))]) rotate([-90,0,0]) cylinder(r=hingeRadius, h=(_lidDepth+(4*walls)));
    if(slantedOutside) {
      translate([0,(_lidDepth+(2*walls)),0]) rotate([90,0,0]) linear_extrude(_lidDepth+(4*walls)) polygon([ [-0.1,(walls+14)],[(oSize[0]-walls-14),(oSize[2]+0.1)],[-0.1,(oSize[2]+0.1)] ]);
    }
    if(textRendering == 1) { __renderTexts(); }

    //bumps
    bBumpLoc = [[15,9],[15,12]];
    for(bBLoc = bBumpLoc) {
      translate([bBLoc[0],walls,bBLoc[1]]) sphere(r=0.5);
      translate([bBLoc[0],(_lidDepth-walls),bBLoc[1]]) sphere(r=0.5);
    }
  }
}