for (var i = 0; i <= springCount; i++){
	var _a = -k * springs[i] - d*springsVelocity[i];
	springsVelocity[i] += _a
	springs[i] += springsVelocity[i]
}

for (var i = 0; i <= springCount; i++){
	if (i > 0){
		springsDeltaL[i] = spread * (springs[i] - springs[i-1])
		springsVelocity[i-1] += springsDeltaL[i]
	}
	if (i < springCount){
		springsDeltaR[i] = spread * (springs[i] - springs[i+1])
		springsVelocity[i+1] += springsDeltaR[i]
	}
}

for (var i = 0; i <= springCount; i++){
	if (i > 0)				springs[i-1] += springsDeltaL[i]
	if (i < springCount)	springs[i+1] += springsDeltaR[i]
}

if (!place_meeting(x,y,obj_fish)) && disturbed = true{
	disturbed = false
	var spring = floor((obj_fish.bbox_left-bbox_left)/8);
if spring < 0{
	spring = 0
} else if spring > springCount{
	spring = springCount
}
	springs[spring] = springForce*abs(obj_fish.vspd)
	if (spring - 1 >= 0){
		springs[spring-1] = springForce*abs(obj_fish.vspd)/2
	}
	if spring + 1 <= springCount{
		springs[spring+1] = springForce*abs(obj_fish.vspd)/2
	}
}



