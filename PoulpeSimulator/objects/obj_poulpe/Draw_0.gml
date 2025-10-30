draw_self()

//eyes
var eyeDist = 0.8

var pLEyeX = x - 3.5
var pLEyeY = y - 7.5

var lDir = point_direction(pLEyeX,pLEyeY,mouse_x,mouse_y)

pLEyeX += dcos(lDir)*eyeDist
pLEyeY -= dsin(lDir)*eyeDist

var pREyeX = x + 3.5
var pREyeY = y - 7.5

var rDir = point_direction(pREyeX,pREyeY,mouse_x,mouse_y)

pREyeX += dcos(rDir)*eyeDist
pREyeY -= dsin(rDir)*eyeDist

draw_sprite(spr_eye,0,pLEyeX,pLEyeY)
draw_sprite(spr_eye,0,pREyeX,pREyeY)
