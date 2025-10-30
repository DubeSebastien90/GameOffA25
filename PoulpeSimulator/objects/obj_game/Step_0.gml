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
	flyHack = !flyHack
	grav = grav == 0 ? 0.02 : 0
}

if flyHack {
	if keyboard_check(vk_down){
		obj_poulpe.y += 5
	}
	if keyboard_check(vk_up){
		obj_poulpe.y -= 5
	}
	if keyboard_check(vk_right){
		obj_poulpe.x += 5
	}
	if keyboard_check(vk_left){
		obj_poulpe.x -= 5
	}
}

if keyboard_check_pressed(vk_f3){stayInPlace = !stayInPlace}
if stayInPlace {obj_poulpe.x = obj_poulpe.xstart; obj_poulpe.y = obj_poulpe.ystart}