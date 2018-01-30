/** Pegboard settings */
hole_size = 4;
hole_spacing = 25.4/2;
board_thickness = 4;

peg_square_side = sqrt(pow(hole_size, 2)/2);

thickness = 4;

module peg_fitting() {
   depth = 20;
   height = hole_spacing+peg_square_side;
   peg_depth = board_thickness;
   difference() {
     polygon(points = [
      [0, 0] 
      ,[0, -height]
      ,[depth, -height]
      ,[depth+peg_depth, -height]
      ,[depth+peg_depth, -height-peg_square_side]
      ,[depth+peg_depth+peg_square_side, -height-peg_square_side]
      ,[depth+peg_depth+peg_square_side, -height]
      ,[depth+peg_depth, -height+peg_square_side]
      ,[depth, -height+peg_square_side]

      ,[depth, -peg_square_side]
      ,[depth+peg_depth, -peg_square_side]
      ,[depth+peg_depth, 0]
    ]);
     
    polygon(points = [
      [thickness, -thickness]
      ,[thickness, -height]
      ,[depth - thickness, -height]
      ,[depth - thickness, -thickness]
    ]);
  }
}

linear_extrude(peg_square_side) {
    peg_fitting();
}
  
