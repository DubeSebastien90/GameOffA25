if showFps draw_text(0, 0, string("Fps: {0}", fps))

if room = rm_menu{
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fnt_pixel)
	draw_text_transformed(room_width*0.7,room_height*0.7,"Click screen to start",2,2,0)
}
