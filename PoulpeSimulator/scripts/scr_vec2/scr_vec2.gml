function vec2(_x, _y) constructor
{
	x = _x
	y = _y
	
	function add_vec2(_f){
		return new vec2(x+_f.x, y+_f.y)
	}
	
	function sub_vec2(_f){
		return new vec2(x-_f.x, y-_f.y)
	}
	
	function scale(_s){
		return new vec2(x*_s, y*_s)
	}
	
	function magnitude(){
		return sqrt(x*x + y*y)
	}
	
	function normalize(){
		var magnitude = self.magnitude()
		return new vec2(x/magnitude, y/magnitude)
	}
}