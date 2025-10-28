hspd = 0
vspd = 0

damp = 0.05
stifness = 0.01

grabbing = false

myPoulpe = noone
mouseForce = force_create(0,0)

function angleEstProche(angle1, angle2, tol){
	angle1 = angle1%360
	angle2 = angle2&360
	
	if abs(angle1-angle2) < tol{
		return true
	}
	return false
}

function step(){
	
	var pX = myPoulpe.x 
	var pY = myPoulpe.y
	var dir = point_direction(x,y,pX,pY)
	var dist = point_distance(x, y, pX, pY)
	var spd = sqrt(hspd*hspd + vspd*vspd)
	
	gravForce = force_create(0,obj_game.grav)
	
	var poulpeStrength = stifness*(dist-myPoulpe.distParfaite)
	
	poulpeForce = force_create(poulpeStrength*dcos(dir), -poulpeStrength*dsin(dir))
	
	allForces = add_forces(add_forces(poulpeForce,gravForce),mouseForce)
	
	frictionForce = force_create(damp*hspd, damp*vspd)
	
	allForces = sub_forces(allForces,frictionForce)

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

function nearWall(){
	if distance_to_object(obj_collision) < 1 {
		return true
	}
	return false
}