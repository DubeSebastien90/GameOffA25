
controls = [
	keyboard_check(ord("Q")),
	keyboard_check(ord("W")),
	keyboard_check(ord("E")),
	keyboard_check(ord("R")),
	keyboard_check(vk_space)
]

if !control{
	controls = [0,0,0,0,0]
}

handleHands(controls)

if keyboard_check_pressed(vk_space){
	//screenShake(5,10)
}

if keyboard_check_pressed(ord("1")){
	briserBras(0)	
}

if keyboard_check(ord("2")){
	regrowArm()
}