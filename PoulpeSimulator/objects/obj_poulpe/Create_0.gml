nbHands = 5
hands = []
distParfaite = 30
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
			}
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
			hand.mouseForce.x = dcos(mouseDir)*mousePower
			hand.mouseForce.y = -dsin(mouseDir)*mousePower
			
			hand.step() //a la fin de step - la main a bougé
			//ajouter force sur pieuvre si je grab
			if handsGrabbing != 0{
				var distHand = point_distance(x,y,hand.x,hand.y)
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
				if puissance > forceMaxArms{
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
	while!(place_meeting(x,y+sign(vspd),obj_collision)){
		y += sign(vspd)
	}
	vspd = 0
	}
	
	if place_meeting(x+hspd,y,obj_collision){
	while!(place_meeting(x+sign(hspd),y,obj_collision)){
		x += sign(hspd)
	}
	hspd = 0
	}
	
	if place_meeting(x+hspd,y+vspd,obj_collision){
	while!(place_meeting(x+sign(hspd),y+sign(vspd),obj_collision)){
		x += sign(hspd)
		y += sign(vspd)
	}
	hspd = 0
	vspd = 0
	}
	
	x += hspd
	y += vspd
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