var rot = show_angle
if detresse{
	rot = sin(temps)*30
	temps += 0.2
} else {
	temps = 0
}
draw_sprite_ext(sprite_index,image_index,x,y,xscale,yscale,rot,c_white,1)
