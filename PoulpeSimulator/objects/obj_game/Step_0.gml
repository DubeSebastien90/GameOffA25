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

if room = rm_menu{
	if mouse_check_button_pressed(mb_left){
		room = rm_finalLevel
	}
}

if room != rm_menu && cheats{

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

if keyboard_check_pressed(vk_f4){obj_poulpe.showHbx = !obj_poulpe.showHbx}

// Check if F11 is pressed
if (keyboard_check_pressed(vk_f11))
{
    show_debug_message("Creating full room screenshot...");

    // 1. Create a surface the exact size of the room
    var _surf = surface_create(room_width, room_height);

    // 2. Check if it worked (it can fail if the room is gigantic)
    if (!surface_exists(_surf))
    {
        show_debug_message("ERROR: Could not create surface for screenshot.");
    }
    else
    {
        // 3. Set the drawing "target" to our new surface
        // (Everything drawn from now on will go to this surface, not the screen)
        surface_set_target(_surf);

        // 4. Clear the surface to be fully transparent (or a background color)
        draw_clear_alpha(c_black, 0);

        // 5. This is the magic part:
        // Loop through every single instance in the room and run its Draw Event
        with (all)
        {
            draw_self();
        }

        // 6. Reset the drawing target back to the normal screen
        surface_reset_target();

        // 7. Save our new, complete surface to a PNG file
        var _filename = "full_room_shot_" + string(room_get_name(room)) + ".png";
        surface_save(_surf, _filename);

        // 8. IMPORTANT: Free the surface from memory
        surface_free(_surf);

        show_debug_message("Full room screenshot saved: " + _filename);
    }
}

}