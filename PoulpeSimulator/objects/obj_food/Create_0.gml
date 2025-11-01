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

cooldownNewPosVoulueMax = 100
cooldownNewPosVoulue = cooldownNewPosVoulueMax + random_range(-20,20)