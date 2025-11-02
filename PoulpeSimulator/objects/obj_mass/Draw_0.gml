if obj_poulpe.showHbx {draw_self(); exit}
draw_sprite(spr_hand,_index,x,y)

var tex = sprite_get_texture(tex_tentacle, 0)
var bodyPoint = { x: myPoulpe.x, y: myPoulpe.y }
var nbJoints = array_length(joints)
if (nbJoints == 0) exit

shader_set(shd_tentacle);
draw_primitive_begin_texture(pr_trianglestrip, tex)
draw_set_color(c_white);

if active {
	var j0 = joints[0]
	var perpDir = point_direction(bodyPoint.x, bodyPoint.y, j0.x, j0.y) - 90
	
	var v1_x = bodyPoint.x + lengthdir_x(c_root_width / 2, perpDir)
	var v1_y = bodyPoint.y + lengthdir_y(c_root_width / 2, perpDir)
	var v2_x = bodyPoint.x + lengthdir_x(-c_root_width / 2, perpDir)
	var v2_y = bodyPoint.y + lengthdir_y(-c_root_width / 2, perpDir)

	draw_vertex_texture(v1_x, v1_y, 0, 0);
	draw_vertex_texture(v2_x, v2_y, 1, 0);
}

var time = (current_time * c_wobbleSpeed) + wobbleSeed

for (var i = 0; i < nbJoints; i++){
    var j = joints[i]
    
    var vProgress = (i + 1) / nbJoints
    var width = lerp(c_root_width, c_tip_width, vProgress) / 2
    
    var tangentDir = 0
    if (i == 0){
        var dirTo = point_direction(j.x, j.y, joints[i+1].x, joints[i+1].y)
        var dirFrom = point_direction(bodyPoint.x, bodyPoint.y, j.x, j.y)
        tangentDir = angle_difference(dirFrom, dirTo) / 2 + dirFrom
    } else if (i == nbJoints - 1){
        tangentDir = point_direction(joints[i-1].x, joints[i-1].y, j.x, j.y)
    } else{
        var dirTo = point_direction(j.x, j.y, joints[i+1].x, joints[i+1].y)
        var dirFrom = point_direction(joints[i-1].x, joints[i-1].y, j.x, j.y)
        tangentDir = angle_difference(dirFrom, dirTo) / 2 + dirFrom
    }
    var perpDir = tangentDir - 90
    
    var v1_x = j.x + lengthdir_x(width, perpDir)
    var v1_y = j.y + lengthdir_y(width, perpDir)
    
    var v2_x = j.x + lengthdir_x(-width, perpDir)
    var v2_y = j.y + lengthdir_y(-width, perpDir)
	
	var wobbleOffset = sin(time + (i * c_wobblePhase)) * c_wobbleAmplitude * ((active) ? 1 : 0.5)
	
	var jWobbledX = lengthdir_x(wobbleOffset, perpDir)
	var jWobbledY = lengthdir_y(wobbleOffset, perpDir)
	
	v1_x += jWobbledX
	v1_y += jWobbledY
		
	v2_x += jWobbledX
	v2_y += jWobbledY
	
    
    draw_vertex_texture(v1_x, v1_y, 0, vProgress)
    draw_vertex_texture(v2_x, v2_y, 1, vProgress)
}

draw_primitive_end()
shader_reset()
