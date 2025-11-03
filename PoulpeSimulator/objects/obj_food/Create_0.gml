function getEaten(){
	instance_destroy(self)
}

captured = false

xBegin = x
yBegin = y 

posVoulueX = x 
posVoulueY = y 

range = 25
spd = 0.3
spdHurry = 0.7
spdCalm = 0.3

scale = choose(-1,1)

image_xscale = random_range(0.9,1.1)
image_yscale = image_xscale

cooldownNewPosVoulueMax = 100
cooldownNewPosVoulue = cooldownNewPosVoulueMax + random_range(-20,20)