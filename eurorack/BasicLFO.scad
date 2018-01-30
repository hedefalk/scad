
panelThickness = 2.5;
panelHp=6;
holeCount=2;
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



middle = width / 2;


topMargin = 26;
verticalSpacing = 26;
yDelta = 20;

holes = [
  [middle, topMargin, switchHoleDiam], // freq range
  [middle, topMargin+yDelta, potHoleDiam], // freq
  [middle, topMargin+yDelta*2, jackHoleDiam], // sine, tria, pulse
  [middle, topMargin+yDelta*3, jackHoleDiam],
  [middle, topMargin+yDelta*4, jackHoleDiam],
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

pathOtherSide = [
  [0, 0],
  [thickness, 0],
  [angleX, straightY],
  [0, straightY]

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
