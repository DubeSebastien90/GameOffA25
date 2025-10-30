hspd = 0
vspd = 0
frct = 0
grab = true

corners = computeCollisionCorners(self)

p1 = corners.p1
p2 = corners.p2
p3 = corners.p3
p4 = corners.p4
center = corners.center

function computeCollisionCorners(inst)
{
    var w =  sprite_get_width(spr_collision)  * inst.image_xscale;
    var h = sprite_get_height(spr_collision) * inst.image_yscale;
    var a = -inst.image_angle;

    var cosA = dcos(a);
    var sinA = dsin(a);

    // Rotate around (x, y), since origin is top-left
    var p1 = new force(inst.x, inst.y);
    var p2 = new force(inst.x + w * cosA, inst.y + w * sinA);
    var p3 = new force(inst.x - h * sinA, inst.y + h * cosA);
    var p4 = new force(p3.x + w * cosA, p3.y + w * sinA);

    // Compute center (average of all 4 corners)
    var cx = (p1.x + p2.x + p3.x + p4.x) / 4;
    var cy = (p1.y + p2.y + p3.y + p4.y) / 4;

    return { p1: p1, p2: p2, p3: p3, p4: p4, center: new force(cx, cy) };
}