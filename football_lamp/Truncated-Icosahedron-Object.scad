
/*
2012 Lukas Süss aka mechadense
license: cc by

Truncated Icosahedron (de: Ikosaederstumpf)

Print: 20 Hexagons & 12 Pentagons
then glue the parts together

Todo: add pins or dowels for reversible construction
( add holes for pepper & salt :) )
*/



module tio(s,t) {


// Math:

//enclosing sphere of ikosahedron:
r_encikosa = s/4*sqrt(58+18*sqrt(s));
//enclosing sphere of trunkated ikosahedron (Wikipedia is wrong!! 2012-12-06)
r_circum = (s*3)*1/6*sqrt(29/2+9/2*sqrt(5)); // why??

r_edges = 3/4*s*(1+sqrt(5));
r = r_circum;
echo("r",r);

gray = 0.7;
rhex = s;
rpent = (s/2)/cos(54);

hhex =  sqrt(pow(r,2)-pow(rhex,2))-2.3*0; // why not????
hpent = sqrt(pow(r,2)-pow(rpent,2));

hexhex = acos(-1/3*sqrt(5)); 
hexpent = acos( -sqrt( (5+2*sqrt(5)) / 15 ) );

// angel hex-center to hex-center from body-center
hh = (180-90-hexhex/2)*2; 
// angel hex-center to pent-center from body center
hp = atan(rhex*cos(30)/hhex)+atan(rpent*cos(72/2)/hpent); 
// angel pent-center to pent-center from body center
pp = 2*atan(rpent/hpent) + 2*atan((s/2)/(hhex/cos(hh/2))); // nice!




// ###################### TINKER:
// base building blocks:
// Mess with this here to change the outer shape

module six()
{
  color("white")
  intersection()
  {
     cylinder(r1=rhex,r2=0,h=hhex,$fn=6);
     cube([2*s,2*s,2*t],center=true);
  }
}
module five()
{
  color([gray,gray,gray]) 
  intersection()
  {
     cylinder(r1=rpent,r2=0,h=hpent,$fn=5);
     cube([2*s,2*s,2*t],center=true);
  }
}

module part_demo()
{
  translate([2*s,0,0]) six();
  five();
}


module whole_demo(e=0)
{
  {
    trunkiko_hex(e);
    trunkiko_pent(e);
  }
}


// ############# 

module trunkiko_pent(e=0)
{
  penthalve(e);
  rotate(60,[0,0,1]) scale([1,1,-1]) 
  penthalve(e);
}

module trunkiko_hex(e=0)
{
  hexagonhalve(e);
  rotate(60,[0,0,1]) scale([1,1,-1]) 
  hexagonhalve(e);
}

// ############### intermediate assemblies

module penthalve(e)
{
  rotate(-120,[0,0,1]) pentsixth(e);
  rotate(   0,[0,0,1]) pentsixth(e);
  rotate(+120,[0,0,1]) pentsixth(e);
}

// ############## basic assemblies

module pentsixth(e)
{
  // 2Pentagons (rotate 120° & 270° then mirror)
  rotate(-hp,[1,0,0]) rotate(-90,[0,0,1]) 
  translate([0,0,-hpent-e]) five();
  rotate(-hp-pp,[1,0,0]) rotate(+90,[0,0,1]) 
  translate([0,0,-hpent-e]) five();
}

// 10Hexagons
// (a manual semisystematic construction)
module hexagonhalve(e) 
{
  translate([0,0,-hhex-e]) six();
  // #######
  rotate(hh,[1,0,0])
  translate([0,0,-hhex-e]) six();
  // --
  rotate(-60,[0,0,1]) rotate(-hh,[1,0,0]) rotate(60,[0,0,1])
  translate([0,0,-hhex-e]) six();
  // --
  rotate(-120,[0,0,1]) rotate(hh,[1,0,0]) rotate(120,[0,0,1])
  translate([0,0,-hhex-e]) six();
  // ########
  rotate(hh,[1,0,0])
  rotate(-60,[0,0,1]) rotate(hh,[1,0,0]) rotate(60,[0,0,1])
  translate([0,0,-hhex-e]) six();
  // --
  rotate(hh,[1,0,0])
  rotate(-120,[0,0,1]) rotate(-hh,[1,0,0]) rotate(120,[0,0,1])
  translate([0,0,-hhex-e]) six();
  // ####
  rotate(-60,[0,0,1]) rotate(-hh,[1,0,0]) rotate(60,[0,0,1])
  rotate(-hh,[1,0,0])
  translate([0,0,-hhex-e]) six();
  // --
  rotate(-60,[0,0,1]) rotate(-hh,[1,0,0]) rotate(60,[0,0,1])
  rotate(-120,[0,0,1]) rotate(-hh,[1,0,0]) rotate(120,[0,0,1])
  translate([0,0,-hhex-e]) six();
  // ####
  rotate(-120,[0,0,1]) rotate(hh,[1,0,0]) rotate(120,[0,0,1])
  rotate(-hh,[1,0,0])
  translate([0,0,-hhex-e]) six();
  // --
  rotate(-120,[0,0,1]) rotate(hh,[1,0,0]) rotate(120,[0,0,1])
  rotate(-60,[0,0,1]) rotate(hh,[1,0,0]) rotate(60,[0,0,1])
  translate([0,0,-hhex-e]) six();
}

whole_demo(0);

}


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

module cables() {
 translate([0,50,-52]) rotate ([90,0,0]) cylinder (h = 30, r=3, center = true, $fn=100);
}
module cables2() {
	union() {
 		translate([0,50,-52]) rotate ([90,0,0]) cylinder (h = 30, r=4, center = true, $fn=100);
	   translate([-4,35,-62])  cube ([8,30,10]);
	}
}

// #################################### MAIN PARAMETERS
//s = 30; // basic edgelenth!
//t = 2; // maximal thickness of hull 
// ###################################
module inner() {
	union() {
		// ball
		difference() {
			tio(15,1);			
			translate([0,0,-45])octagon(28,25);
		}
		// lower hull
		difference() {
			translate([0,0,-50])octagon(96,15);
			translate([0,0,-49])octagon(94,17);
			# cables();
		}
		// floor
		translate([0,0,-57])octagon(100,2);
		// shaft
		difference() {
			translate([0,0,-45])octagon(30,25);
			translate([0,0,-45])octagon(28,27);
		}
	}
}

module outer() {
	union() {
		difference() {
			tio(30,1);
			translate([0,0,-50])octagon(100,50);
		}	
	   color("black")
		difference() {
			translate([0,0,-50])octagon(100,15);
			translate([0,0,-50])octagon(98,32);
			# cables2();
		}
	}	
}
//
module demo() {
	difference() {
		union() {
			outer();
			inner();
		}
		translate([50,50,0]) cube(size = [100,100,300], center = true);
	}
}

demo()
//inner();
//outer();

% translate([100,0,0]) cube([100,10,10]);// size estimation cube

//hexagon_printplate();
//pentagon_printplate();
//part_demo();
