temps += 3

hspd = Xrange*dsin(temps)
vspd = Yrange*dsin(temps)

x += hspd
y += vspd


corners = computeCollisionCorners(self)

p1 = corners.p1
p2 = corners.p2
p3 = corners.p3
p4 = corners.p4
center = corners.center