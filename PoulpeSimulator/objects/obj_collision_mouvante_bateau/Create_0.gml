// Inherit the parent event
event_inherited();
bateau = true
started = false

temps = 0
yBegin = y
range = 5

image_alpha = 1

function startBateau(){
	obj_poulpe.control = false
	alarm[0] = 60
	alarm[1] = 1
}