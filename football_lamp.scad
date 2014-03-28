phi = (1+sqrt(5))/2; 

coords = [ 
        [0,+1,+3*phi], [0,+1,-3*phi], [0,-1,+3*phi], [0,-1,-3*phi], 
        [+1,+3*phi,0], [+1,-3*phi,0], [-1,+3*phi,0], [-1,-3*phi,0], 
        [+3*phi,0,+1], [+3*phi,0,-1], [-3*phi,0,+1], [-3*phi,0,-1], 

        [+2,+(1+2*phi),+phi], [+2,+(1+2*phi),-phi], [+2,-(1+2*phi),+phi], [+2,-(1+2*phi),-phi], 
        [-2,+(1+2*phi),+phi], [-2,+(1+2*phi),-phi], [-2,-(1+2*phi),+phi], [-2,-(1+2*phi),-phi], 

        [+(1+2*phi),+phi,+2], [+(1+2*phi),+phi,-2], [+(1+2*phi),-phi,+2], [+(1+2*phi),-phi,-2], 
        [-(1+2*phi),+phi,+2], [-(1+2*phi),+phi,-2], [-(1+2*phi),-phi,+2], [-(1+2*phi),-phi,-2], 

        [+phi,+2,+(1+2*phi)], [+phi,+2,-(1+2*phi)], [+phi,-2,+(1+2*phi)], [+phi,-2,-(1+2*phi)], 
        [-phi,+2,+(1+2*phi)], [-phi,+2,-(1+2*phi)], [-phi,-2,+(1+2*phi)], [-phi,-2,-(1+2*phi)], 

        [+1,+(2+phi),+2*phi], [+1,+(2+phi),-2*phi], [+1,-(2+phi),+2*phi], [+1,-(2+phi),-2*phi], 
        [-1,+(2+phi),+2*phi], [-1,+(2+phi),-2*phi], [-1,-(2+phi),+2*phi], [-1,-(2+phi),-2*phi], 

        [+(2+phi),+2*phi,+1], [+(2+phi),+2*phi,-1], [+(2+phi),-2*phi,+1], [+(2+phi),-2*phi,-1], 
        [-(2+phi),+2*phi,+1], [-(2+phi),+2*phi,-1], [-(2+phi),-2*phi,+1], [-(2+phi),-2*phi,-1], 

        [+2*phi,+1,+(2+phi)], [+2*phi,+1,-(2+phi)], [+2*phi,-1,+(2+phi)], [+2*phi,-1,-(2+phi)], 
        [-2*phi,+1,+(2+phi)], [-2*phi,+1,-(2+phi)], [-2*phi,-1,+(2+phi)], [-2*phi,-1,-(2+phi)], 
]; 


// size is the XY plane size, height in Z
module hexagon(size, height) {
  boxWidth = size/1.75;
  for (r = [-60, 0, 60]) rotate([0,0,r]) cube([boxWidth, size, height], true);
}
module octagon(size, height) {
  intersection() {
    cube([size, size, height], true);
    rotate([0,0,45]) cube([size, size, height], true);
  }
}


module soccerBall(size) {
	hull() { 
        for (a = [0 : len(coords) - 1]) { 
                echo(coords[a]); 
                translate(size * coords[a]) cube([0.1, 0.1, 0.1], center = true); 
        } 
	} 
}
module outerHull(outer,inner) {
	difference() {
  	 	difference() {soccerBall(outer); soccerBall(inner);}

		translate([0,0,-35]) octagon(55,20);
	}
}

module lowerHull() {
	difference() {
		difference() {
			translate([0,0,-30]) octagon(55,10);
			translate([0,0,-30]) octagon(53,8);
		}
		translate([0,0,-28]) octagon(50,10);
	}
}

module innerBody() {
 union() {
		difference() {
			difference() {soccerBall(3); soccerBall(2.9);}
			translate([0,0,-35]) {cylinder(h = 25, r1 = 5, r2 = 5);}
		}
		difference() {
			translate([0,0,-35]) {
				difference() {
					cylinder(h = 25, r1 = 6, r2 = 6); 
					cylinder(h = 25, r1 = 5, r2 = 5);
				} 
			}
			soccerBall(2.9);
		}
		lowerHull();
   }
}

//translate([0,0,35]) outerHull(8,7.90);
//translate([0,0,35]) innerBody();


translate([0,0,35])difference() {
	outerHull(8,7.9);
	translate([25,25,0]) cube(size = [50,50,100], center = true);
}


translate([0,0,35])difference() {
	innerBody();
	translate([25,25,0]) cube(size = [50,50,100], center = true);
}







/*
	translate([0,0,20]) cube(size = [5,5,20], center = true);
}
*/
