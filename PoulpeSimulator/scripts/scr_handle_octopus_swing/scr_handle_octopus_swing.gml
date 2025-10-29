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
		} else{
			var firstSegment = arm.masses[1]
			
			var dPull = new vec2(firstSegment.x-x, firstSegment.y-y)
			var distPull = dPull.magnitude()
			
			var targetDist = c_armLength
			
			if (distPull > targetDist){
				var strength = c_stiffnessAir * (distPull-targetDist)
				var pullForce = dPull.scale(strength/distPull)
				totalArmForce = totalArmForce.add_vec2(pullForce)
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
	
	/*var wall = instance_position(x, y, obj_collision);
	if (wall != noone){
		// Calculate the distance to each edge from the particle's position
		var push_left = x - wall.bbox_left
		var push_right = x - wall.bbox_right
		var push_top = y - wall.bbox_top
		var push_bottom = y - wall.bbox_bottom

		// Find the smallest push distance (the one with the smallest absolute value)
		var min_push_x = (abs(push_left) < abs(push_right)) ? push_left : push_right
		var min_push_y = (abs(push_top) < abs(push_bottom)) ? push_top : push_bottom

		// Find out if it's easier to push out horizontally or vertically
		if (abs(min_push_x) < abs(min_push_y)) {
			// Push horizontally
			x -= min_push_x
		} else {
			// Push vertically
			y -= min_push_y
		}

		x += hspd
		y += vspd
	}*/
}