nbHands = 5
hands = []
distParfaite = 30
bufferDist = 2
poulpeMasse = 10
handMasse = 0.5

damp = 0.1
stifnessWall = 0.02
stifnessAir = 0.005
hspd = 0
vspd = 0

mousePower = 0.15
controls = [0,0,0,0,0]

handsGrabbing = 0;

for (var i = 0; i < nbHands; i++){
	hand = instance_create_layer(x + (-2+i)*10, y+25,"physics",obj_mass)
	hand.myPoulpe = self
	hands[i] = hand
}

function handleHands(controls){
	centreMasseForce = force_create(0,0)
	
	//hands
	for (var i = 0; i < nbHands; i++){
		hand = hands[i]
		if controls[i]{
			if mouse_check_button(mb_left) && !hand.grabbing && hand.nearWall(){
				hand.grabbing = true
				handsGrabbing += 1
			} else{
			var mouseDir = point_direction(x,y,mouse_x,mouse_y)
			hand.mouseForce.x = dcos(mouseDir)*mousePower
			hand.mouseForce.y = -dsin(mouseDir)*mousePower
			}
		} else{
			hand.mouseForce = force_create(0,0)
			if hand.grabbing == true{
				handsGrabbing -= 1
			}
			hand.grabbing = false
		}
		if !hand.grabbing{
			hand.step() //a la fin de step - la main a bougé
			//ajouter force sur pieuvre si je grab
			if handsGrabbing != 0 && controls[i]{
				var distHand = point_distance(x,y,hand.x,hand.y)
				if distHand > distParfaite-bufferDist{
					var puissance = stifnessAir*(distHand-(distParfaite-bufferDist))
					var dirHand = point_direction(x,y,hand.x, hand.y)
					centreMasseForce = add_forces(centreMasseForce, force_create(dcos(dirHand)*puissance,-dsin(dirHand)*puissance))
				}
			}
		} else{
			//ajouter force sur pieuvre
			var distHand = point_distance(x,y,hand.x,hand.y)
			if distHand > distParfaite-bufferDist{
				var puissance = stifnessWall*(distHand-(distParfaite-bufferDist))
				var dirHand = point_direction(x,y,hand.x, hand.y)
				centreMasseForce = add_forces(centreMasseForce, force_create(dcos(dirHand)*puissance,-dsin(dirHand)*puissance))
			}
		}
	}
	
	//poulpe
	if handsGrabbing == 0{
	gravForce = force_create(0,obj_game.grav*10)
	} else gravForce = force_create(0,obj_game.grav*2)
	
	allForces = add_forces(centreMasseForce, gravForce)
	
	frictionForce = force_create(damp*hspd, damp*vspd)
	
	allForces = sub_forces(allForces, frictionForce)
	
	hspd += allForces.x
	vspd += allForces.y
	
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