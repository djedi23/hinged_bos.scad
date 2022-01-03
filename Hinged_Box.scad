// -*- mode: scad; tab-width: 2 -*-

// Parametric Hinged Box With Latch and Logos and Printable In One Piece.
// Remix from https://www.thingiverse.com/thing:82533 and https://www.thingiverse.com/thing:82620
// by Mose Valvassori <moise.valvassori@gmail.com>. 2021
// v1.0.0 first publish
// v1.0.1 fixing buckle holder postion

latchType = 1; // [0:latch,1:buckle,2:magnet]
/* [Basic Sizes] */
// Width of the box. (Outside)
width = 40; //[5:0.1:100]
// Depth of the box. (Outside)
depth = 40;//[5:0.1:250]
// Height of the box. (Outside)
height = 15;//[5:0.1:200]
wallThickness = 1.5;
/* [Logo] */
// Top logo filename. When empty, no logo displayed. Dxf or SVG file expected.
topLogoFilename="t_drawing.svg"; //No Logo
// Logo scaling. 1: full size
topLogoScale = 0.5; // [0:0.01:1]
// Bottom logo filename. When empty, no logo displayed. Dxf or SVG file expected.
bottomLogoFilename="b_drawing.svg"; //No Logo
// Logo scaling. 1: full size
bottomLogoScale = 0.5; // [0:0.01:1]
/* [Latch] */
latchWidth = 8;

/* [Magnet] */
magnetPosition = 0; // [0:Out, 0.5:Center, 1:In]
magnetDiameter = 8;
magnetHeight = 0.9;

/* [Advanced] */
// 3D print layer height
layerHeight = 0.3; // [0.3, 0.2, 0.15, 0.10, 0.07, 0.05]
// layerHeight or wallThickness / logoInsetDivisor
logoInsetDivisor = 0.0; // [0.0:layerHeight, 1.5:3/2, 2.0:2, 3.0:3, 4.0:4, 5.0:5]
hingeOuter = 7;
hingeInner = 4;
hingeInnerSlop = .4;
hingeFingerSlop = .4;
fingerLength = hingeOuter/1.65;
fingerSize = 6.5;
topFingerSize = fingerSize;
magnetSlop = 0.5;


/* [Hidden] */
logoInsetHeight = logoInsetDivisor > 0 ? wallThickness / logoInsetDivisor : layerHeight;
$fn = 100;

bottom();
top();
if (latchType == 1)
	bucklebuckleBottom();

module bottom() {
	union() {
		// main box and cutout
		difference() {
			translate([-width - fingerLength, -depth/2, 0]) {
				cube([width,depth,height]);
			}
			translate([(-width - fingerLength) + wallThickness, -depth/2 + wallThickness, wallThickness]) {
				cube([width - (wallThickness * 2), depth - (wallThickness * 2), height]);
			}

			if (latchType == 0)
				originalLatchCutout();

			if (bottomLogoFilename)
				 BottomLogo();
		}

		if (latchType == 0)
			originalLatchCylinder();
		else if (latchType == 1)
			buckleBottom();
		else if (latchType == 2)
			magnetBottom();

		difference() {
			hull() {
				translate([0,-depth/2,height]) {
					rotate([-90,0,0]) {
						cylinder(r = hingeOuter/2, h = depth);
					}
				}
				translate([-fingerLength - .1, -depth/2,height - hingeOuter]){
					cube([.1,depth,hingeOuter]);
				}
				translate([-fingerLength, -depth/2,height-.1]){
					cube([fingerLength,depth,.1]);
				}
				translate([0, -depth/2,height]){
					rotate([0,45,0]) {
						cube([hingeOuter/2,depth,.01]);
					}
				}
			}
			// finger cutouts

			for  (i = [-depth/2 + fingerSize:fingerSize*2:depth/2]) {
				translate([-fingerLength,i - (fingerSize/2) - (hingeFingerSlop/2),0]) {
					cube([fingerLength*2,fingerSize + hingeFingerSlop,height*2]);
				}
			}
		}

		// center rod
		translate([0, -depth/2, height]) {
			rotate([-90,0,0]) {
				cylinder(r = hingeInner /2, h = depth);
			}
		}
	}
}

module originalLatchCutout(){
	// latch cutout
	translate([-width - fingerLength + (wallThickness/2), (-latchWidth/2) - (hingeFingerSlop/2), wallThickness]) {
		cube([wallThickness/2 + .1, latchWidth + hingeFingerSlop, height]);
	}
}

module originalLatchCylinder(){
	//latch cylinder
	difference() {
		translate([-width - fingerLength + (wallThickness/2), -latchWidth/2, height - 1]) {
			rotate([-90,0,0]) {
				cylinder(r = 1, h = latchWidth);
			}
		}
		// front wall wipe
		translate([-width - fingerLength - 5, -depth/2,0]) {
			cube([5,depth,height]);
		}
	}
}

