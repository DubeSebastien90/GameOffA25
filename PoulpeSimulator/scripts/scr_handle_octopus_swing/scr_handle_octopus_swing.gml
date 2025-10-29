function handle_octopus_swing(){
	var totalArmForce = new vec2(0,0)
	var _gravity = new vec2(0, obj_game.grav)
	var isSwinging = false
	
	for (var a = 0; a < c_nbArms; a++){
		var arm = myArms[a]
		if (arm.isGrappled){
			isSwinging = true
			
			var gripper = arm.masses[c_indexGripper]
			
			var dTension = new vec2(gripper.x-x, gripper.y-y)
			var distTension = dTension.magnitude()
			var targetDist = c_armLength * c_nbSegments
			
			if (distTension > targetDist){
				var strength = c_armStiffness * (distTension-targetDist)
				var tensionForce = dTension.scale(strength/distTension)
				totalArmForce = totalArmForce.add_vec2(tensionForce)
			}
			
			var dPush = new vec2(mouse_x-gripper.x, mouse_y-gripper.y)
			var distPush = dPush.magnitude()
			
			if (distPush > 1){
				var pushForce = dPush.scale(c_pushStrength/distPush)
				totalArmForce = totalArmForce.add_vec2(pushForce)
			}
		}
	}
	
	var allForce = totalArmForce.add_vec2(_gravity)
	
	var isGrounded = place_meeting(x, y+1, obj_collision)
	var tempDamp = (isSwinging || isGrounded) ? c_dampGrab : c_dampAir
	
	var _spd = point_distance(0,0,hspd,vspd)
	var nonLinearDamp = tempDamp * (1+0.1*_spd)
	
	var frictionForce = new vec2(nonLinearDamp*hspd, nonLinearDamp*vspd)
	
	allForce = allForce.sub_vec2(frictionForce)
	
	hspd += allForce.x
	vspd += allForce.y
	
	if (place_meeting(x+hspd, y, obj_collision)){
		while (!place_meeting(x+sign(hspd), y, obj_collision)){
			x += sign(hspd)
		}
		hspd = 0
	}
	if (place_meeting(x, y+vspd, obj_collision)){
		while (!place_meeting(x, y+sign(vspd), obj_collision)){
			y += sign(vspd)
		}
		vspd = 0
	}
	
	x += hspd
	y += vspd
}