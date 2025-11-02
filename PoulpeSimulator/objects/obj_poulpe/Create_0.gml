nbHands = 5
hands = []
distParfaite = 30
distMax = 75
distMaxNoGrab = 100
poulpeMasse = 10
handMasse = 0.5

dampGrabb = 0.1
dampAir = 0.005
stifnessWall = 0.003//0.02
stifnessAir = 0.003
hspd = 0
vspd = 0

control = true

mousePower = 0.15
controls = [0,0,0,0,0]

handsGrabbing = 0;
forceMaxArms = 0.8

baseXScale = 0.065
targetXScale = baseXScale
drawXScale = baseXScale

//sons
fondMarinJoue = false

//bonus
cooldownGoute = 0
cooldownGouteAverage = 10
pupilScale = 1

cooldownBubble = 0
cooldownBubbleAverage = 30

//debug
showHbx = false

for (var i = 0; i < nbHands; i++){
	hand = instance_create_layer(x + (-2+i)*10, y+25,"physics",obj_mass)
	with (hand){
		myPoulpe = other
		index = i
	}
	hands[i] = hand
}

function handleHands(controls){
	centreMasseForce = new force(0,0)
	
	//hands
	for (var i = 0; i < nbHands; i++){
		hand.computeJoints()
		hand = hands[i]
		
		if !hand.active{
			if hand.grabbing{
				hand.handleMovingBlocks()
			} else hand.step()
			continue
		}
		
		if hand.capture{
			var capture = hand.myCapture
			if place_meeting(x,y, capture){
				capture.getEaten()
				hand.capture = false
				hand.myCapture = noone
				regrowArm()
			} else{
				hand.handleCapture()
			}
		}
		
		if controls[i] && control{
			var wall = hand.nearWall();
			var food = hand.nearFood();
			if (!hand.grabbing && !hand.capture){
			if (wall != noone) {
				hand.grabbing = true;
				hand.myCollision = wall;
				handsGrabbing += 1;
				hand.vspd = 0
				hand.hspd = 0
				if wall.bateau && control{
					wall.startBateau()
					for (var j = 0; j < nbHands;j++){
						var _hand = hands[j]
						if i != j{
							_hand.myCapture = noone
							_hand.myCollision = noone
							_hand.grabbing = false
							_hand.capture = false;
						}
					}
				}
				obj_son.play_sound(snd_boup,0.1)
			}else if (food != noone){
				hand.capture = true
				hand.myCapture = food
				food.captured = true
				obj_son.play_sound(snd_boup,0.1)
			}
			}
		} else if control{
			if hand.grabbing == true{
				handsGrabbing -= 1
				obj_son.play_sound(snd_pop,0.1)
			}
			if hand.capture == true{
				hand.myCapture.captured = false
				hand.myCapture.spd = hand.myCapture.spdHurry
				obj_son.play_sound(snd_pop,0.1)
			}
			hand.myCapture = noone
			hand.myCollision = noone
			hand.grabbing = false
			hand.capture = false;
		}
		if !hand.grabbing{
			hand._index = 0
			var mouseDir = point_direction(hand.x,hand.y,mouse_x,mouse_y)
			var distHand = point_distance(x,y,hand.x,hand.y)
			hand.mouseForce.x = dcos(mouseDir)*mousePower
			hand.mouseForce.y = -dsin(mouseDir)*mousePower
			if distHand > distMaxNoGrab{
				briserBras(i)
			}
			hand.step() //a la fin de step - la main a bougé
			//ajouter force sur pieuvre si je grab
			if handsGrabbing != 0{
				if distHand > distParfaite{
					var puissance = stifnessAir*(distHand-(distParfaite))
					var dirHand = point_direction(x,y,hand.x, hand.y)
					centreMasseForce = centreMasseForce.add_force(new force(dcos(dirHand)*puissance,-dsin(dirHand)*puissance))
				}
			}
		} else{
			hand.handleMovingBlocks()
			hand._index = 1
			//ajouter force sur pieuvre
			var distHand = point_distance(x,y,hand.x,hand.y)
			if distHand > distParfaite{
				var puissance = stifnessWall*(distHand-(distParfaite))
				if distHand > distMax{
					briserBras(i)
				}
				if puissance < 0{
					puissance = 0
				}
				var dirHand = point_direction(x,y,hand.x, hand.y)
				
				centreMasseForce = centreMasseForce.add_force(new force(dcos(dirHand)*puissance,-dsin(dirHand)*puissance))
				
				if hand.myCollision != noone{
					//TODO donner vitesse à poulpe
					//centreMasseForce = centreMasseForce.add_force(new force(hand.myCollision.hspd,hand.myCollision.vspd))
				}
			}
		}
	}
	
	//poulpe
	var tempDamp = dampGrabb
	if handsGrabbing == 0{
		tempDamp = dampAir
	} 
	gravForce = new force(0,obj_game.grav*1)
	
	if place_meeting(x,y+1,obj_collision){
		tempDamp = dampGrabb
	}
	
	if place_meeting(x,y+1,obj_collision_noGrab){
		tempDamp = 0
	}
	
	allForces = centreMasseForce.add_force(gravForce)

	
	var _spd = point_distance(0,0,hspd,vspd);
	var nonlinearDamp = tempDamp * (1 + 0.1 * _spd);
	frictionForce = new force(nonlinearDamp * hspd, nonlinearDamp * vspd);
	
	allForces = allForces.sub_force(frictionForce)
	
	hspd += allForces.x
	vspd += allForces.y
	
	
	if place_meeting(x+hspd,y+vspd,obj_collision_noGrab){
		var collision = instance_place(x+hspd,y+vspd,obj_collision_noGrab)
		var normal_angle = calculateCollisionNormal(x,y,collision.p1,collision.p2,collision.p3,collision.p4,collision.center, collision.circular)
		var nx = lengthdir_x(1, normal_angle); // normal x
		var ny = lengthdir_y(1, normal_angle); // normal y

		
		var totalSpd = point_distance(0,0,hspd,vspd)
		var tanAngle = normal_angle + 90
		
		var dirSpd = point_direction(0, 0, hspd, vspd);
		
		var tanDot = dcos(dirSpd - tanAngle);
		
		if (tanDot < 0)
			tanAngle += 180;
		hspd = lengthdir_x(totalSpd, tanAngle);
		vspd = lengthdir_y(totalSpd, tanAngle);
	}
	

		var inst = instance_place(x, y, obj_collision_mouvante);

			if (inst != noone) {
				var normal_angle = calculateCollisionNormal(x,y,inst.p1, inst.p2, inst.p3, inst.p4, inst.center, inst.circular)
				var nx = lengthdir_x(1, normal_angle);
				var ny = lengthdir_y(1, normal_angle);
	
				var safety = 100; // pour éviter boucles infinies
	
				repeat (safety) {
					if (!place_meeting(x, y, obj_collision_mouvante))
						break;
					x += nx * 0.1;
					y += ny * 0.1;
				}
			}

	var collisions = ds_list_create();
	collision_point_list(x + hspd, y + vspd, obj_collision, false, true, collisions, true);

	if (ds_list_size(collisions) > 0) {
		var new_hspd = hspd;
		var new_vspd = vspd;

		for (var i = 0; i < ds_list_size(collisions); i++) {
			var c = collisions[| i];
		
			var normal_angle = calculateCollisionNormal(
				x, y,
				c.p1, c.p2, c.p3, c.p4, c.center, c.circular
			);
		
			// Vecteur normal unitaire
			var nx = lengthdir_x(1, normal_angle);
			var ny = lengthdir_y(1, normal_angle);
		
			// Produit scalaire entre la vitesse et la normale
			var dot_n = new_hspd * nx + new_vspd * ny;
		
			// Si la vitesse entre dans la surface (dot_n < 0), on la retire
			// Si la vitesse entre dans la surface (dot_n < 0), on la retire
			if (dot_n < 0) {
				new_hspd -= dot_n * nx;
				new_vspd -= dot_n * ny;
			}
		}
	
		hspd = new_hspd;
		vspd = new_vspd;
		
	}

	ds_list_destroy(collisions);
	
	x += hspd
	y += vspd
	
	//bonus
	var hspdPoulpe = hspd
	var vspdPoulpe = vspd
	
	if(point_distance(0,0,hspd, vspd) > 1){
		if !fondMarinJoue{
			fondMarinJoue = true
			alarm[0] = 60
			obj_son.play_random_sound([snd_sous_marin1,snd_sous_marin2,snd_sous_marin3],0.5)
		}
	}
	
	if(point_distance(0,0,hspd, vspd) > 1){
		if cooldownBubble < 0{
			cooldownBubble = cooldownBubbleAverage + random_range(0,10)
			with(instance_create_layer(x,y-6,"particules",obj_bulle)){
				_hspd = hspdPoulpe
				_vspd = vspdPoulpe
			}
		}
	}
	
	if vspd > 1.2{
		if handsGrabbing == 0{
			if cooldownGoute < 0{
				cooldownGoute = cooldownGouteAverage
				with(instance_create_layer(x,y-6,"particules",obj_part_goutte)){
					_hspd = hspdPoulpe
				}
				pupilScale = lerp(pupilScale,1+(((vspd/1.2)-1)*0.8),0.1)
				pupilScale = min(pupilScale,2)
			}
		}
	}	else{
		pupilScale = lerp(pupilScale,1,0.1)
	}
	cooldownGoute -= 1
	cooldownBubble -= 1

}

