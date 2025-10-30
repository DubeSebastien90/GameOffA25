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

// --- 1️⃣ Calcul de la direction et vecteur perpendiculaire ---
var rad = degtorad(dir);
var perpX = -sin(rad);
var perpY = cos(rad);

// --- 2️⃣ Création / mise à jour de la surface temporaire ---
var surfWidth = sprite_get_width(spr_tentacule);
var surfHeight = sprite_get_height(spr_tentacule) + maxOffset;

if (!surface_exists(tempSurface) || 
    surface_get_width(tempSurface) != surfWidth || 
    surface_get_height(tempSurface) != surfHeight)
{
    if (surface_exists(tempSurface)) surface_free(tempSurface);
    tempSurface = surface_create(surfWidth, surfHeight);
}

// --- 3️⃣ Dessiner le sprite sur la surface avec shader ---
surface_set_target(tempSurface);
draw_clear_alpha(c_black, 0); // fond transparent

// positionner le sprite à la base de la surface
var drawX = 0;
var drawY = surfHeight - sprite_get_height(spr_tentacule);

shader_set(tentacleShader);
shader_set_uniform_f(u_pixelH_Wave, sprite_get_height(spr_tentacule));
shader_set_uniform_f(u_pixelW_Wave, sprite_get_width(spr_tentacule));
shader_set_uniform_f(u_springCount, nbJoints);
shader_set_uniform_f_array(u_springs, offset);
shader_set_uniform_f(u_perpDirX, perpX);
shader_set_uniform_f(u_perpDirY, perpY);

draw_sprite(spr_tentacule, 0, drawX, drawY);

shader_reset();
surface_reset_target();

// --- 4️⃣ Dessiner la surface sur l’écran avec rotation ---
draw_surface_ext(tempSurface,
                 myPoulpe.x, myPoulpe.y, // position base du tentacule
                 1, 1,                     // scale
                 dir,                       // rotation
                 c_white, 1);               // couleur + alpha
