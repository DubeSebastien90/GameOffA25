hspd = 0
vspd = 0
c_dampGrab = 0.1
c_dampAir = 0.005
c_stiffnessGrab = 0.02
c_stiffnessAir = 0.005

c_nbConstraintIteration = 8

c_nbArms = 5
c_nbSegments = 6
c_indexGripper = c_nbSegments - 1
c_armLength = 5
c_armStrength = 300
c_armStiffness = 0.005
c_grabRadius = 3
c_pushStrength = 0.04
myArms = []

for (var a = 0; a < c_nbArms; a++){
	var new_arm = new Arm(x, y)
	array_push(myArms, new_arm)
}

function Mass(_x, _y) constructor{
	x = _x
	y = _y
	xPrev = _x
	yPrev = _y
}

function Arm(_x, _y) constructor{
	masses = []
	poulpe = obj_poulpe

	isGrappled = false	
	isTargetMoving = false
	grappledTarget = noone
	grappledTarget = noone
	localGrapple = new vec2(0, 0)
	staticGrapple = new vec2(0, 0)
	
	for (var s = 0; s < poulpe.c_nbSegments; s++){
		array_push(masses, new Mass(_x, _y))
	}
	
	static updatePhysics = function(_x, _y, dt_sq){
		var gripper = masses[poulpe.c_indexGripper]
		var currDamp = 1 - (isGrappled ? poulpe.c_dampGrab : poulpe.c_dampAir)
		var currStiffness = isGrappled ? poulpe.c_stiffnessGrab : poulpe.c_stiffnessAir
		
		//Root follow head
		masses[0].x = _x
		masses[0].y = _y
		masses[0].xPrev = _x
		masses[0].yPrev = _y
		
		//Integrate
		for (var s = 1; s < poulpe.c_nbSegments; s++){
			var mass = masses[s]
			
			var xVel = (mass.x-mass.xPrev) * currDamp
			var yVel = (mass.y-mass.yPrev) * currDamp
			
			mass.xPrev = mass.x
			mass.yPrev = mass.y
			
			var acc = new vec2(0, obj_game.grav)
			
			if (s == poulpe.c_indexGripper && !isGrappled){
				var mouseForce = applyMousePull(mass)
				acc = acc.add_vec2(mouseForce)
			}
			
			mass.x += xVel + acc.x * dt_sq
			mass.y += yVel + acc.y * dt_sq
		}
		
		//Constraints
		for (var i = 0; i < poulpe.c_nbConstraintIteration; i++){
			for (var s = 1; s < poulpe.c_nbSegments; s++){
				solveCollision(masses[s])
			}
			if (isGrappled){
				var anchorPos = getGrappleWorldPos();
				gripper.x = anchorPos.x
				gripper.y = anchorPos.y
				gripper.xPrev = anchorPos.x
				gripper.yPrev = anchorPos.y
			}
			for (var s = 0; s < poulpe.c_indexGripper; s++){
				var m1 = masses[s]
				var m2 = masses[s+1]
				solveConstraint(m1, m2, currStiffness)
			}
		}
	}
	
	static drawArm = function(){
		for (var s = 0; s < poulpe.c_nbSegments; s++){
			if (s == poulpe.c_indexGripper && isGrappled) draw_sprite(spr_mass, 1, masses[s].x, masses[s].y)
			else draw_sprite(spr_mass, 0, masses[s].x, masses[s].y)
		}
	}
	
	static checkGrapple = function(control){
		var gripper = masses[poulpe.c_indexGripper]
		
		if (control && !isGrappled){
			var movingTarget = collision_circle(gripper.x, gripper.y, poulpe.c_grabRadius, obj_collision_mouvante, false, true)
			if (instance_exists(movingTarget)){
				isGrappled = true
				isTargetMoving = true
				grappledTarget = movingTarget
				localGrapple = new vec2(gripper.x-movingTarget.x, gripper.y-movingTarget.y)
				return
			}
			var staticTarget = collision_circle(gripper.x, gripper.y, poulpe.c_grabRadius, obj_collision, false, true)
			if (instance_exists(staticTarget)){
				isGrappled = true
				isTargetMoving = false
				staticGrapple = new vec2(gripper.x, gripper.y)
				return
			}
		}
		if (!control && isGrappled){
			isGrappled = false
			isTargetMoving = false
			grappledTarget = noone
		}
	}
		
	//Helper functions
	static applyMousePull = function(mass){
		var d = new vec2(mouse_x-mass.x, mouse_y-mass.y)
		var dist = point_distance(0, 0, d.x, d.y)
		
		if (dist > 1) {
			return new vec2((d.x/dist)*poulpe.c_armStrength, (d.y/dist)*poulpe.c_armStrength)
		}	
		return new vec2(0,0)
	}
	
	static getGrappleWorldPos = function(){
		if (isTargetMoving){
			if (instance_exists(grappledTarget)){
				return new vec2(grappledTarget.x+localGrapple.x, grappledTarget.y+localGrapple.y)
			} else{
				isGrappled = false
				return new vec2(masses[poulpe.c_indexGripper].x, masses[poulpe.c_indexGripper].y)
			}
		} else{
			return staticGrapple
		}
	}
	
	static solveConstraint = function(m1, m2, stiffness){
		var d = new vec2(m2.x-m1.x, m2.y-m1.y)
		var dist = d.magnitude()
		
		var diff = (dist-poulpe.c_armLength) / max(dist, 0.0001)
		
		var correctX = d.x*0.5*diff*stiffness
		var correctY = d.y*0.5*diff*stiffness
		
		m1.x += correctX
		m1.y += correctY
		m2.x -= correctX
		m2.y -= correctY
	}
	
	static solveCollision = function(m){
		var wall = instance_position(m.x, m.y, obj_collision);
	    if (wall == noone) return;

	    // Calculate the distance to each edge from the particle's position
	    var push_left = m.x - wall.bbox_left
	    var push_right = m.x - wall.bbox_right
	    var push_top = m.y - wall.bbox_top
	    var push_bottom = m.y - wall.bbox_bottom

	    // Find the smallest push distance (the one with the smallest absolute value)
	    var min_push_x = (abs(push_left) < abs(push_right)) ? push_left : push_right
	    var min_push_y = (abs(push_top) < abs(push_bottom)) ? push_top : push_bottom

	    // Find out if it's easier to push out horizontally or vertically
	    if (abs(min_push_x) < abs(min_push_y)) {
	        // Push horizontally
	        m.x -= min_push_x
			m.xPrev = m.x
	    } else {
	        // Push vertically
	        m.y -= min_push_y
			m.yPrev = m.y
	    }
	}
}