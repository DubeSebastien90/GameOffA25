image_alpha = 0.5
transparencyBufferHeight = 32
springCount = ceil(sprite_width/8)
springs[springCount] = 0
springsVelocity[springCount] = 0
springsDeltaL[springCount] = 0
springsDeltaR[springCount] = 0
k = 0.035
d = 0.025
spread = 0.25
disturbed = false

function particle(nb) constructor{
	repeat(nb){
		instance_create_layer(obj_fish.x,obj_fish.y,"particles",obj_part_water)
	}
}

springForce = 10