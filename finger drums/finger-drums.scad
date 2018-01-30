piezo_diam = 28;
margin = 1;
piezo_shell = 4;
drum_depth = 7;
bottom_thickness = 5;
epsilon = 0.1;
drumPositions = [[0, 0], [80, 0], [0, 80]];



module holes() {
  for (d = drumPositions) {
    translate(d) {
      circle(piezo_diam + margin);
    }
  };
}

module shell() {
  for (d = drumPositions) {
    translate(d) {
      circle(piezo_diam + margin + piezo_shell);
    }
  };
}


difference() {
  linear_extrude(drum_depth + bottom_thickness) {
    hull() {
      shell();
    };
  };
  translate([0, 0, bottom_thickness + epsilon]) {
    linear_extrude(drum_depth) {
      holes();
    };
  };
}
