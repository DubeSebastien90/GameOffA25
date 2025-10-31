temps += 3*vitesse

hspd = Xrange*dsin(temps)*vitesse
vspd = Yrange*dsin(temps)*vitesse

x += hspd
y += vspd


corners = computeCollisionCorners(self)

p1 = corners.p1
p2 = corners.p2
p3 = corners.p3
p4 = corners.p4
center = corners.center