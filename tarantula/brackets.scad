width = 80;
length = 30;
height = 26;
e = 0.1;
thickness = 5;

// v profile
vThickness = 20;
screwOffset = vThickness/2;


$fn=50;

module roundedCube(x, y) {
  r = 2;
  h = 1;
  translate([r, r, 0])
  minkowski() {
    cube([x-r*2, y-r*2, thickness-h]);
    cylinder(r=r, h=h);
  }
}

module profileAttachment() {
  translate([width/2 - vThickness/2, 0])
    rotate([0, -90, 0])
      children();
}

fromSide = 7;
vSlotScrewDiam = 4.4; // add a bit
boardScrewDiam = 3;
boardScrewHeadDiam = 6;
slidingHoleLength = 8;

module placeHoles() {
  translate([0, fromSide, 0])
    children();
  translate([0, length-fromSide, 0])
    children();
  
}

module hole(d, h) {
  translate([0, 0, -e]) 
    cylinder(d = d+e, h = h+e*2);
}

module slideHole() {
  translate([0, -e/2, 0])
    minkowski() {
      cube([slidingHoleLength, e, 1]);
      translate([0, 0, -e])
        cylinder(d = boardScrewDiam+e, h = thickness + e*2);
    }
    
    minkowski() {
      cube([slidingHoleLength, e, 1]);
      translate([0, 0, thickness/2]) 
        cylinder(d1 = boardScrewDiam, d2 = boardScrewHeadDiam, h = thickness/2);
    }
}

difference() {
  union() {
    roundedCube(width, length);
    profileAttachment()
      roundedCube(height, length);
  }

  profileAttachment() {
    translate([thickness+screwOffset, 0, 0])
      placeHoles() {
        hole(d=vSlotScrewDiam+e, h = thickness);
      }
  }
  
  placeHoles() {
    translate([5, 0, 0])
      slideHole();
    translate([width-5-slidingHoleLength, 0, 0])
      slideHole();
  }
  
}
