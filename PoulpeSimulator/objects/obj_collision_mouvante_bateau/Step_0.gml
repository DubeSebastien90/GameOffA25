// Inherit the parent event
event_inherited();

if started{
	hspd = lerp(hspd,-2,0.05)
	x += hspd
	
	prevY = y
	temps += 5
	y = yBegin + dsin(temps)*range
	
	vspd = y-prevY
	
	corners = computeCollisionCorners(self)

	p1 = corners.p1
	p2 = corners.p2
	p3 = corners.p3
	p4 = corners.p4
	center = corners.center
}

myBateau.x = x
myBateau.y = y