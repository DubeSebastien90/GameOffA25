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
