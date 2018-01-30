include <eurorack-lib/constants.scad>
use <eurorack-lib/eurorack-lib.scad>

panelHp = 8;
width = hp * panelHp;

sideMargin = 10;

potCol = sideMargin;
jackCol = width-sideMargin;
yStart = 24;
rowDist = 0.8*25.4; // 0.8 inch between pots on pcb

pots = [
  [potCol, yStart],
  [potCol, yStart+rowDist],
  [potCol, yStart+rowDist*2],
  [potCol, yStart+rowDist*3],
  [potCol, yStart+rowDist*4]
];

jacks = [
  [jackCol, yStart],
  [jackCol, yStart+rowDist],
  [jackCol, yStart+rowDist*2],
  [jackCol, yStart+rowDist*3],
  [jackCol, yStart+rowDist*4]
];

module holes() {
  mountHoleDepth = panelThickness+2;
  translate([0, 0, -0.1]) { // to make holes through proper
    union(){
      for(hole = pots)
        translate([hole[0], hole[1]])
        AlphaPot();
    }
  }
  for(hole = jacks)
    translate([hole[0], hole[1]])
    PJ301();
}


module main() {
  difference() {
    union() {
      eurorackPanel(panelHp, 4);
      // walls(panelHp);
    }
    holes();
  }
}

// main();
projection() main();
