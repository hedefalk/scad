
panelThickness = 2;
panelHp=10;
holeCount=4;
holeWidth = 5.08*1; //If you want wider holes for easier mounting. Otherwise set to any number lower than mountHoleDiameter. Can be passed in as parameter to eurorackPanel()

walls=true;
two_walls=false;
wall_size=20;

threeUHeight = 133.35; //overall 3u height
panelOuterHeight =128.5;
panelInnerHeight = 110; //rail clearance = ~11.675mm, top and bottom
railHeight = (threeUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

hp=5.08;
mountHoleDiameter = 3.2;
mountHoleRad =mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;
mountHoldXMargin = 1 * hp; //1hp margin on each side

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
width = panelHp * hp;
firstCol = 12;
secondCol = width - 12;

topMargin = 20;
verticalSpacing = 18;

potHoles = [
  [firstCol, topMargin],
  [firstCol, topMargin + verticalSpacing],
  [firstCol, topMargin + verticalSpacing*2],
  [firstCol, topMargin + verticalSpacing*3],
  [secondCol, topMargin + verticalSpacing*4],
  [secondCol, topMargin],
  [secondCol, topMargin + verticalSpacing],
  [secondCol, topMargin + verticalSpacing*2],
  [secondCol, topMargin + verticalSpacing*3]
  ];

jackHoles = [
  [8, 110],
  [8, 98], // led, same diam with socket
  [width-8, 110],
  [width/2, 110],
];


mountHoleDepth = panelThickness+2;

module holes() {
  translate([0, 0, -0.1]) { // to make holes through proper
    for(hole = potHoles) {
      translate(hole)
      cylinder(d=potHoleDiam, h=mountHoleDepth, $fn=20);
    }
    for(hole = jackHoles) {
      translate(hole)
      cylinder(d=jackHoleDiam, h=mountHoleDepth, $fn=20);
    }
  }
}


difference() {
  union() {
    eurorackPanel(panelHp, holeCount,holeWidth);
    if (walls) {
      size = [2,panelOuterHeight-20,wall_size];
      
      translate([0,10,1]){
        cube(size);
      }
      
      if (two_walls) {
        translate([hp*panelHp-2,10,1]){
          cube(size);
        }
      }
    }
  }
  
  holes();
}
