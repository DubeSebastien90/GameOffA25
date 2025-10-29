hspd = 0
vspd = 0

damp = 0.05
stifness = 0.01

handRepulsionStiffness = 0.05
minHandDist = 3

grabbing = false
active = true

myPoulpe = noone
mouseForce = new force(0,0)

_index = 0

myCollision = noone

puissanceTest = 0

index = 0

function angleEstProche(angle1, angle2, tol){
	angle1 = angle1%360
	angle2 = angle2&360
	
	if abs(angle1-angle2) < tol{
		return true
	}
	return false
}

function step(){
	if (myPoulpe == noone) exit;
	
	var pX = myPoulpe.x 
	var pY = myPoulpe.y
	var dir = point_direction(x,y,pX,pY)
	var dist = point_distance(x, y, pX, pY)
	var spd = sqrt(hspd*hspd + vspd*vspd)
	
	gravForce = new force(0,obj_game.grav)
	
	var poulpeStrength = stifness*(dist-myPoulpe.distParfaite)
	if poulpeStrength < 0{
		poulpeStrength = 0
	}
	
	poulpeForce = new force(poulpeStrength*dcos(dir), -poulpeStrength*dsin(dir))
	
	handRepulsionForce = new force(0,0)
	var moi = id; 
	with (obj_mass) {
    if (id != moi) { // ne pas se repousser soi-même
        var handDist = point_distance(x, y, other.x, other.y);
        
        if (handDist < minHandDist && handDist > 0) {
            // Direction de l’autre vers moi
            var handDir = point_direction(x, y, other.x, other.y);
            
            // Intensité inversement proportionnelle à la distance
            var forceMag = (minHandDist - handDist) * handRepulsionStiffness; // 🔧 0.05 = facteur de raideur

            // Ajoute la force de répulsion vers l’extérieur
            other.handRepulsionForce = other.handRepulsionForce.add_force(
                new force(lengthdir_x(forceMag, handDir), lengthdir_y(forceMag, handDir))
            );
        }
    }
}
	
	allForces = handRepulsionForce.add_force(poulpeForce.add_force(gravForce.add_force(mouseForce)))
	
	var nonlinearDamp = damp * (1 + 0.1 * spd);
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

function nearWall() {
    var nearest = noone;
    var bestDist = 1.5; // seuil de proximité maximum
	var moi = self

    with (obj_collision) {
        var d = distance_to_object(moi)
        if (d < bestDist) {
            bestDist = d;
            nearest = id; // on garde une référence à cette instance
        }
    }

    return nearest;
}

function handleMovingBlocks(){
	if (myCollision != noone) {
		x += myCollision.hspd;
		y += myCollision.vspd
	}
}