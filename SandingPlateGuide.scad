// Author: Peter Withers
// Creation date: 2016-02-27 15:41

glassHeight = 90;
glassWidth = 90;
glassThickness = 2;
glassGap = 1;
guideHeight = 10;
guideLength = 100;
guideWidth = 10;

module makeGuide(){
    difference(){
        translate([0,glassWidth / 2 - 2, 0]) cube([guideLength, guideWidth, guideHeight], true);
        glassPlates();
	translate([0,0,glassGap + ((glassThickness + 20) / 2)]) cube([glassHeight + 20, glassWidth, 20], true);
    };
}

module glassPlates() {
	cube([glassHeight,glassWidth,glassThickness],true);
	translate([0, 0, glassGap + glassThickness]) cube([glassHeight, glassWidth, glassThickness],true);
}

module makeNonPrintedParts() {
	#glassPlates();
        makeGuide();
}

module makePrintedParts() {
	rotate([-90,0,0]) makeGuide();
}

//makeNonPrintedParts();
makePrintedParts();
