//
//    Rounded cube without minkowski
// lib/rcube.scad (https://github.com/RichardBernards/openscad/)
//
// Copyright Richard Bernards
//
// LICENSE: CC BY-NC 4.0
// This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.
// To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc/4.0/>
// or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  [Usage]
//      use <rcube.scad>
//      rcube([100,50,50],5);
//
//  [Parameters] (parameter names are optional)
//      size    Array of dimensions; [width, depth, height]
//      radius  Radius for filleting the edges of the cube in mm
//
//  [Example]
//      rcube();
//      rcube([100,50,50],5);
//      rcube(size=[100,50,50], radius=5);
//
//  [Version history]
//      v1.0.0    2025-10-15    Release version
//

rcube();
translate([20,0,0]) rcube([10,5,5],1);
translate([40,0,0]) rcube(size=[5,10,20], radius=1);


module rcube(size=[10,10,10], radius=2) {
  assert( ((0.5*size[0]) > radius), "Width must not be larger than twice the radius" );
  assert( ((0.5*size[1]) > radius), "Depth must not be larger than twice the radius" );
  assert( ((0.5*size[2]) > radius), "Height must not be larger than twice the radius" );

  diameter = (2*radius);
  module __rsquare(_size=[10,10], _radius=2) {
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