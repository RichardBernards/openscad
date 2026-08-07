//
//    Wall hook
// Models/Home/Storage/wallhook.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Version history]
//      v2.0.0    2026-08-07    New and improved version
//      v1.0.0    2024-12-30    Initial model version
//

/* [Wall hook] */
// Width of wallhook in mm
width = 20;
// Depth (portrusion) of wallhook in mm
depth = 80;
// Height of wallhook in mm
height = 200;
// Thickness of wallhook in mm
thick = 12;
// Chamfer in mm
chamfer = 1;
// Screw diameter and Screwhead diameter in mm
screw = [3.6, 6.8];

/* [Hidden] */
// renderSetting 1
$fs = 0.2;
// renderSetting 2
$fa = 2;

use <ub.scad>;


wallhook(
  width=width,
  depth=depth,
  height=height,
  thick=thick,
  chamfer=chamfer,
  screw=screw
);


module wallhook(width=20, depth=80, height=200, thick=12, chamfer=1, screw=[3.6,6.8]) {
  part = (height/4);
  module _chamferedModel() {
    union() {
      hull() {
        linear_extrude(0.01) offset(delta=-chamfer) { hull() {
          T((depth-(0.5*thick)),(height-(0.5*thick)))circle(d=thick);
          T((0.5*thick),(height-part-(0.5*thick)))circle(d=thick);
        }}
        Tz(chamfer)linear_extrude(width-(2*chamfer)) hull() {
          T((depth-(0.5*thick)),(height-(0.5*thick)))circle(d=thick);
          T((0.5*thick),(height-part-(0.5*thick)))circle(d=thick);
        }
        Tz(width-0.01)linear_extrude(0.01) offset(delta=-chamfer) { hull() {
          T((depth-(0.5*thick)),(height-(0.5*thick)))circle(d=thick);
          T((0.5*thick),(height-part-(0.5*thick)))circle(d=thick);
        }}
      }
      hull() {
        linear_extrude(0.01) offset(delta=-chamfer) { hull() {
          T((0.5*thick),(height-part-(0.5*thick)))circle(d=thick);
          T((0.5*thick),(0.5*depth))circle(d=thick);
        }}
        Tz(chamfer)linear_extrude(width-(2*chamfer))hull() {
          T((0.5*thick),(height-part-(0.5*thick)))circle(d=thick);
          T((0.5*thick),(0.5*depth))circle(d=thick);
        }
        Tz(width-0.01)linear_extrude(0.01) offset(delta=-chamfer) { hull() {
          T((0.5*thick),(height-part-(0.5*thick)))circle(d=thick);
          T((0.5*thick),(0.5*depth))circle(d=thick);
        }}
      }
      T((0.5*depth),(0.5*depth))rotate_extrude(angle=180) polygon([
        [-((0.5*depth)-chamfer),0],
        [-(0.5*depth),chamfer],
        [-(0.5*depth),(width-chamfer)],
        [-((0.5*depth)-chamfer),width],
        [-((0.5*depth)-thick+chamfer),width],
        [-((0.5*depth)-thick),(width-chamfer)],
        [-((0.5*depth)-thick),chamfer],
        [-((0.5*depth)-thick+chamfer),0]
      ]);
      hull() {
        linear_extrude(0.01) offset(delta=-chamfer) { T((depth-(0.5*thick)),(0.5*depth))circle(d=thick); }
        Tz(chamfer)linear_extrude(width-(2*chamfer)) T((depth-(0.5*thick)),(0.5*depth))circle(d=thick);
        Tz(width-0.01)linear_extrude(0.01) offset(delta=-chamfer) { T((depth-(0.5*thick)),(0.5*depth))circle(d=thick); }
      }
    }
  }
  module _screwCut(d,dH) {
    R(0,90)Tz(-(dH-d))union() {
      Tz(-19.99)cylinder(d=d, h=20);
      rotate_extrude() { polygon([ [0,0], [(0.5*d),0], [(0.5*dH), (dH-d)], [0, (dH-d)] ]); }
      Tz(dH-d-0.01)cylinder(d=dH, h=20);
    }
  }

  difference() {
    _chamferedModel();
    T(thick,(height-part-10-screw[1]),(0.5*width))_screwCut(screw[0],screw[1]);
    T(thick,((0.5*depth)+thick+10+screw[1]),(0.5*width))_screwCut(screw[0],screw[1]);
  }
}