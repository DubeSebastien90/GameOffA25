var n = array_length(joints);
if (n < 2) exit;

var tex = sprite_get_texture(tex_tentacle, 0)

var time = current_time * c_wobbleSpeed

shader_set(shd_tentacle)
draw_primitive_begin_texture(pr_trianglestrip, tex)
draw_set_color(c_white)

for (var i = 0; i < nbJoints; i++){
	var j = joints[i]
	
	var vProgress = i / (nbJoints - 1)
	var width = lerp(c_root_width, c_tip_width, vProgress) / 2
	
	var tangentDir = 0
	if (i == 0){
		tangentDir = point_direction(j.x, j.y, joints[i+1].x, joints[i+1].y)
	} else if (i == nbJoints - 1){
		tangentDir = point_direction(joints[i-1].x, joints[i-1].y, j.x, j.y)
	} else{
		var dirTo = point_direction(j.x, j.y, joints[i+1].x, joints[i+1].y)
		var dirFrom = point_direction(joints[i-1].x, joints[i-1].y, j.x, j.y)
		tangentDir = angle_difference(dirFrom, dirTo) / 2 + dirFrom
	}
	var perpDir = tangentDir - 90
	
	var wobbleOffset = sin(time + (i * c_wobblePhase)) * c_wobblePhase
	
	var jWobbled =  {x: j.x + lengthdir_x(wobbleOffset, perpDir), y: j.y + lengthdir_x(wobbleOffset, perpDir)}
	
	var v1_x = jWobbled.x + lengthdir_x(width, perpDir)
	var v1_y = jWobbled.y + lengthdir_y(width, perpDir)
	
	var v2_x = jWobbled.x + lengthdir_x(-width, perpDir)
	var v2_y = jWobbled.y + lengthdir_y(-width, perpDir)
	
	draw_vertex_texture(v1_x, v1_y, 0, vProgress)
	draw_vertex_texture(v2_x, v2_y, 1, vProgress)
}

draw_primitive_end()
shader_reset()
