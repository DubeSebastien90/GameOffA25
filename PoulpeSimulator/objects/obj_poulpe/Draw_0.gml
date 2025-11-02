if showHbx {draw_sprite(hbx_squid, 0, x, y); exit}

if (hspd > 0.2){
	targetXScale = baseXScale
} else if (hspd < -0.2){
	targetXScale = -baseXScale
}
var lerpSpd = (abs(hspd)/6) + 0.15
lerpSpd = clamp(lerpSpd, 0.0, 1.0)

drawXScale = (lerp(drawXScale, targetXScale,lerpSpd))

draw_sprite_ext(spr_squid, 1, x - sign(targetXScale)*3, y - 4, drawXScale, 0.065, 0, c_white, 1)
draw_sprite_ext(spr_back_eye,0,x + drawXScale*15.3846*2,y-4,drawXScale*15.3846*pupilScale,pupilScale,0,c_white,1)
draw_sprite_ext(spr_back_eye,0,x + drawXScale*15.3846*8,y-4,drawXScale*15.3846 * 0.6*pupilScale,0.6*pupilScale,0,c_white,1)

var dirPupil = point_direction(x + drawXScale*15.3846*2.5,y-3.5,mouse_x,mouse_y)
var len = 1*pupilScale
var petitLen = 0.4
var dirPupilPetit = point_direction(x + drawXScale*15.3846*(8.5),y-3.75 ,mouse_x,mouse_y)

//draw_text(x,y,point_distance(0,0,hspd,vspd))

draw_sprite_ext(spr_eye,0,x + drawXScale*15.3846*(2.5+dcos(dirPupil)*len*sign(drawXScale)),y-3.5 -dsin(dirPupil)*len,drawXScale*15.3846*pupilScale,pupilScale,0,c_white,1)
draw_sprite_ext(spr_eye,0,x + drawXScale*15.3846*(8.5+dcos(dirPupil)*petitLen*sign(drawXScale)),y-3.75 -dsin(dirPupil)*petitLen,drawXScale*15.3846*0.8*pupilScale,0.8*pupilScale,0,c_white,1)