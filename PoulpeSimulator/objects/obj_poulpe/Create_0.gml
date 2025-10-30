nbHands = 5
hands = []
distParfaite = 30
distMax = 80
poulpeMasse = 10
handMasse = 0.5

dampGrabb = 0.1
dampAir = 0.005
stifnessWall = 0.02
stifnessAir = 0.005
hspd = 0
vspd = 0

mousePower = 0.15
controls = [0,0,0,0,0]

handsGrabbing = 0;
forceMaxArms = 0.8

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
		
		if controls[i]{
			var wall = hand.nearWall();
			if (!hand.grabbing && wall != noone) {
				hand.grabbing = true;
				hand.myCollision = wall;
				handsGrabbing += 1;
				hand.vspd = 0
				hand.hspd = 0
				obj_son.play_sound(snd_boup,0.1)
			}
		} else{
			if hand.grabbing == true{
				handsGrabbing -= 1
				obj_son.play_sound(snd_pop,0.1)
			}
			hand.myCollision = noone
			hand.grabbing = false
		}
		if !hand.grabbing{
			hand._index = 0
			var mouseDir = point_direction(hand.x,hand.y,mouse_x,mouse_y)
			var distHand = point_distance(x,y,hand.x,hand.y)
			hand.mouseForce.x = dcos(mouseDir)*mousePower
			hand.mouseForce.y = -dsin(mouseDir)*mousePower
			if distHand > distMax{
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
	
	allForces = centreMasseForce.add_force(gravForce)

	
	var _spd = point_distance(0,0,hspd,vspd);
	var nonlinearDamp = tempDamp * (1 + 0.1 * _spd);
	frictionForce = new force(nonlinearDamp * hspd, nonlinearDamp * vspd);
	
	allForces = allForces.sub_force(frictionForce)
	
	hspd += allForces.x
	vspd += allForces.y
	
	var inst = instance_place(x, y, obj_collision_mouvante);

	if (inst != noone) {
		while (place_meeting(x, y, obj_collision_mouvante)) {
			x += sign(inst.hspd);
			y += sign(inst.vspd)
		}
	}
	
	if place_meeting(x,y+vspd,obj_collision){
	var collision = instance_place(x, y+vspd, obj_collision);
	while!(place_meeting(x,y+sign(vspd),obj_collision)){
		y += sign(vspd)
	}
	var normal_angle = calculateCollisionNormal(x,y,collision.p1,collision.p2,collision.p3,collision.p4,collision.center)
	var nx = dcos(normal_angle);
	var ny = dsin(normal_angle);

	var dot = hspd*nx + vspd*ny;

	var b = 0.8; // rebond 80%
	hspd += (1 + b)*dot*nx;
	vspd = 0
	}
	
	if place_meeting(x+hspd,y,obj_collision){
	var collision = instance_place(x+hspd, y, obj_collision);
	while!(place_meeting(x+sign(hspd),y,obj_collision)){
		x += sign(hspd)
	}
	var normal_angle = calculateCollisionNormal(x,y,collision.p1,collision.p2,collision.p3,collision.p4,collision.center)
	var nx = dcos(normal_angle);
	var ny = dsin(normal_angle);

	var dot = hspd*nx + vspd*ny;

	var b = 0.8; // rebond 80%
	hspd = 0
	vspd += (1 + b)*dot*ny;
	}
	
	if place_meeting(x+hspd,y+vspd,obj_collision){
		hspd = 0
		vspd = 0
	}
	
	x += hspd
	y += vspd
}

function calculateCollisionNormal(poulpeX, poulpeY, p1, p2, p3, p4, collisionCenter){
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

function briserBras(index){
	hands[index].active = false
	if hands[index].grabbing{
		handsGrabbing -= 1
	}
	hands[index]._index = 2
	screenShake(5,10)
	obj_son.play_sound(snd_tentacleRippOff,0.1)
}