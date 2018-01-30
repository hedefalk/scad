include <eurorack-lib/constants.scad>
use <eurorack-lib/eurorack-lib.scad>

panelHp = 8;
width = hp * panelHp;
middle = width / 2;

// Taken from Eagle front panel file
eagle_pots = [
  [6.2, 94.5],
  [33.8, 94.5],
  [6.2, 63.5],
  [33.8, 63.5],
];

eagle_diodes = [
  // [4.65, 32.71], // diodes
  // [14.94, 32.75],
  // [25.92, 32.58],
  // [35.12, 32.42],
  [4.5, 32.71], // diodes fixed alignment for bending in place
  [14.833, 32.75],
  [25.167, 32.58],
  [35.5, 32.42],
];

eagle_jacks = [
  [6.2, 78.5],
  [33.8, 78.5],
  [6.2, 47.5],
  [33.8, 47.5],
];

eagle_jacks_rotated_180 = [
  [4.5, 6],
  [14.833, 6],
  [35.5, 6],
  [4.5, 22],
  [14.833, 22],
  [25.167, 22],
  [35.5, 22],
];

module holes() {
  translate([0.3, 115, 0])
  mirror([0, 1, 0]) {
    for(hole = eagle_pots)
      translate([hole[0], hole[1]])
        AlphaPot();
    for(hole = eagle_jacks)
      translate([hole[0], hole[1]])
        PJ301();
    for(hole = eagle_jacks_rotated_180)
      translate([hole[0], hole[1]])
        rotate([0, 0, 180])
        PJ301();
    for(hole = eagle_diodes)
      translate([hole[0], hole[1]])
        ThreeMmLed();
  }
}

difference() {
  union() {
    eurorackPanel(panelHp, 4);

    reinforcement_width = 1;
    reinforcement_height = 7;

    translate([middle-reinforcement_width/2, 10, 0]) {
      cube([reinforcement_width, 108, reinforcement_height]);
      translate([-6, 0, 0])
        cube([reinforcement_width, 68, reinforcement_height]);
      translate([6, 0, 0])
        cube([reinforcement_width, 68, reinforcement_height]);
      translate([19.5, 0, 0])
        cube([reinforcement_width, 108, reinforcement_height]);
      translate([-19.5, 0, 0])
        cube([reinforcement_width, 108, reinforcement_height]);
    }
  }
  holes();
}
