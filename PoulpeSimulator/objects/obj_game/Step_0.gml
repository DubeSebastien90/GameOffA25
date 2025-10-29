instance_create_layer(0, 0, "collision", obj_collision)
nbInstances++

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


if keyboard_check(vk_up){
	poulpe.c_pushStrength += 0.01
}
if keyboard_check(vk_down){
	poulpe.c_pushStrength -= 0.01
}