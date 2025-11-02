hspd = 0
vspd = 0

damp = 0.05
stifness = 0.01

collisionBuffer = 1

handRepulsionStiffness = 0.05
minHandDist = 3

grabbing = false
active = true
capture = false

myCapture = noone
myPoulpe = noone
mouseForce = new force(0,0)

_index = 0

myCollision = noone

puissanceTest = 0

index = 0

poulpeCirconference = 0
nbJoints = 10

c_root_width = 10
c_tip_width = 1
c_wobbleAmplitude = 4
c_wobbleSpeed = 0.005
c_wobblePhase = 0.3
randomise()
wobbleSeed = random(1000)

for (var i = 0; i < nbJoints; i++){
	joints[i] = new force(0,0)
	offset[i] = 0
}
temps = random_range(0,360)
vitesseBras = 10

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
	
	if (!active){
		allForces = gravForce
	}
	
	var nonlinearDamp = damp * (1 + 0.1 * spd);
	frictionForce = new force(nonlinearDamp * hspd, nonlinearDamp * vspd);
	
	allForces = allForces.sub_force(frictionForce)

	hspd += allForces.x
	vspd += allForces.y
	
	
	
/// Smooth collision

testerCollision = true

if testerCollision{
	var inst = instance_place(x, y, obj_collision_mouvante);

	if (inst != noone) {
		var normal_angle = point_direction(inst.center.x, inst.center.y, x, y);
		var nx = lengthdir_x(1, normal_angle);
		var ny = lengthdir_y(1, normal_angle);
	
		var safety = 100; // pour éviter boucles infinies
	
		repeat (safety) {
			if (!place_meeting(x, y, obj_collision_mouvante))
				break;
			x += nx * 0.5;
			y += ny * 0.5;
		}
	}
	
	var collisions = ds_list_create();
collision_point_list(x + hspd, y + vspd, obj_collision, false, true, collisions, true);

if (ds_list_size(collisions) > 0) {
	var new_hspd = hspd;
	var new_vspd = vspd;

	for (var i = 0; i < ds_list_size(collisions); i++) {
		var c = collisions[| i];
		
		var normal_angle = myPoulpe.calculateCollisionNormal(
			x, y,
			c.p1, c.p2, c.p3, c.p4, c.center, c.circular
		);
		
		// Vecteur normal unitaire
		var nx = lengthdir_x(1, normal_angle);
		var ny = lengthdir_y(1, normal_angle);
		
		// Produit scalaire entre la vitesse et la normale
		var dot_n = new_hspd * nx + new_vspd * ny;
		
		// Si la vitesse entre dans la surface (dot_n < 0), on la retire
		if (dot_n < 0) {
			new_hspd -= dot_n * nx;
			new_vspd -= dot_n * ny;
		}
		
		// Debug visuel (facultatif)
		draw_line(x, y, x + nx * 16, y + ny * 16); // normale
		draw_line(x, y, x + new_hspd, y + new_vspd); // nouvelle vitesse
	}
	
	hspd = new_hspd;
	vspd = new_vspd;
}

ds_list_destroy(collisions);

	
} else {
	
	var inst = instance_place(x, y, obj_collision_mouvante);

	if (inst != noone) {
		while (place_meeting(x, y, obj_collision_mouvante)) {
			x += sign(inst.hspd);
			y += sign(inst.vspd)
		}
	}

var buffer_step = 0.1;
var slide_damp = 0.95;

// --- COLLISION VERTICALE ---
if (place_meeting(x, y + vspd, obj_collision))
{
	var tempX = 0
	if (!place_meeting(x-collisionBuffer,y+vspd,obj_collision) && (abs(vspd) > abs(hspd))){
		while(place_meeting(x-tempX,y+vspd,obj_collision)){
			tempX += 0.1
		}
		x -= tempX
	}else if (!place_meeting(x+collisionBuffer,y+vspd,obj_collision) && (abs(vspd) > abs(hspd))){
		while(place_meeting(x+tempX,y+vspd,obj_collision)){
			tempX += 0.1
		}
		x += tempX
	} else{
        while (!place_meeting(x, y + sign(vspd), obj_collision))
        {
            y += sign(vspd);
        }
        vspd = 0;
	}
}

// --- COLLISION HORIZONTALE ---
if (place_meeting(x + hspd, y, obj_collision))
{
	var tempY = 0
	if (!place_meeting(x+hspd,y-collisionBuffer,obj_collision) && (abs(hspd) > abs(vspd))){
		while(place_meeting(x+hspd,y-tempY,obj_collision)){
			tempY += 0.1
		}
		y -= tempY
	}else if (!place_meeting(x+hspd,y+collisionBuffer,obj_collision) && (abs(hspd) > abs(vspd))){
		while(place_meeting(x+hspd,y+tempY,obj_collision)){
			tempY += 0.1
		}
		y += tempY
	} else{
        while (!place_meeting(x + sign(hspd), y, obj_collision))
        {
            x += sign(hspd);
        }
        hspd = 0;
	}
}


	
	if place_meeting(x+hspd,y+vspd,obj_collision){
	while!(place_meeting(x+sign(hspd),y+sign(vspd),obj_collision)){
		x += sign(hspd)
		y += sign(vspd)
	}
	hspd = 0
	vspd = 0
	}
	
} //fin tester collision
	
	x += hspd
	y += vspd
}

