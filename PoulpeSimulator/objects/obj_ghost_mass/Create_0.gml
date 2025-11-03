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

pX = 0
pY = 0

for (var i = 0; i < nbJoints; i++){
	joints[i] = new force(0,0)
	offset[i] = 0
}
temps = random_range(0,360)
vitesseBras = 10


function step(){
	if (myPoulpe == noone) exit;
	
	var pX = myPoulpe.x 
	var pY = myPoulpe.y
	var dir = point_direction(x,y,pX,pY)
	var dist = point_distance(x, y, pX, pY)
	var spd = sqrt(hspd*hspd + vspd*vspd)
	
	gravForce = new force(0,obj_game.grav)

	allForces = gravForce
	
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
	
	
/// Smooth collision

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
	
	x += hspd
	y += vspd
}

function computeJoints(){
	//joints
	pX = lerp(pX,x,0.01)
	pY = lerp(pY,y+30*1.5,0.1)
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
		var distFromPoulpe = poulpeCirconference + _step * (i + 1);
		var jx = pX + lengthdir_x(distFromPoulpe, invDir);
		var jy = pY + lengthdir_y(distFromPoulpe, invDir);

		// on stocke un struct "force" {x, y}
		joints[i] = { x: jx, y: jy };
	}
}

function handleMovingBlocks(){
	if (myCollision != noone) {
		x += myCollision.hspd;
		y += myCollision.vspd
	}
}