module buckleBottom(){
	// new latch
	difference() {
		hull() {
			translate([-(fingerLength*2) - width,-latchWidth,height-2.25]) {
				rotate([-90,0,0]) {
					cylinder(r = hingeOuter/2, h = latchWidth*2);
				}
			}
			translate([-width - fingerLength, -latchWidth, height-hingeOuter-2.25]) {
				cube([.1, latchWidth * 2, hingeOuter]);
			}
			translate([-(fingerLength*2) -width, -latchWidth,height-2.25]){
				cube([fingerLength,latchWidth * 2,.1]);
			}
			translate([-(fingerLength*2) -width, -latchWidth,height-2.25]){
				rotate([0,-20,0]) {
					cube([hingeOuter-wallThickness,latchWidth*2,.01]);
				}
			}
		}
		translate([-(fingerLength*3) - width, -(latchWidth/2) - hingeFingerSlop,0]) {
			cube([fingerLength*3, latchWidth + hingeFingerSlop * 2,height*2]);
		}
	}
	// latch rod
	translate([-(fingerLength*2) -width, -latchWidth/2 - hingeFingerSlop, height-2.25]) {
		rotate([-90,0,0]) {
			cylinder(r = hingeInner /2, h = latchWidth + (hingeFingerSlop*2));
		}
	}
}


module bucklebuckleBottom() {
	difference() {
		union() {
			hull() {
				translate([-(fingerLength *2) - width,-latchWidth/2,height-2.25]) {
					rotate([-90,0,0]) {
						cylinder( r = hingeOuter /2, h = latchWidth);
					}
				}
				translate([-fingerLength*2 - width,-latchWidth/2,height-hingeOuter-2.25]) {
					rotate([0,20,0]) {
						cube([.1,latchWidth,hingeOuter]);
					}
				}

			}
			translate([-fingerLength*2 - width -2.6 + hingeOuter/2 - wallThickness,-latchWidth/2,0]) {
				cube([2.5,latchWidth,height-4.5]);
			}
			// latch foot
			translate([-fingerLength*3 - width - 2.6,-latchWidth/2,0]) {
				cube([hingeOuter/2 + fingerLength,latchWidth,wallThickness]);
			}
			// latch cylinder catch
			translate([-fingerLength*3 - width + 1 - 2.6,-latchWidth/2,wallThickness]) {
				rotate([-90,0,0]) {
					cylinder(r = 1, h = latchWidth);
				}
			}
		}
		translate([-(fingerLength *2) - width,-latchWidth/2 - .1,height-2.25]) {
			rotate([-90,0,0]) {
				cylinder( r = hingeInner /2 + hingeInnerSlop, h = latchWidth + .2);
			}
		}
	}
}


module magnetBottom () {
	h = magnetHeight + magnetSlop;
	ho = h + wallThickness + layerHeight;
	d = magnetDiameter + magnetSlop;
	do = d + wallThickness*2;
	translate([wallThickness*(2-magnetPosition) -do*(1-magnetPosition)-width,0,height-ho]){
		difference(){
			union(){
				cylinder(d=do, h=ho);
				if (magnetPosition != 0.5)
					translate([-magnetPosition*do/2,-do/2,0]) cube([do/2,do,ho]);
			}
			translate([0,0,wallThickness]) cylinder(d=d, h=h);
		}

		hull() {
			union(){
				cylinder(d=do, h=magnetSlop);
				if (magnetPosition != 0.5)
				translate([-magnetPosition*do/2,-do/2,0]) cube([do/2,do,magnetSlop]);
			}
			translate([d/2-magnetPosition*(do/2+wallThickness*2),0,-do*2/3])
				scale([0.01,1/3,1])	cylinder(d=do, h=h);
		}
	}
}

module BottomLogo () {
	logoSize = min(width,depth);
	scaledLogoSize = logoSize*bottomLogoScale;

	translate ([- (fingerLength + width/2) - scaledLogoSize/2,
							depth/2 - scaledLogoSize/2,
							-logoInsetHeight]) {
		resize([scaledLogoSize,scaledLogoSize,logoInsetHeight*2]) {
			mirror([0,1,0]) linear_extrude(height = 4) import(bottomLogoFilename);
	}
}
}


////////////////////////////////////////////////////////////
//////   TOP   /////////////////////////////////////////////
////////////////////////////////////////////////////////////

module top() {
	union() {
		difference() {
			translate([fingerLength, -depth/2, 0]) {
				cube([width,depth,height - .5]);
			}

			translate([fingerLength + wallThickness, -depth/2 + wallThickness, wallThickness]) {
				cube([width - (wallThickness * 2), depth - (wallThickness * 2), height]);
			}

			if (topLogoFilename)
				TopLogo();
		}