function computeJoints(){
	//joints
	if (active){
	pX = myPoulpe.x
	pY = myPoulpe.y
	} else{
		pX = lerp(pX,x,0.01)
		pY = lerp(pY,y+obj_poulpe.distParfaite*1.5,0.1)
	}
	var dist = point_distance(x, y, pX, pY)
	var effectiveDist = max(dist - poulpeCirconference, 0);
	var invDir = point_direction(pX, pY, x, y);
	// espacement entre chaque joint
	var _step = effectiveDist / (nbJoints + 1);

	var relVx = hspd - myPoulpe.hspd;
	var relVy = vspd - myPoulpe.vspd;
	var vitesseRelative = sqrt(relVx * relVx + relVy * relVy);
	var vitesseBrasEnFonctionDeVitesse = vitesseBras + vitesseRelative * 0.5;


	temps += 10
	for (var i = 0; i < nbJoints; i++) {
		if active{
		var baseOffset = dsin(temps + i * vitesseBrasEnFonctionDeVitesse) * vitesseRelative*3;
		var weight = 1;

		if (i < 3) {
			weight = i / 3; // 0 → 1 sur les 3 premiers
		} else if (i > nbJoints - 4) {
			weight = (nbJoints - 1 - i) / 3; // 1 → 0 sur les 3 derniers
		}

		offset[i] = baseOffset * weight;
		} 
		var distFromPoulpe = poulpeCirconference + _step * (i + 1);
		var jx = pX + lengthdir_x(distFromPoulpe, invDir);
		var jy = pY + lengthdir_y(distFromPoulpe, invDir);

		// on stocke un struct "force" {x, y}
		joints[i] = { x: jx, y: jy };
	}
}

function nearWall() {
    var radius = 2; // 🔧 distance autour de la main
    var wall = noone;

    // 🔹 Vérifie les 4 directions cardinales
    if (place_meeting(x + radius, y, obj_collision)) {
		if(instance_place(x + radius, y, obj_collision).grab){
        wall = instance_place(x + radius, y, obj_collision);
		}
    }
    if (place_meeting(x - radius, y, obj_collision)) {
		if(instance_place(x - radius, y, obj_collision).grab){
        wall = instance_place(x - radius, y, obj_collision);
		}
    }
    if (place_meeting(x, y + radius, obj_collision)) {
		if (instance_place(x, y + radius, obj_collision).grab){
        wall = instance_place(x, y + radius, obj_collision);
		}
    }
    if (place_meeting(x, y - radius, obj_collision)) {
		if(instance_place(x, y - radius, obj_collision).grab){
        wall = instance_place(x, y - radius, obj_collision);
		}
    }

    return wall;
}

function handleCapture(){
	if (myCapture != noone){
		myCapture.x = lerp(myCapture.x,x,0.5)
		myCapture.y = lerp(myCapture.y,y,0.5)
	}
}

function nearFood(){
	if place_meeting(x,y,obj_food){
		return instance_place(x,y,obj_food)
	}
	return noone
}

function handleMovingBlocks(){
	if (myCollision != noone) {
		x += myCollision.hspd;
		y += myCollision.vspd
	}
}