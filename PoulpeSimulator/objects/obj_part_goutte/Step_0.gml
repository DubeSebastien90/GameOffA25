vspd += grav
image_angle += angle_spd

lifetime -= 1

if lifetime < 0{
	image_alpha = lerp(image_alpha,0,0.1)
	if image_alpha < 0.1{
		instance_destroy(self)
	}
}

x += hspd + _hspd
y += vspd