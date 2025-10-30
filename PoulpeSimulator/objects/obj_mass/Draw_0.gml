draw_self()
//draw_text(x,y,obj_game.gameControls[index])
var dir = point_direction(myPoulpe.x, myPoulpe.y, x, y);
var perpDir = dir + 90; // direction perpendiculaire pour le décalage

for (var i = 0; i < array_length(joints); i++) {
    var jx = joints[i].x;
    var jy = joints[i].y;

    // appliquer le décalage perpendiculaire
    var _offset = offset[i];
    var drawX = jx + lengthdir_x(_offset, perpDir);
    var drawY = jy + lengthdir_y(_offset, perpDir);

    // dessiner le segment/joint
    draw_sprite_ext(spr_mass, 0, drawX, drawY, 0.5, 0.5, 0, c_white, 1);
}


var perpX = lengthdir_x(1, dir + 90);
var perpY = lengthdir_y(1, dir + 90);

// Uniformes
var nbJoints = array_length(offset);
var pW = sprite_get_width(spr_tentacule);
var pH = sprite_get_height(spr_tentacule);

// === Appliquer le shader ===
shader_set(tentacleShader);

// transmettre les données
shader_set_uniform_f(u_spriteW, pW);
shader_set_uniform_f(u_spriteH, pH);
shader_set_uniform_f(u_springCount, nbJoints);
shader_set_uniform_f_array(u_springs, offset);
shader_set_uniform_f(u_perpX, perpX);
shader_set_uniform_f(u_perpY, perpY);

// === Dessiner le sprite avec rotation ===
draw_sprite_ext(spr_tentacule, 0, x, y, 1, 1, dir, c_white, 1);

// reset
shader_reset();