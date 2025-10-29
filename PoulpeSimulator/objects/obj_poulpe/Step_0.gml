var controls = [
	keyboard_check(ord("Q")),
	keyboard_check(ord("W")),
	keyboard_check(ord("E")),
	keyboard_check(ord("R")),
	keyboard_check(vk_space)
]

var dt = delta_time / 1000000.0
var dt_sq = dt * dt

for (var a = 0; a < c_nbArms; a++) {
    var arm = myArms[a];
    
    arm.checkGrapple(controls[a]); 
    
    arm.updatePhysics(x, y, dt_sq); 
}

handle_octopus_swing()
