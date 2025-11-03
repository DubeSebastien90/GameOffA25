temps += 2

draw_set_valign(fa_center)
draw_set_halign(fa_center)
draw_set_font(fnt_pixel)
draw_text_transformed(x,y,textToDisplay,0.5,0.5,dsin(temps)*5)