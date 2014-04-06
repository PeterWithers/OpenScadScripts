module makeMainShape(shrinkValue){
	translate([shrinkValue/2,0,shrinkValue])
	cube([boardLength-shrinkValue,boardWidth-shrinkValue*2,totalHeight],true);
	rotate([0,90,0])translate([0,0,(boardLength+cowlingLength)/2-1-shrinkValue])
	intersection(){
		cylinder(cowlingLength+1, cowlingTailRadius-shrinkValue, cowlingTipRadius-shrinkValue,true);
		translate([-shrinkValue,0,0]) cube([totalHeight,boardWidth-shrinkValue*2,cowlingLength-shrinkValue*2],true);
	}
}


tipDiameter = 15;
shoulderRadius = 15;
noseLength = 40;
wallThickeness = 0.4;
boomDiameter = 7.5;
boomLength = 825;
fuselageCornerRadius = 8.7;

servoWidth = 23;
servoHeight = 12;
servoDepth = 23;
servoMountThickness = 3;
servoMountOffset = 7;
servoMountWidth = 33;

servoPosOnBoom = 127;

module makeServo() {
	cube([servoWidth,servoHeight,servoDepth],true);
	translate([0,0,servoMountOffset/2]) cube([servoMountWidth,servoHeight,servoMountThickness],true);
}

module makeNose(offset){
	hull(){
		translate([0,0,noseLength]) sphere(tipDiameter-offset);
		translate([0,0,-offset]) mainFuselage(offset, 1);
		//sphere(shoulderRadius-offset);
	}
}

module hollowNose(){
	difference(){
		makeNose(0);
		union(){
			makeNose(wallThickeness);
			translate([0,0,-shoulderRadius/2])
				cube([shoulderRadius*2,shoulderRadius*2,shoulderRadius],true);
		}
	}
}

module solidNose(){
	difference(){
		union(){
			makeNose(0);	
			translate([0,0,-5])
				mainFuselage(wallThickeness*2, 5);
		}
		cylinder(noseLength*2, boomDiameter/2+1, boomDiameter/2+1,true);
	}
}

module mainFuselage(offset, length){
hull()
for ( i = [0 : 3] )
	{
		rotate( i * 360 / 4 + 360 / 8, [0, 0, 1])
		translate([0, shoulderRadius, 0])
		cylinder(length,fuselageCornerRadius-offset,fuselageCornerRadius-offset);
	}
}
module fuselageLength(length){
	difference(){
		translate([0,0,-length])mainFuselage(0, length);
		translate([0,0,-length-wallThickeness])mainFuselage(wallThickeness, length+wallThickeness*2);
	}
}
module makeServoGroup(){
	translate([-4.5,boomDiameter/2+servoHeight/2,noseLength-servoMountWidth/2-servoPosOnBoom]) rotate(90,[0,1,0]) {
		makeServo();
		translate([28,0,9]) rotate(180,[1,0,0]) makeServo();
	}
}
module makeBoom() {
	translate([0,0,noseLength-boomLength/2])
		cylinder(boomLength, boomDiameter/2, boomDiameter/2,true);
}
module makeNonPrintedParts() {
	makeServoGroup();
	makeBoom();
}
solidNose();
%fuselageLength(150);
//hollowNose();
//mainFuselage(0,1);
makeNonPrintedParts();
