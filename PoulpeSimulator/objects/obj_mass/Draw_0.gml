function scr_draw_tentacle_rotated(){
var spr = argument0;
var joints = argument1;
var offset = argument2;
var px = argument3;
var py = argument4;
var dir = argument5;
var circ = argument6;

var n = array_length(joints);
if (n < 2) exit;

var sprW = sprite_get_width(spr);
var sprH = sprite_get_height(spr);

// point de départ du tentacule (sortie du poulpe)
var startX = px + dcos(dir) * circ;
var startY = py - dsin(dir) * circ;

// direction perpendiculaire
var perpDir = dir + 90;

// découpe du sprite : chaque segment correspond à un "band" horizontal
var texOffset = 0;
var segTexWidth = sprW / (n - 1);

// boucle sur chaque segment
for (var i = 0; i < n - 1; i++) {

    var j1 = joints[i];
    var j2 = joints[i + 1];

    var segLen = point_distance(j1.x, j1.y, j2.x, j2.y);

    // appliquer offset perpendiculaire
    var j1x = j1.x + lengthdir_x(offset[i], perpDir);
    var j1y = j1.y + lengthdir_y(offset[i], perpDir);
    var j2x = j2.x + lengthdir_x(offset[i + 1], perpDir);
    var j2y = j2.y + lengthdir_y(offset[i + 1], perpDir);

    // angle et scale
    var segDir = point_direction(j1x, j1y, j2x, j2y);
    var segScaleX = segLen / segTexWidth;

    // créer une surface temporaire pour la partie du sprite
    var tempSurf = surface_create(segTexWidth, sprH);
    surface_set_target(tempSurf);
    draw_clear_alpha(c_white, 0);

    draw_sprite_part(spr, 0,
        texOffset, 0, segTexWidth, sprH, // partie source
        0, 0                            // dessiner en haut-gauche de la surface
    );

    surface_reset_target();

    // dessiner la surface avec rotation et scale
    draw_surface_ext(tempSurf, j1x, j1y, segScaleX, 1, segDir, c_white, 1);

    // libérer la surface
    surface_free(tempSurf);

    // avancer la découpe
    texOffset += segTexWidth;
}
}

scr_draw_tentacle_rotated(
    spr_tentacule, // sprite
    joints,        // array de points x,y
    offset,        // array de offsets perpendiculaires
    myPoulpe.x,
    myPoulpe.y,
    point_direction(myPoulpe.x, myPoulpe.y, x, y),
    poulpeCirconference
);

