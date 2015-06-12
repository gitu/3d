// Based on http://www.thingiverse.com/thing:27452/

boxWidth = 140;
boxHeight = 50;
boxDepth = 80;
screenSize = 50;
materialThickness = 3;
offset = 3; // for lasercutter beam width


nutWidth	= 5.5;
nutHeight 	= 12;
boltWidth = 5.5;
boltLength = 15;
plugWidth = 15;
plugHeight = materialThickness;
spaceAroundBolt = plugWidth*0.5;



f = 1; // fix for overlapping edges issue
c = 30; //cornerResolution ($fn)
s = 1;//seperator dis.


zplate_width = boxWidth-materialThickness*2;
zplate_height = boxDepth-materialThickness*4;

xplate_width = boxWidth-materialThickness*2;
xplate_heigth = boxHeight;

//export();
assembly3D();
//front();
//top();
//bottom();
//zConnectors();
//xplate();

module export()
{
	bottom();
	translate([boxWidth+s,0,0]) top();
	translate([2*(boxWidth+s),0,0]) top_milk();
    
	translate([0,boxDepth+s,0]) front();
	translate([boxWidth+s,boxDepth+s,0]) back();

	translate([0,boxDepth+s+boxHeight+s*4,0]) left();
	translate([boxDepth+s*4,boxDepth+s+boxHeight+s*4,0]) right();
}
module assembly3D()
{
	translate([materialThickness,materialThickness*1.5,0]) rotate([90,0,0]) black() front();
	//translate([materialThickness,boxDepth-materialThickness*1.5,0]) rotate([90,0,0]) black() back();
	translate([materialThickness/2,0,0]) rotate([90,0,90]) black() left();
	//translate([boxWidth-materialThickness/2,0,0]) rotate([90,0,90]) black() right();
	color("Green") translate([materialThickness,materialThickness*2,materialThickness*2]) black() bottom();
	translate([materialThickness,materialThickness*2,boxHeight-materialThickness*2]) milk(0.5) top_milk();
	color("Green") translate([materialThickness,materialThickness*2,boxHeight-materialThickness*3]) black() top();
}
module zplate() {    
	translate([0,0,0]) 
    difference()
	{
        square([zplate_width,zplate_height]);
	}
}
module yplate() {
    translate([0,0,0])
	difference()
	{
		square([boxDepth,boxHeight]);
        translate([boxDepth-materialThickness*2-plugWidth/2,materialThickness*1.5]) connHoleSimple(plugWidth,plugHeight);
        translate([materialThickness*2+plugWidth/2,materialThickness*1.5]) connHoleSimple(plugWidth,plugHeight);
        translate([boxDepth-materialThickness*2-plugWidth/2,boxHeight-materialThickness*3.5]) connHoleSimple(plugWidth,plugHeight);
        translate([materialThickness*2+plugWidth/2,boxHeight-materialThickness*3.5]) connHoleSimple(plugWidth,plugHeight);
        translate([boxDepth/2 - materialThickness*2+plugWidth/2,boxHeight-materialThickness*2.5]) connHoleSimple(plugWidth,plugHeight);
	}
}
module xplate() {
    translate([0,0,0]) 
	difference()
	{
		square([xplate_width,xplate_heigth]); 
        
        translate([xplate_width-materialThickness*3-plugWidth/2,materialThickness*1.5]) connHoleSimple(plugWidth,plugHeight);
        translate([materialThickness*3+plugWidth/2,materialThickness*1.5]) connHoleSimple(plugWidth,plugHeight);
        translate([xplate_width-materialThickness*3-plugWidth/2,boxHeight-materialThickness*3.5]) connHoleSimple(plugWidth,plugHeight);
        translate([materialThickness*3+plugWidth/2,boxHeight-materialThickness*3.5]) connHoleSimple(plugWidth,plugHeight);
        
        translate([xplate_width/2 - materialThickness*2+plugWidth/2,boxHeight-materialThickness*2.5]) connHoleSimple(plugWidth,plugHeight);
	}
}
module front()
{ 
    xplate();
}
module left()
{
    yplate();
}
module zConnectors() {    
    translate([-plugHeight/2,plugWidth/2]) connPlug(plugWidth,plugHeight,90);
    translate([-plugHeight/2,zplate_height-plugWidth/2]) connPlug(plugWidth,plugHeight,90);
    translate([ zplate_width,plugWidth/2]) connPlug(plugWidth,plugHeight,90);
    translate([ zplate_width,zplate_height-plugWidth/2]) connPlug(plugWidth,plugHeight,90);
    
    
    translate([plugWidth,0]) connPlug(plugWidth,plugHeight);
    translate([plugWidth,zplate_height+plugHeight/2]) connPlug(plugWidth,plugHeight);
    translate([ zplate_width-plugWidth,0]) connPlug(plugWidth,plugHeight);
    translate([ zplate_width-plugWidth,zplate_height+plugHeight/2]) connPlug(plugWidth,plugHeight);
}
module top()
{
	difference()
	{
        zplate();
        translate([zplate_width/2-screenSize/2,zplate_height/2-screenSize/2]) square([screenSize,screenSize]);
    }
    zConnectors();
}
module bottom()
{ 
    zplate();
    zConnectors();
}
module top_milk()
{
    zplate();
    translate([zplate_width/2,0]) connPlug(plugWidth,plugHeight);
    translate([zplate_width/2,zplate_height+plugHeight]) connPlug(plugWidth,plugHeight);
    translate([-plugHeight/2,zplate_height/2]) connPlug(plugWidth,plugHeight,90);
    translate([zplate_width,zplate_height/2]) connPlug(plugWidth,plugHeight,90);
}
module back()
{
	xplate();
}
module right()
{
	yplate();
}
/////////////// utils ///////////////


