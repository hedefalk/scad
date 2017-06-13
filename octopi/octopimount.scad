*color("red")  scale([1, 1, 1.1]) translate([-16, 95, 0]) rotate([90, 0, 0]) 
    import("/Users/viktor/Downloads/Support.STL");
    
*color("red") translate([-80, 96.5, 0]) rotate([90, 0, 0])
    import("/Users/viktor/Downloads/Support.STL");

hole_height = 5;
M3_diam = 2.8;
M25_diam = 2.5;

e = 0.1;


module peg() {
    cylinder(h = hole_height, d1 = 8, d2 = 6, $fn = 20);   
}

module hole(innerdiam) {
    translate([0, 0, -e]) cylinder(h = hole_height+2*e,  d = innerdiam, $fn = 10);
}

module M3_hole() {
    raised_hole(M3_diam);
}

module atpoint(p) {
    translate([p[0], p[1], 0]) children();
}

module rounded_plate(width, height) {
    linear_extrude(3) minkowski() {
     square([width, height]);
     circle(5);
    }
}


UM2_holes = [[0, 0], [32, 94], [71, -11]];

// https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/RPI-3B-V1_2.pdf
PI_holes = [[0, 0], [49, 0], [0, 58], [49, 58]];

relay_holes = [[0, 0], [20.5, 0], [0, 28], [20.5, 28]];
stepdown_holes = [[0, 0], [16, 30]];


module UM2_plate() {
    r = M3_diam/2;
    pad = 10;
    
    translate([0, 90, 0]) rotate([0, 0, -90]) linear_extrude(3) {
          minkowski() {
              difference() {
                      polygon(points = UM2_holes);
                      square([100, 100], false);
              }
               circle(5);
            }
    }
}


module UM2_holes() {
    translate([0, 90, 0]) rotate([0, 0, -90]) {            
        // These where measured in FreeCAD using Delta measure
        //  but could only mark the half circle arcs so had to add
        // 94.2, 29.5 + r,
        // 67.5+r, -10.8 
        // Didn't work for some reason, (wrong r?), comparing with STL instead, 
        // seems exact on whole mm.
        for (p = UM2_holes)
            atpoint(p) hole(M3_diam);
        
    }
}

module PI_mount() {
    // https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/RPI-3B-V1_2.pdf
    // size 85*56 
    translate([0, 20, 0])
    for (p = PI_holes)
        atpoint(p) peg();
    
    translate([-4, -5, 0]) rounded_plate(56, 85);
}



module relay_mount() {
    //holes 20.5*28
    // 26*34 size
   for(p = relay_holes) atpoint(p) peg();    
   translate([-20, -3, 0]) rounded_plate(40, 50);
}

module step_down_mount() {
   // two diagonal holes 34 mm.
   // 16^2+30^2 = 34^2
    // 21*43 size
   for(p = stepdown_holes) atpoint(p) peg();
   translate([-2.5, 0, 0]) rounded_plate(21, 38);
}

module stepdown_pos() {
     translate([90, 65, 0]) rotate([0, 0, 90]) children();
}

difference() {
    union() {
        translate([-2, 6, 0]) PI_mount();
        translate([72, 10, 0]) relay_mount();
        stepdown_pos() step_down_mount();
        UM2_plate();
    }
    
    UM2_holes();
    stepdown_pos() for(p = stepdown_holes) atpoint(p) hole(M3_diam);
    translate([72, 10, 0]) for(p = relay_holes) atpoint(p) hole(M3_diam);
    translate([-2, 26, 0]) for(p = PI_holes) atpoint(p) hole(M25_diam);
    
    
    translate([0, 0, -e]) linear_extrude(3 + e*2) {
        translate([3, 8]) circle(10);
        translate([27, 8]) circle(10);
        translate([46, 8]) circle(7);
        translate([23, 50]) circle(28);
        translate([70, 60]) circle(15);
        translate([64, 24]) circle(12);
        translate([86, 24]) circle(8);
        translate([8, 83]) circle(5);
        translate([20, 84]) circle(4);
        translate([30, 84]) circle(4);
        translate([40, 84]) circle(3);
        translate([47, 75]) circle(5);
        translate([84, 80]) circle(6);
        translate([84, 42]) circle(6);
    }
    
    
}
