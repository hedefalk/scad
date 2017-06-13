
//UM2 Cura
max_width = 215;
max_height = 197;
//max_height = 223;
depth = 50;
outer_thickness = 2;

shelf_height = 25.5;

inner_thickness = 1.5;
no_shelves = 6;
shelf_angle = 8;
given_max_height = 200;


// offset because of rotation
shelf_offset_z = sin(shelf_angle) * shelf_height;
shelf_offset_y = shelf_height/cos(shelf_angle);


//width = 200; // Fits 8 bottles (circumference a little less than 25mm in averege)
width = 202; // After first test, it was a bit cramped. 2mm extra seems reasonable


height = min(max_height - 2*outer_thickness, no_shelves*(shelf_offset_y+inner_thickness) + outer_thickness*2, given_max_height);


hanger_attachment_width = 10;
hanger_marginal = 0.5;


// TODO: Translate with pythagoras and sinus? Since we rotate
module hull() {
    cube([width+outer_thickness*2, height+outer_thickness*2, depth+outer_thickness]);
}

module shelf_crevice(no, top) {
    
   translate([0, no*(shelf_offset_y+inner_thickness), shelf_offset_z+outer_thickness])    
     rotate([-shelf_angle, 0, 0])
       cube([width, shelf_height, depth+shelf_offset_z]);
 
   translate([0, no*(shelf_offset_y+inner_thickness), outer_thickness]) 
     rotate([90, 0, 90]) 
        linear_extrude(height = width)
           polygon([[0, 0], [0, shelf_offset_z], [shelf_height, 0]]);
   
   // cutaway upper part of each shelf for saving material
   cutout_ratio = 2/3;
   translate([0, no*(shelf_offset_y+inner_thickness) + shelf_height*(1 - cutout_ratio), 0]) 
      cube([width, shelf_height*cutout_ratio, outer_thickness]);
   
}


module shelves() {
    translate([outer_thickness, outer_thickness, 0])    
        for(shelf_no = [-1: 1 : no_shelves-1]) {
          shelf_crevice(shelf_no);
        }    
}

hook_thickness = 2;

module hanger_cutout() {
    // translate as shelves themselves
    translate([outer_thickness, outer_thickness, outer_thickness])
    // also translate to upmost shelf
    translate([0, (no_shelves-1)*(shelf_offset_y+inner_thickness), 0])
    // but maybe also translate so the hanger is at the lower part when attached, making
    // as little impact as possible on dropper bottle depth
    translate([0, -shelf_height/2, 0])
    translate([0, 0, -outer_thickness]) {
        hole();
        translate([width, 0, 0])
        mirror([1, 0, 0])
        hole();
    }    
    
  
    module hole() {
        cube([hanger_attachment_width, shelf_height/2, outer_thickness+hook_thickness+hanger_marginal]);
    }  
}


module hanger() {
    cube([width, shelf_height, hook_thickness]);
    hook();
    translate([width, 0, 0])
        mirror([1, 0, 0])
            hook();
    
    module hook() {  
        margin = 0.2;      
        translate([margin/2, 0, hook_thickness]) {
            cube([hanger_attachment_width, 4, hook_thickness]);
            translate([0, 0, hook_thickness])
                cube([hanger_attachment_width, shelf_height/2, hook_thickness]);
        }
    }
}


epsilon = 0.1;

// strength_factor, holder_height, hol_spacing, holder_total_x
holder_total_x = width;
// hole spacing
hole_spacing = 25.4*4;
// hole size
hole_size = 3;
clip_height = 2*hole_size + 2;
// board thickness
board_thickness = 5;


strength_factor = 1;
holder_height = height;





module pin(clip)
{
	rotate([0,0,15])
	cylinder(r=hole_size/2, h=board_thickness*1.5+epsilon, center=true, $fn=12);

	if (clip) {
		//
		rotate([0,0,90])
		intersection() {
			translate([0, 0, hole_size-epsilon])
				cube([hole_size+2*epsilon, clip_height, 2*hole_size], center=true);

			// [-hole_size/2 - 1.95,0, board_thickness/2]
			translate([0, hole_size/2 + 2, board_thickness/2]) 
				rotate([0, 90, 0])
				rotate_extrude(convexity = 5, $fn=20)
				translate([0.44*hole_size+2.36, 0, 0])
				 circle(r = (hole_size*0.95)/2); 
			
			translate([0, hole_size/2 + 2 - 1.6, board_thickness/2]) 
				rotate([45,0,0])
				translate([0, -0, hole_size*0.6])
					cube([hole_size+2*epsilon, 3*hole_size, hole_size], center=true);
		}
	}
}

module pinboard_clips() {
	rotate([0,90,0])
	for(i=[0:round(holder_total_x/hole_spacing)]) {
		for(j=[0:max(strength_factor, round(holder_height/hole_spacing))]) {

			translate([
				j*hole_spacing, 
				-hole_spacing*(round(holder_total_x/hole_spacing)/2) + i*hole_spacing, 
				0])
					pin(true);
		}
	}
}


module pinboard_hook() {
    hole_size = 4;
    hole_spacing = 25.4/2;
    board_thickness = 4;
    
    peg_square_side = sqrt(pow(hole_size, 2)/2);
    
    linear_extrude(peg_square_side)
        polygon(points = [
            [0,0]
            ,[hook_thickness, 0]
            ,[hook_thickness, -shelf_height/2+hook_thickness]
            ,[hook_thickness*2, -shelf_height/2+hook_thickness]
            ,[hook_thickness*2, 0]
            ,[hook_thickness*3, 0]
            ,[hook_thickness*3, -shelf_height/2]
            ,[hook_thickness, -shelf_height/2]
            // INSERT LENGTH HERE FOR SUPPORT
            ,[0, -shelf_height/2]
            ,[0, -peg_square_side]
            ,[-peg_square_side, -peg_square_side]
            ,[-2*peg_square_side, 0]
            ,[-2*peg_square_side, peg_square_side]
            ,[-peg_square_side, peg_square_side]
            ,[-peg_square_side, 0]
            
            ,[0, 0]
        
        ]);
}

difference() {
    hull();
    shelves();
    hanger_cutout();
}

 *translate([outer_thickness, height+30, 0]) {
    hanger(); 
    rotate([0, 90, 90])
        pinboard_clips();

}

*translate([0, 0, 0])
    pinboard_hook();
    
