threeUHeight = 133.35; //overall 3u height
panelOuterHeight =128.5;

panelHp=6;
hp=5.08;
width = panelHp * hp; // Not really, check Doepfer!

module cross() {
  square([0.1, 1], true);
  square([1, 0.1], true);
}

middle = width/2;
topMargin = 18;
potSpacing = 20;
leftCol = 8;
rightCol = width - leftCol;
nextSpacing = 19;
jackSpacing = 16;


holes = [
  // POTS
  [middle, topMargin],
  [middle, topMargin + potSpacing],
  [middle, topMargin + potSpacing*2],
  [middle, topMargin + potSpacing*3],

  [middle, topMargin + potSpacing*3],
  [leftCol, topMargin + potSpacing*3 + nextSpacing],
  [rightCol, topMargin + potSpacing*3 + nextSpacing],
  [leftCol, topMargin + potSpacing*3 + nextSpacing+jackSpacing],
  [rightCol, topMargin + potSpacing*3 + nextSpacing+jackSpacing]

];

lineWidth = 0.2;

for (hole = holes) {
  translate(hole) {
    cross();
  }
}
difference() {
  square([width, panelOuterHeight]);
  translate([lineWidth, lineWidth])
    square([width-lineWidth*2, panelOuterHeight-lineWidth*2]);
}
