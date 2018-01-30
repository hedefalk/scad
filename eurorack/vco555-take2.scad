
panelThickness = 2.5;
panelHp=10;
holeCount=4;
holeWidth = 5.08*1; //If you want wider holes for easier mounting. Otherwise set to any number lower than mountHoleDiameter. Can be passed in as parameter to eurorackPanel()

threeUHeight = 133.35; //overall 3u height
panelOuterHeight =128.5;
panelInnerHeight = 110; //rail clearance = ~11.675mm, top and bottom
railHeight = (threeUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

hp=5.08;
width = panelHp * hp;
mountHoleDiameter = 3.2;
mountHoleRad =mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;
mountHoldXMargin = 1.5 * hp; //1hp margin on each side

offsetToMountHoleCenterY=mountSurfaceHeight/2;

offsetToMountHoleCenterX = mountHoldXMargin - hwCubeWidth/2;

module eurorackPanel(panelHp,  mountHoles=2, hw = holeWidth, ignoreMountHoles=false)
{
    //mountHoles ought to be even. Odd values are -=1
    difference()
    {
        cube([hp*panelHp,panelOuterHeight,panelThickness]);

        if(!ignoreMountHoles)
        {
            eurorackMountHoles(panelHp, mountHoles, holeWidth);
        }
    }
}

module eurorackMountHoles(php, holes, hw)
{
    holes = holes-holes%2;//mountHoles ought to be even for the sake of code complexity. Odd values are -=1
    eurorackMountHolesTopRow(php, hw, holes/2);
    eurorackMountHolesBottomRow(php, hw, holes/2);
}

module eurorackMountHolesTopRow(php, hw, holes)
{

    //topleft
    translate([offsetToMountHoleCenterX,panelOuterHeight-offsetToMountHoleCenterY,0])
      eurorackMountHole(hw);
    if(holes>1)
      translate([(hp*php)-hwCubeWidth-offsetToMountHoleCenterX,panelOuterHeight-offsetToMountHoleCenterY,0])
        eurorackMountHole(hw);
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,panelOuterHeight-offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHolesBottomRow(php, hw, holes)
{

    //bottomRight
    translate([(hp*php)-hwCubeWidth-offsetToMountHoleCenterX,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    if(holes>1)
    {
        translate([offsetToMountHoleCenterX,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    }
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHole(hw) {

    mountHoleDepth = panelThickness+2; //because diffs need to be larger than the object they are being diffed from for ideal BSP operations

    if(hwCubeWidth<0) {
      hwCubeWidth=0;
    }

    translate([0,0,-1]){
      cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
      translate([0,-mountHoleRad,0]) {
        cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
      }
      translate([hwCubeWidth,0,0]) {
        cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
      }
    }
}

potHoleDiam = 7.5;
jackHoleDiam = 6.5;
switchHoleDiam = 6.5;
phoneJackHoleDiam = 8.5;


sideMargin = 12;

firstCol = sideMargin;
secondCol = width - sideMagin;


middle = width / 2;


topMargin = 20;
verticalSpacing = 20;
yDelta = 20;

jackFirstCol = 11;
yStart = 78;
rowDist = 17;

pots = [
  [firstCol, topMargin, potHoleDiam],
  [firstCol, topMargin + verticalSpacing, potHoleDiam],
  [firstCol, topMargin + verticalSpacing*2, potHoleDiam],
  [secondCol, topMargin, potHoleDiam],
  [secondCol, topMargin + verticalSpacing, potHoleDiam],
  [secondCol, topMargin + verticalSpacing*2, potHoleDiam]
];


jacks = [
  [jackFirstCol, yStart, jackHoleDiam],
  [width/2, yStart, jackHoleDiam],
  [width-jackFirstCol, yStart, jackHoleDiam],

  [jackFirstCol, yStart+rowDist, jackHoleDiam],
  [width/2, yStart+rowDist, jackHoleDiam],
  [width-jackFirstCol, yStart+rowDist, jackHoleDiam],

  [jackFirstCol, yStart+rowDist*2, jackHoleDiam],
  [width/2, yStart+rowDist*2, jackHoleDiam],
  [width-jackFirstCol, yStart+rowDist*2, jackHoleDiam]
];

module holes() {
  mountHoleDepth = panelThickness+2; //because diffs need to be larger than the object they are being diffed from for ideal BSP operations

  translate([0, 0, -0.1]) { // to make holes through proper
    for(hole = pots) {
      translate([hole[0], hole[1]])
      cylinder(d=hole[2], h=mountHoleDepth, $fn=20);
    }
  }
  for(hole = jacks) {
      translate([hole[0], hole[1]])
      cylinder()
  } 
}

straightY=6;
straightY2=10;
angleY=5;
angleX=2;
thickness = 2;
path = [
  [0, 0],
  [thickness, 0],
  [thickness, straightY],
  [thickness + angleX, straightY + angleY],
  [thickness + angleX, straightY + straightY2  + angleY-thickness],
  /*[thickness, straightY + angleY * 3 - thickness],
  [thickness, straightY*2 + angleY * 3],
  [0, straightY*2 + angleY * 3],
  [0, straightY + angleY * 3 - thickness],*/
  [angleX, straightY+straightY2 + angleY - thickness],
  [angleX, straightY + angleY],
  [0, straightY]
];

heightOtherSide = 12;
pathOtherSide = [
  [0, 0],
  [thickness, 0],
  [angleX, heightOtherSide],
  [0, heightOtherSide]

];

difference() {
  union() {
    eurorackPanel(panelHp, holeCount,holeWidth);
    wallYMarginPerSide = 10;
    wallY = panelOuterHeight - wallYMarginPerSide*2;

    translate([0, panelOuterHeight - wallYMarginPerSide, panelThickness-0.1]) {
      rotate([90, 0, 0]) {
        linear_extrude(height=wallY) polygon(points=path);
        translate([width-thickness, 0, 0])
          linear_extrude(height=wallY) polygon(points=pathOtherSide);
      }
    }
  }

  holes();
}

