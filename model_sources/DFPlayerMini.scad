// Model of a DFPlayer Mini
// Use Wings3D to convert the STL to .wrl (VRML) to make it
// usable in KiCad's 3D PCB viewer

function inch(x) = x*25.4;

module DFPlayerMini() {
    board_w = 21;
    board_l = 21;
    board_th = 1.6;
    
    pin_ascent  = 2.9;
    pin_descent = 8.3;  // depth below pin support
    pin_height = pin_ascent + pin_descent;
    pin_size    = 0.63;  // square pins
    pin_spacing = inch(0.1);
    pin_separation = inch(0.7);
    pin_count   = 16;  // 8 on each side, like a DIP

    support_h = 3.0;
    support_w = pin_spacing*0.95;
    support_l = (pin_count/2 - 0.05) * pin_spacing;
    
    card_slot_w = 15;
    card_slot_l = 15;
    card_slot_h = 2.0;    

    // In the x-y plane, the reference point will be the center of pin 1.
    // Along the z-axis, the reference is the bottom of the pin supports.
    pin_x1 = -pin_separation/2;
    pin_y1 = (pin_count / 2 - 1) * pin_spacing / 2;

    translate([-pin_x1, -pin_y1, support_h]) {
        color("green")
        linear_extrude(board_th) {
            difference() {
                square([board_w, board_l], center=true);
                translate([0, board_l/2]) circle(d=2.7, $fs=0.2);
            }
        }
        color("silver")
        translate([0, -(board_l - card_slot_l)/2, board_th]) {
            linear_extrude(card_slot_h) {
                square([card_slot_w, card_slot_l], center=true);
            }
        }
    }

    color("yellow")
    translate([0, 0, -pin_descent + support_h]) {
        linear_extrude(pin_height) {
            assert(pin_count % 2 == 0);
            for (i = [0:pin_count/2-1]) {
                translate([0, -i * pin_spacing]) {
                    square(pin_size, center=true);
                    translate([pin_separation, 0])
                        square(pin_size, center=true);
                }
            }
        }
    }
    
    color("black")
    translate([-pin_spacing/2, pin_spacing/2 - support_l]) {
        linear_extrude(support_h) {
            square([support_w, support_l]);
            translate([pin_separation, 0]) square([support_w, support_l]);
        }
    }
}

// We're going to use Wings3D to convert the STL to VRML.
// Wing3D uses units of 0.1 inch, and this OpenSCAD model uses 1 mm.
scale(1 / 2.54) {
    DFPlayerMini();
}

