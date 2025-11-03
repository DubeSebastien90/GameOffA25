prevX = x

if captured{
	//PANIQUE
} else {
	//vivre sa vie
	if (point_distance(x,y,posVoulueX,posVoulueY) <= spd*2){
		cooldownNewPosVoulue -= 1
		if cooldownNewPosVoulue < 0{
			spd = spdCalm
			cooldownNewPosVoulue = cooldownNewPosVoulueMax + random_range(-20,20)
			posVoulueX = xBegin + random_range(-range,range)
			posVoulueY = yBegin + random_range(-range,range)
		}
	} else {
		if (point_distance(x,y,posVoulueX,posVoulueY) <= spd*2){
			x = posVoulueX
			y = posVoulueY
		} else{
			var dir = point_direction(x,y,posVoulueX,posVoulueY)
			x += dcos(dir)*spd
			y -= dsin(dir)*spd
		}
	}
}

hspd = x - prevX
if hspd != 0{
	scale = sign(hspd)
}