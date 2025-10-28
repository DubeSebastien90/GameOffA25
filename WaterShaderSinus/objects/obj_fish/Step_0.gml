press_avance = mouse_check_button(mb_left)

//direction
angle = point_direction(x,y,mouse_x,mouse_y)
if (angle > 90 && angle < 270) && detresse = false{
	yscale = -1
} else yscale = 1

if (prev_angle < 90 && angle > 270){
	tour -= 1
}
if (angle < 90 && prev_angle > 270){
	tour += 1
}
show_angle = lerp(show_angle,angle+360*tour,0.1)

//avancer
if place_meeting(x,y,obj_water){
	if press_avance{
		vspd = lerp(vspd,-dsin(show_angle)*max_spd,0.1)
		hspd = lerp(hspd,dcos(show_angle)*max_spd,0.1)
	} else{
		hspd = lerp(hspd,0,0.1)
		vspd = lerp(vspd,0,0.1)
	}
} else{
	vspd += grav
}

//jump

//collision
if place_meeting(x,y,obj_water){
	inWater = true
	detresse = false
	xscale = 1
} else inWater = false

if place_meeting(x,y+vspd,obj_collision){
	while!(place_meeting(x,y+sign(vspd),obj_collision)){
		y += sign(vspd)
	}
	vspd = 0
	if !inWater{
		hspd = sign(mouse_x-x)*random_range(0.5,1.5)
		vspd = random_range(-2,-3)
		detresse = true
		xscale = sign(hspd)
		yscale = 1
	}
}
if place_meeting(x+hspd,y,obj_collision){
	while!(place_meeting(x+sign(hspd),y,obj_collision)){
		x += sign(hspd)
	}
	if (detresse){
		hspd *= -1
	} else hspd = 0
}

x += hspd
y += vspd