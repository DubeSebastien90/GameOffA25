if disturbed = false{
disturbed = true
var spring = floor((other.bbox_left-bbox_left)/8);
if spring < 0{
	spring = 0
} else if spring > springCount{
	spring = springCount
}
	springs[spring] = -springForce*abs(obj_fish.vspd)
		if (spring - 1 >= 0){
			springs[spring-1] = -springForce*abs(obj_fish.vspd)/2
		}
		if spring + 1 <= springCount{
			springs[spring+1] = -springForce*abs(obj_fish.vspd)/2
		}
}