		if (latchType == 0)
			latch();
		else if (latchType == 1)
			buckleTop();
		else if (latchType == 2)
			magnetTop();

		difference() {
			hull() {
				translate([0,-depth/2,height]) {
					rotate([-90,0,0]) {
						cylinder(r = hingeOuter/2, h = depth);
					}
				}
				translate([fingerLength, -depth/2,height - hingeOuter - .5]){
					cube([.1,depth,hingeOuter - .5]);
				}
				translate([-fingerLength/2, -depth/2,height-.1]){
					cube([fingerLength,depth,.1]);
				}
				translate([0, -depth/2,height]){
					rotate([0,45,0]) {
						cube([hingeOuter/2,depth,.01]);
					}
				}
			}
			// finger cutouts
			for  (i = [-depth/2:fingerSize*2:depth/2 + fingerSize]) {
				translate([-fingerLength,i - (fingerSize/2) - (hingeFingerSlop/2),0]) {
					cube([fingerLength*2,fingerSize + hingeFingerSlop,height*2]);
				}
				if (depth/2 - i < (fingerSize * 1.5)) {
					translate([-fingerLength,i - (fingerSize/2) - (hingeFingerSlop/2),0]) {
						cube([fingerLength*2,depth,height*2]);
					}
				}
			}

			// center cutout
			translate([0, -depth/2, height]) {
				rotate([-90,0,0]) {
					cylinder(r = hingeInner /2 + hingeInnerSlop, h = depth);
				}
			}
		}
	}
}


module latch(){
	//latch
	translate([width + fingerLength - wallThickness - 1.5, (-latchWidth/2), wallThickness]) {
		cube([1.5, latchWidth, height - .5 + 4 - wallThickness]);
	}
	translate([width + fingerLength - wallThickness, -latchWidth/2, height - .5 + 3]) {
		rotate([-90,0,0]) {
			cylinder(r = 1, h = latchWidth);
		}
	}
}

module buckleTop(){
	bt = 7.5;
	// new latch
	difference() {
		hull() {
			translate([(fingerLength*2) + width,-latchWidth, bt]) {
				rotate([-90,0,0]) {
					cylinder(r = hingeOuter/2, h = latchWidth*2);
				}
			}
			translate([width + fingerLength, -latchWidth, 0]) {
				cube([.1, latchWidth * 2, hingeOuter]);
			}
			translate([fingerLength + width, -latchWidth,bt]){
				cube([fingerLength,latchWidth * 2,.1]);
			}
			translate([fingerLength + width, -latchWidth,bt + (hingeOuter/1.5)]){
				rotate([0,45,0]) {
					cube([hingeOuter,latchWidth*2,.01]);
				}
			}
		}
		translate([fingerLength + width, -(latchWidth/2) - hingeFingerSlop,0]) {
			cube([fingerLength*2, latchWidth + (hingeFingerSlop * 2),height*2]);
		}
	}
	// latch rod
	translate([(fingerLength*2) + width, -latchWidth/2 - hingeFingerSlop, bt]) {
		rotate([-90,0,0]) {
			cylinder(r = hingeInner /2, h = latchWidth + (hingeFingerSlop*2));
		}
	}
}

module magnetTop () {
	h = magnetHeight + magnetSlop;
	ho = h + wallThickness + layerHeight;
	d = magnetDiameter + magnetSlop;
	do = d + wallThickness*2;
	translate([do+width - wallThickness*2 -do*magnetPosition ,0,height-ho - 0.5]){ /* Oops, this 0.5 breaks the magnet alignement... */
		difference(){
			union(){
				cylinder(d=do, h=ho);
				if (magnetPosition != 0.5)
					translate([-(1-magnetPosition)*do/2,-do/2,0]) cube([do/2,do,ho]);
			}
			translate([0,0,wallThickness]) cylinder(d=d, h=h);
		}

		hull() {
			union(){
				cylinder(d=do, h=magnetSlop);
				if (magnetPosition != 0.5)
					translate([-(1-magnetPosition)*do/2,-do/2,0]) cube([do/2,do,magnetSlop]);
			}
			translate([-d/2+magnetPosition*(do-wallThickness),0,-do*2/3])
				scale([0.01,1/3,1])	cylinder(d=do, h=h);
		}
	}
}



module TopLogo () {
	logoSize = min(width,depth);
	scaledLogoSize = logoSize*topLogoScale;

	translate ([fingerLength + width/2 - scaledLogoSize/2,
							depth/2 - scaledLogoSize/2,
							-logoInsetHeight]) {
		resize([scaledLogoSize,scaledLogoSize,logoInsetHeight*2]) {
			mirror([0,1,0])	linear_extrude(height = 4) import(topLogoFilename);
		}
	}
}
