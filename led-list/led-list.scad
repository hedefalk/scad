/** Pegboard settings */
hole_size = 4;
hole_spacing = 25.4;
board_thickness = 4;


/** Led strip settings */
strip_width = 10;
thickness = 1;

peg_square_side = sqrt(pow(hole_size, 2)/2);
led_holder_width = strip_width+2*thickness;


module led_slot_profile() {  
   width = led_holder_width;
   height = 1.5;
   led_width = 6;
   grove_length = (strip_width - led_width)/2;
   polygon(points=[[0, 0], [width,0], [width, 2*thickness+height], 
    [strip_width-grove_length+thickness, 2*thickness+height], [width-grove_length-thickness,thickness+height],
    [width-thickness, thickness+height], [width-thickness, thickness],
    [thickness, thickness], [thickness, thickness+height], [thickness+grove_length, thickness+height],
    [thickness+grove_length, thickness*2+height],
    [0, thickness*2+height],
    
   ]);
    

}


module peg_fitting() {
   length = 200;
   height = hole_spacing+peg_square_side;
   peg_length = board_thickness;
   difference() {
     polygon(points = [
      [0, 0] 
      ,[length, -height]
      ,[length+peg_length, -height]
      ,[length+peg_length, -height-peg_square_side]
      ,[length+peg_length+peg_square_side, -height-peg_square_side]
      ,[length+peg_length+peg_square_side, -height]
      ,[length+peg_length, -height+peg_square_side]
      ,[length, -height+peg_square_side]

      ,[length, -peg_square_side]
      ,[length+peg_length, -peg_square_side]
      ,[length+peg_length, 0]
      ,[led_holder_width, 0]
      
     ]);
     
     polygon(points = [
       [length-peg_square_side, -peg_square_side]
       ,[length-peg_square_side, -height+2*peg_square_side+2*height/length]
       ,[peg_square_side*(1 + 2*length/height), -peg_square_side]
     ]);
   }
}



linear_extrude(peg_square_side) {
    led_slot_profile();
    peg_fitting();
}
  
