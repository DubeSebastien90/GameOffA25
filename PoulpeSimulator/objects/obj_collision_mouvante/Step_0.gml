temps += 3*vitesse
phasePoisson += 2

hspd = Xrange*dsin(temps)*vitesse
vspd = Yrange*dsin(temps)*vitesse + rangePoisson*dsin(phasePoisson)

x += hspd
y += vspd


corners = computeCollisionCorners(self)

p1 = corners.p1
p2 = corners.p2
p3 = corners.p3
p4 = corners.p4
center = corners.center

if cooldownBulle < 0{
	var monHspd = hspd
	var monVspd = vspd
	cooldownBulle = random_range(60,120)
	with(instance_create_layer(center.x+random_range(-20,20),center.y+random_range(-20,20),"particules",obj_bulle)){
		_hspd = monHspd
		_vspd = monVspd
	}
}

cooldownBulle -= point_distance(0,0,vspd,hspd)