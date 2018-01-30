threeUHeight = 133.35; //overall 3u height
panelOuterHeight =128.5;

panelHp=2;
hp=5.08;
width = panelHp * hp; // Not really, check Doepfer!

module cross() {
  square([0.1, 1], true);
  square([1, 0.1], true);
}

middle = width/2;
topMargin = 19;
spacing = 22;



topMargin = 19;
verticalSpacing = 22;


holes = [
  [middle, topMargin],
  [middle, topMargin + spacing],
  [middle, topMargin + spacing*2],
  [middle, topMargin + spacing*3],
  [middle, topMargin + spacing*4],
  [middle, topMargin + spacing*5],
  [middle, topMargin + spacing*6],
  [middle, topMargin + spacing*7]
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
