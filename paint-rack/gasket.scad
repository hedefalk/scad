epsilon = 0.1;

thickness = 4;
diam = 20;
inner_diam = 11;

difference() {
    cylinder(thickness, diam/2, diam/2, true);
    translate(-epsilon, 0, 0) {
        cylinder(thickness+epsilon, inner_diam/2, inner_diam/2, true);
    }
    
    translate([-diam/2-3, 0, 9])
        rotate([90, 0, 0]) 
            cylinder(80, 10, 10, true);
    
}