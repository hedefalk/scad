include <constants.scad>

// how wide the holes should be
holeWidth = 5.08;
mountHoleDiameter = 3.2; // M3

hwCubeWidth = holeWidth - mountHoleDiameter;
mountHoleRad = mountHoleDiameter/2;
mountHoleXMargin = 7.5; // http://www.doepfer.de/a100_man/a100m_e.htm
panelInnerHeight = 110; //rail clearance = ~11.675mm, top and bottom
railHeight = (threeUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;
offsetToMountHoleCenterY = mountSurfaceHeight/2;
mountHoleDepth = panelThickness+2;


module eurorackPanel(panelHp, mountHoles=4) {
  //mountHoles ought to be even. Odd values are -=1
  difference() {
    cube([hp*panelHp,panelOuterHeight,panelThickness]);

    holes = mountHoles-mountHoles%2; //mountHoles ought to be even for the sake of code complexity. Odd values are -=1
    offsetToMountHoleCenterX = mountHoleXMargin - hwCubeWidth/2;
    // Iteratively calc this since I'm tired and can't do math right now. Point is that since
    // Doepfer says 7.5 from left side, we can't use same offset from the right side since not a multiple of hp
    // See http://www.doepfer.de/a100_man/a100m_e.htm
    rightMountHoleOffsetX = offsetToMountHoleCenterX+hp*(panelHp-3);


    //topleft
    translate([offsetToMountHoleCenterX,panelOuterHeight-offsetToMountHoleCenterY,0])
      eurorackMountHole();
    translate([offsetToMountHoleCenterX,offsetToMountHoleCenterY,0])
      eurorackMountHole();


    if(holes>2) {
      //topRight
      translate([rightMountHoleOffsetX,panelOuterHeight-offsetToMountHoleCenterY,0])
        eurorackMountHole();

      //bottomRight
      translate([rightMountHoleOffsetX,offsetToMountHoleCenterY,0])
          eurorackMountHole();
    }
  }
}

module eurorackMountHole() {
    mountHoleDepth = panelThickness+2; //because diffs need to be larger than the object they are being diffed from for ideal BSP operations
    if(hwCubeWidth<0) {
      hwCubeWidth=0;
    }
    translate([0,0,-1]) {
      cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
      translate([0,-mountHoleRad,0])
        cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
      translate([hwCubeWidth,0,0])
        cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
    }
}

module walls(panelHp) {
  width = panelHp * hp;
  straightY=20;
  straightY2=10;
  angleY=5;
  angleX=2;
  thickness = 2;
  leftPath = [
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

  straightYOtherSide=15;
  rightPath = [
    [0, 0],
    [thickness, 0],
    [angleX, straightYOtherSide],
    [0, straightYOtherSide]
  ];

  wallYMarginPerSide = 10;
  wallY = panelOuterHeight - wallYMarginPerSide*2;

  translate([0, panelOuterHeight - wallYMarginPerSide, panelThickness-0.1]) {
    rotate([90, 0, 0]) {
      linear_extrude(height=wallY) polygon(points=leftPath);
      translate([width-thickness, 0, 0]) {
        linear_extrude(height=wallY) polygon(points=rightPath);
      }
    }
  }
}

 
// Square and cirular cutout to make the protrude a bit more
// I have a big batch of defective ones with short threads so need that extra
module PJ301() {
  jackHoleDiam = 6.5;

  translate([0, 0, -0.01])
    cylinder(d=jackHoleDiam, h=mountHoleDepth+2, $fn=40);
  translate([0, 0, panelThickness-1.5])
    cylinder(d=8.5, h=1.4, $fn=40);

  extra_cutting_upwards = 10;
  translate([0, 0.7, panelThickness + extra_cutting_upwards/2])
    cube([9.5, 11, 2.1 + extra_cutting_upwards], true);
}

// The cheap larger pots
module AlphaPot() {
  potHoleDiam = 7.5;
  translate([0, 0, -0.01])
    cylinder(d=potHoleDiam, h=mountHoleDepth+2, $fn=40);
}

module RV09Pot() {
  potHoleDiam = 7;
  translate([0, 0, -0.01])
    cylinder(d=potHoleDiam, h=mountHoleDepth+2, $fn=40);
}

module ThreeMmLed() {
  translate([0, 0, -0.01])
    cylinder(d=3.4, h=mountHoleDepth+2, $fn=40);
}