function calculateCollisionNormal(poulpeX, poulpeY, p1, p2, p3, p4, collisionCenter, circular){
	
	if (circular){
		var angle = (point_direction(collisionCenter.x,collisionCenter.y,poulpeX,poulpeY)) mod 360
		return angle
	}
	// Direction from center of rectangle to the collision point
    var dirToPoulpe = point_direction(collisionCenter.x, collisionCenter.y, poulpeX, poulpeY);

    // Angles from center to each corner
    var angP1 = point_direction(collisionCenter.x, collisionCenter.y, p1.x, p1.y);
    var angP2 = point_direction(collisionCenter.x, collisionCenter.y, p2.x, p2.y);
    var angP3 = point_direction(collisionCenter.x, collisionCenter.y, p3.x, p3.y);
    var angP4 = point_direction(collisionCenter.x, collisionCenter.y, p4.x, p4.y);
	
	// Normalize angles to 0–360
    angP1 = (angP1 + 360) mod 360;
    angP2 = (angP2 + 360) mod 360;
    angP3 = (angP3 + 360) mod 360;
    angP4 = (angP4 + 360) mod 360;
    dirToPoulpe = (dirToPoulpe + 360) mod 360;
	
	// Helper for testing if an angle is between two others (circularly)
    function angle_in_range(a, _min, _max) {
        var diff1 = angle_difference(_min, a);
        var diff2 = angle_difference(a, _max);
        return (diff1 >= 0 && diff2 >= 0);
    }
	
	var normal_angle;

    // --- Check which side we hit ---
    if (angle_in_range(dirToPoulpe, angP1, angP2)) {
        // Top edge (p1 → p2)
        var edge_angle = point_direction(p1.x, p1.y, p2.x, p2.y);
        normal_angle = edge_angle - 90;
    }
    else if (angle_in_range(dirToPoulpe, angP2, angP4)) {
        // Right edge (p2 → p4)
        var edge_angle = point_direction(p2.x, p2.y, p4.x, p4.y);
        normal_angle = edge_angle - 90;
    }
    else if (angle_in_range(dirToPoulpe, angP4, angP3)) {
        // Bottom edge (p4 → p3)
        var edge_angle = point_direction(p4.x, p4.y, p3.x, p3.y);
        normal_angle = edge_angle - 90;
    }
    else {
        // Left edge (p3 → p1)
        var edge_angle = point_direction(p3.x, p3.y, p1.x, p1.y);
        normal_angle = edge_angle - 90;
    }

    // Normalize angle
    normal_angle = (normal_angle + 180) mod 360;

    return normal_angle;
}

