include <eurorack-lib/constants.scad>
use <eurorack-lib/eurorack-lib.scad>

panelHp = 4;
width = hp * panelHp;
middle = width / 2;

jacks = [
  [0, 50.2],
  [0, 137.8],
];

pots = [
  [0, 62.4],
  [0, 77.3],
  [0, 92.1],
  [0, 107.7],
];

module holes() {
  translate([0.3, 115, 0])
  mirror([0, 1, 0]) {
    for(hole = pots)
      translate([hole[0], hole[1]])
        AlphaPot();
    for(hole = jacks)
      translate([hole[0], hole[1]])
        PJ301();
  }
}


module reinforcements() {
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

difference() {
  union() {
    eurorackPanel(panelHp, 2);
    // walls(panelHp);
    // reinforcements();
  }
  translate([10.5, 85, 0])
  rotate([0, 0, 180])
    holes();
}
