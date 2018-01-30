include <eurorack-lib/constants.scad>
use <eurorack-lib/eurorack-lib.scad>

panelHp = 10;
width = hp * panelHp;

potHoleDiam = 7.5;
jackHoleDiam = 6.5;
switchHoleDiam = 6.8;
phoneJackHoleDiam = 8.8;

sideMargin = 12;

firstCol = sideMargin;
secondCol = width - sideMargin;

middle = width / 2;

topMargin = 20;
verticalSpacing = 20;

pots = [
  [firstCol, topMargin, potHoleDiam],
  [firstCol, topMargin + verticalSpacing, potHoleDiam],
  [firstCol, topMargin + verticalSpacing*2, potHoleDiam],
  [secondCol, topMargin, potHoleDiam],
  [secondCol, topMargin + verticalSpacing, potHoleDiam],
  [secondCol, topMargin + verticalSpacing*2, potHoleDiam]
];

jackFirstCol = 11;
yStart = 80;
rowDist = 17;

jacks = [
  [jackFirstCol, yStart],
  [width/2, yStart],
  [width-jackFirstCol, yStart],

  [jackFirstCol, yStart+rowDist],
  [width/2, yStart+rowDist],
  [width-jackFirstCol, yStart+rowDist],

  [jackFirstCol, yStart+rowDist*2],
  [width/2, yStart+rowDist*2],
  [width-jackFirstCol, yStart+rowDist*2]
];


module holes() {
  mountHoleDepth = panelThickness+2;
  translate([0, 0, -0.1]) { // to make holes through proper
    union(){
      for(hole = pots) {
        translate([hole[0], hole[1]])
        cylinder(d=hole[2], h=mountHoleDepth, $fn=20);
      }
      
    }
  }
  // Extra cutouts for defective jacks
  for(hole = jacks) {
    translate([hole[0], hole[1]]) {
      PJ301();
    }
  }
}

difference() {
  union() {
    eurorackPanel(panelHp, 4);
    walls(10);
  }
  holes();
}
