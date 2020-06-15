
//tc electronic box: 74x130x38, rozstaw śrub 100

box_wall=3;
box_width=40-box_wall*2;
box_depth=130;
box_height=38;
box_radius=5;

module power_socket() {
    cylinder(h=box_wall, d=8.5);
}

module jack_socket() {
    cylinder(h=box_wall*2, d=9.5);
}

module switch_socket() {
    cylinder(h=box_wall*2, d=6);
}

module led_socket() {
    cylinder(h=box_wall*2, d=8);
}

module pcb_mount(pcb_width, pcb_depth, pcb_height, wall=2) {
    difference() {
        cube([wall*4,wall+pcb_height,pcb_depth]);
        translate([wall,0,0]) {
            cube([wall*3,pcb_height,pcb_depth]);
        }
    }
    
    translate([pcb_width,0,0]) {
        difference() {
            cube([wall*4,wall+pcb_height,pcb_depth]);
            cube([wall*3,pcb_height,pcb_depth]);
            }
        }
    
}

module rounded_square(width, height, radius) {
    hull() {
        translate([radius, radius, 0]) {
            circle(r=radius);
        }
        translate([width-radius, radius, 0]) {
            circle(r=radius);
        }
        translate([radius, height-radius, 0]) {
            circle(r=radius);
        }
        translate([width-radius, height-radius, 0]) {
            circle(r=radius);
        }
    }
}

module bottom_side(width, height, radius, wall, with_holes=false) {
    rotate([90,0,90]) {
        difference() {
            linear_extrude(wall) {
                hull() {
                    translate([radius, height - radius]) {
                        circle(radius);
                    }
                    translate([width-radius, height-radius]) {
                        circle(radius);
                    }
                    translate([width-radius, 0]) {
                        square(radius, radius);
                    }
                    square(radius, radius);
                }
            }
            
            if (with_holes) {
                translate([6,box_height-6,0]) {
                    cylinder(h=box_wall, d=3);
                }
                translate([box_depth-6,box_height-6,0]) {
                    cylinder(h=box_wall, d=3);
                }
            }
        }
    }
}



module bottom_part() {    
    bottom_side(box_depth,box_height,box_radius,box_wall, with_holes=true);

    translate([box_width-box_wall,0,0]) {    
        bottom_side(box_depth,box_height,box_radius,box_wall, with_holes=true);
    }

    linear_extrude(box_wall) {
        difference() {
            square([box_width, box_depth]);
            translate([box_width/2, box_depth/2-50,0]) {
                circle(d=4);
            }
            translate([box_width/2, box_depth/2+50,0]) {
                circle(d=4);
            }
        }
    }
    
    //pillars
    translate([box_wall,box_depth/3,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }
    
    translate([box_wall,box_depth/3*2,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }
    
    translate([box_width-box_wall*2,box_depth/3,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }
    
    translate([box_width-box_wall*2,box_depth/3*2,box_wall]) {
        cube([box_wall,box_wall,box_height-box_wall*2]);
    }    
}
        
module top_mount() {
    difference() {
        cylinder(h=box_width-box_wall*2, d=7);
        cylinder(h=box_width-box_wall*2, d=3);
    }
}

module top_part() {
    translate([box_wall, 6, box_height-6]) {
        rotate([0,90,0]) {
            difference() {
                top_mount();
            }
        }
    }
    
    translate([box_wall, box_depth-6, box_height-6]) {
        rotate([0,90,0]) {
            difference() {
                top_mount();
            }
        }
    }
    
    difference() {
        translate([box_wall,0,box_wall]) {
            bottom_side(box_depth, box_height-box_wall, box_radius, box_width-box_wall*2);
        }
        
        translate([box_wall,box_wall,box_wall]) {
            bottom_side(box_depth-box_wall*2, box_height-box_wall*2, box_radius, box_width-box_wall*2);
        }
        
        /* bottom sockets
        translate([box_width/2,box_wall,box_height/3]) {
            rotate([90,0,0]) {
                power_socket();
            }
        }
        */
        
        //top sockets
    }
}

module top_part_dc_rf_relay() {
    difference() {
        top_part();

        rotate([90,0,0]) {
            translate([box_width-10, box_height/3, -box_depth]) {
                power_socket();
            }
            
            translate([10, box_height/3, -box_depth]) {
                power_socket();
            }
        }
        
        translate([box_width/2,box_depth-40, box_height-box_wall*2]) {
            switch_socket();
        }
        
        translate([box_width/2,box_depth-52, box_height-box_wall*2]) {
            led_socket();
        }
        
        translate([9,box_depth-32,box_height-1]) {
            linear_extrude(1) {
                text("On/Off", size=4);
            }
        } 
        
        translate([7,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("OUT", size=3);
            }
        }
        
        translate([box_width-12,box_depth-10,box_height-1]) {
            linear_extrude(1) {
                text("IN", size=3);
            }
        }
    }
}

//top_part_dc_rf_relay();

bottom_part();

module bottom_pard_dc_rf_relay() {
    bottom_part();

    translate([box_width-box_wall,25,0]) {
        rotate([0,0,90]) {
            pcb_mount(50,30,3);
        }
    }
}

