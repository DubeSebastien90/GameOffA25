//utilitaire
if keyboard_check_pressed(vk_tab){
	window_set_fullscreen(!window_get_fullscreen())
}

if keyboard_check_released(vk_escape){
	game_end()
}

if keyboard_check_released(vk_enter){
	game_restart()
}

//Debug
if keyboard_check_pressed(vk_f1){
	showFps = !showFps
}
if keyboard_check_pressed(vk_f2){
	grav = grav == 0 ? 0.02 : 0
}