// plug pointing upwards, center: middle, bottom (f towards bottom)
module connPlug(plugW,plugD,rot=0,f=1) {
	rotate([0,0,rot]) translate([-plugW/2,-plugD]) square([plugW,plugD+f]);
}
// plug cutout pointing upwards, center: middle, bottom (f towards top)
module connPlugCutOut(plugD,boltR,boltL,nutW,nutH,nutO,rot=0,boltS=8,f=1) {
	rotate([0,0,rot]) union() {
		translate([-boltS/2,-plugD-f]) 
			square([boltS,plugD+f]);
		translate([-boltR,-plugD,0]) 
			square([boltR*2,boltL]);
		translate([-nutW/2,nutO,0]) 
			square([nutW,nutH]);
	}
}
// hole
// origin: top center 
module connHole(plugW,plugH,boltR,rot=0,boltS=8,f=1) { 
	rotate([0,0,rot]) translate([0,plugH/2,0]) {
		difference() {
			square([plugW,plugH],center=true);
			translate(0,-f,0) square([boltS,plugH+f*2],center=true);
		}
		circle(boltR);
	}
}
// simple hole
// origin: top center 
module connHoleSimple(plugW,plugH,rot=0,f=1) { 
	rotate([0,0,rot]) translate([0,plugH/2,0])	{
		square([plugW,plugH],center=true);
	}
}

module black(alpha=1)
{
	h = materialThickness;
	color("Black",alpha) linear_extrude(height=h,convexity=c,center=true) for (i = [0 : $children-1]) children(i);
}
module milk(alpha=1)
{
	h = materialThickness;
	color("White",alpha) linear_extrude(height=h,convexity=c,center=true) for (i = [0 : $children-1]) children(i);
}
module mirrored(offset=0)
{
	translate([ offset/2, 0, 0]) for (i = [0 : $children-1]) children(i);
	translate([-offset/2, 0, 0]) scale([-1,1,1]) for (i = [0 : $children-1]) children(i);
}