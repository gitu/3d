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

		translate([0,0,35]) octagon(55,20);
		//translate([0,0,50]) cube(size = [50,50,50], center = true);
	}
}

module lowerHull() {
	difference() {
		difference() {
			translate([0,0,30]) octagon(55,10);
			translate([0,0,30]) octagon(53,8);
		}
		translate([0,0,28]) octagon(50,10);
	}
}

module innerBody() {

 union() {
		difference() {
			difference() {soccerBall(3); soccerBall(2.9);}
			translate([0,0,10]) {cylinder(h = 20, r1 = 5, r2 = 5);}
		}
		difference() {
			translate([0,0,10]) {
				difference() {
					cylinder(h = 25, r1 = 6, r2 = 6); 
					cylinder(h = 25, r1 = 5, r2 = 5);
				} 
			}
			soccerBall(2.9);
		}
		lowerHull();
/*
		difference() {
			translate([0,0,20]) {
				difference() {
					translate([-25,-25,-10]) cube(size = [50,50,20]);
					translate([0,0,-2]) cube(size = [48,48,22], center = true);
				}
			}
			outerHull(8,0);
		}  */
   }
}

	outerHull(8,7.90);
	innerBody();

/*
difference() {
	outerHull(8,7.9);
	translate([25,25,0]) cube(size = [50,50,100], center = true);
}

difference() {
	innerBody();
	translate([25,25,0]) cube(size = [50,50,100], center = true);
}*/







/*
	translate([0,0,20]) cube(size = [5,5,20], center = true);
}
*/
