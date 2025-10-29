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