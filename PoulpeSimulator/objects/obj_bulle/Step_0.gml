temps += tempsVar

_hspd = lerp(_hspd,0,0.05)
_vspd = lerp(_vspd,0,0.05)

x = xDebut + range*dsin(temps) + _hspd
y += vitesseRemonte + _vspd


tempsVie -= 1

if tempsVie < 100{
	image_alpha = tempsVie/100
	if image_alpha < 0.05{
		instance_destroy(self)
	}
}


