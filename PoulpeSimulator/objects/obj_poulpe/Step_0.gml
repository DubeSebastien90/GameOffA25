
controls = [
	keyboard_check(ord("Q")),
	keyboard_check(ord("W")),
	keyboard_check(ord("E")),
	keyboard_check(ord("R")),
	keyboard_check(vk_space)
]

handleHands(controls)

if keyboard_check_pressed(vk_space){
	//screenShake(5,10)
}