function regrowArm(){
	obj_son.play_sound(snd_crounch,0.2)
	for (var i = 0; i < nbHands; i++){
		hand = hands[i]
		if (!hand.active){
			obj_son.play_sound(snd_growing,0.1)
			var ghost = instance_create_layer(hand.x,hand.y,hand.layer,obj_ghost_mass)
			ghost.x = hand.x
			ghost.y = hand.y
			ghost.grabbing = hand.grabbing
			ghost.myPoulpe = hand.myPoulpe
			ghost.myCollision = hand.myCollision
			ghost.pX = hand.pX
			ghost.pY = hand.pY
			ghost._index = hand._index
			
			hand.active = true
			hand.grabbing = false
			hand.x = x + dcos(point_direction(x,y,mouse_x,mouse_y)) * min(distParfaite,point_distance(x,y,mouse_x,mouse_y))
			hand.y = y - dsin(point_direction(x,y,mouse_x,mouse_y)) * min(distParfaite,point_distance(x,y,mouse_x,mouse_y))
			hand.pX = x
			hand.pY = y
			
			hand.vspd = 0
			hand.hspd = 0
			var nbJoints = array_length(hand.joints)
			for (var j = 0; j < nbJoints; j++){
				ghost.joints[i] = hand.joints[i]
				hand.joints[j].x = x + dcos(point_direction(x,y,mouse_x,mouse_y)) * min(distParfaite,point_distance(x,y,mouse_x,mouse_y))
				hand.joints[j].y = y - dsin(point_direction(x,y,mouse_x,mouse_y)) * min(distParfaite,point_distance(x,y,mouse_x,mouse_y))
			}
			return
		}
	}
}

function briserBras(index){
	if control{
	hands[index].active = false
	if hands[index].grabbing{
		handsGrabbing -= 1
	}
	if hands[index].capture{
		hands[index].capture = false
		hands[index].myCapture.captured = false
		hands[index].myCapture = noone
	}
	screenShake(5,10)
	obj_son.play_sound(snd_tentacleRippOff,0.1)
	}
}