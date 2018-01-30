include <eurorack-lib/constants.scad>
use <eurorack-lib/eurorack-lib.scad>

panelHp = 10;
width = hp * panelHp;

potHoleDiam = 7.5;
jackHoleDiam = 6.5;
switchHoleDiam = 6.8;
phoneJackHoleDiam = 8.8;

// Should be 2mm, but 2.5 makes for lots of room for squish and sanding
panelThickness = 2.5;

sideMagin = 15;

firstCol = sideMagin;
secondCol = width - sideMagin;

middle = width / 2;

topMargin = 16;
verticalSpacing = 13.8;

holes = [
  // jacks
  [firstCol, topMargin, jackHoleDiam], // input level
  [firstCol, topMargin + verticalSpacing, jackHoleDiam], // input level
  [firstCol, topMargin + verticalSpacing*2, jackHoleDiam],
  [firstCol, topMargin + verticalSpacing*3, jackHoleDiam],
  [firstCol, topMargin + verticalSpacing*4, jackHoleDiam],
  [firstCol, topMargin + verticalSpacing*5, jackHoleDiam],
  [firstCol, topMargin + verticalSpacing*6, jackHoleDiam],
  [firstCol, topMargin + verticalSpacing*7, jackHoleDiam],

  // pots
  [secondCol, topMargin + verticalSpacing*0.8, potHoleDiam],
  [secondCol, topMargin + verticalSpacing*4.8, potHoleDiam],

  [secondCol, topMargin + verticalSpacing*2.5, switchHoleDiam],
  [secondCol, topMargin + verticalSpacing*6.5, switchHoleDiam],
  /*[secondCol, topMargin + verticalSpacing*4+5-7, phoneJackHoleDiam] // headphones*/
];

mountHoleDepth = panelThickness+2;

module holes() {
  translate([0, 0, -0.1]) { // to make holes through proper
    for(hole = holes) {
      translate([hole[0], hole[1]])
      cylinder(d=hole[2], h=mountHoleDepth, $fn=20);
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
