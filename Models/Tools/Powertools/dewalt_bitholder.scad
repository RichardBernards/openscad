//
//    DeWalt bitholder for battery powered tools
// Models/Tools/Powertools/Bitholder/dewalt.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v3.0.0    2025-11-06    Start new and better customizable version
//

/* [Settings] */
// Bitholder block width in mm
bWidth = 50;
// Bitholder height in mm
bHeight = 20.5;


/* [Clamp Settings] */
// Clamp outer radius in mm
cOrad = 5.1;
// Clamp inner radius in mm
cIrad = 3.5;
// Clamping gap (outer reference) in mm
cGap = 4.9;
// Individual clamp height in mm
cHeight = 7.1;

/* [Advanced Settings] */
// Fillet radius in mm
fil = 0.6;
bDepth = 6.5;
bRad = 2;
bIndentHeight = 11.7;
bIndentOffset = 4;
// Clamp offset positions in mm
clampPositionsString = "3,14,25,36,47";


/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;


//_clamp();
//_bracket();

bitholder();



module bitholder() {
  union() {
    _bracket();
    clampPositions = split(clampPositionsString,",");
    for(clampOffset = clampPositions) {
      translate([-((0.5*bWidth)-strtoint(clampOffset)),-cIrad,0]) _clamp();
      translate([-((0.5*bWidth)-strtoint(clampOffset)),-cIrad,(bHeight-cHeight)]) _clamp();
    }
  }
}

module _bracket() {
  module __bluePrint() {
    offset(r=fil) { offset(delta=-fil) { difference() {
      offset(r=fil) { offset(delta=-fil) { translate([0,-bHeight]) square([bDepth,bHeight]); }}
      offset(r=bRad) { offset(delta=-bRad) { translate([bIndentOffset,-(bIndentHeight + (0.5*(bHeight-bIndentHeight)))]) square([(3*bRad),bIndentHeight]); }}
    }}}
  }
  union() {
    translate([-5,6.4,17.1]) __dewaltClip();
    difference() {
      translate([(0.5*bWidth),0,0]) rotate([-90,0,90]) union() {
        minkowski() {
          translate([0,0,fil]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
          sphere(r=fil);
        }
        translate([0,0,fil]) linear_extrude(bWidth-(2*fil)) __bluePrint();
        minkowski() {
          translate([0,0,(bWidth-1-fil)]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
          sphere(r=fil);
        }
      }
      translate([((0.5*bWidth)-4),2,2]) cp();
      translate([-((0.5*bWidth)-4),2,2]) cp();
      //screwhole
      translate([-5,-0.1,10.25]) rotate([-90,0,0]) cylinder(h=0.9, d=6.4);
      translate([-5,-0.1,10.25]) rotate([-90,0,0]) cylinder(h=5.2, d=3.3);
    }
  }
}

module _clamp() {
  module __bluePrint() {
    offset(r=fil) { offset(delta=-fil) {
      difference() {
        circle(r=cOrad);
        circle(r=cIrad);
        polygon([ [0,0], [-(0.5*cGap),-(cOrad+0.01)], [(0.5*cGap),-(cOrad+0.01)] ]);
      }
    }}
  }
  
  union() {
    minkowski() {
      translate([0,0,fil]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
      sphere(r=fil);
    }
    translate([0,0,fil]) linear_extrude(cHeight-(2*fil)) __bluePrint();
    minkowski() {
      translate([0,0,(cHeight-fil-1)]) linear_extrude(1) offset(delta=-fil) { __bluePrint(); }
      sphere(r=fil);
    }
  }
}

module __dewaltClipPart() {
  union() {
    polygon([ [0,0],[6.3,0],[4.96,3.1],[4.19,3.7],[0.8,3.7],[0,2.9] ]);
    translate([4.19,2.9]) circle(r=0.8);
    translate([0.8,2.9]) circle(r=0.8);
  }
}
module __dewaltClip() {
  union() {
    translate([2.05,1.8,0]) linear_extrude(1.8) __dewaltClipPart();
    translate([-2.05,1.8,1.8]) rotate([0,180,0]) linear_extrude(1.8) __dewaltClipPart();
    translate([-8.35,0,0]) cube([16.7,1.8,1.8]);
  }
}
module cp(l=1){module _p(){hull(){linear_extrude(0.01) polygon([[0,0],[l,0],[0.5*l,l]]);translate([0.5*l,0,l]) cube(0.01);translate([0.5*l,l,-l]) cube(0.01);}}union(){_p();translate([0.6*l,l,0]) mirror([0,1,0])_p();}}
//splitter = function(s, sep=",")


//function stringSplit (s, sep=",", i=0) = (
//  );

//testString = "3,14,25,36,47";
//  
//output = [ for(c = [0:1:len(testString)-1]) (testString[c] == "," ? "-" : testString[c]) ];
//echo(output=output);
//
//b=0;
//newoutput = [ for(pos = [0:1:len(testString)-1]) {
//  if(testString[pos] == ",") {
//    for(i=[b:1:(pos-1)]) {
//    }
//  }
//} ];




join = function (l,delimiter="") 
  let(s = len(l), d = delimiter,
      jb = function (b,e) let(s = e-b, m = floor(b+s/2)) // join binary
        s > 2 ? str(jb(b,m), jb(m,e)) : s == 2 ? str(l[b],l[b+1]) : l[b],
      jd = function (b,e) let(s = e-b, m = floor(b+s/2))  // join delimiter
        s > 2 ? str(jd(b,m), d, jd(m,e)) : s == 2 ? str(l[b],d,l[b+1]) : l[b])
  s > 0 ? (d=="" ? jb(0,s) : jd(0,s)) : "";

substr = function(s,b,e) let(e=is_undef(e) || e > len(s) ? len(s) : e) (b==e) ? "" : join([for(i=[b:1:e-1]) s[i] ]);

split = function(s,separator=" ") separator=="" ? [for(i=[0:1:len(s)-1]) s[i]] :
  let(t=separator, e=len(s), f=len(t),
    _s=function(b,c,d,r) b<e ?
      (s[b]==t[c] ?
        (c+1 == f ?
          _s(b+1,0,b+1,concat(r,substr(s,d,b-c))) : // full separator match, concat substr to result
          _s(b+1,c+1,d,r) ) : // separator match char, more to test
        _s(b-c+1,0,d,r) ) : // separator mismatch
      concat(r,substr(s,d,e))) // end of input string, return result
  _s(0,0,0,[]);
  
function strtoint (s, ret=0, i=0) =
  i >= len(s)
  ? ret
  : strtoint(s, ret*10 + ord(s[i]) - ord("0"), i+1);