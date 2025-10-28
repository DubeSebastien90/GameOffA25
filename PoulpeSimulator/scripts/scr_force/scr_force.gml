function force(_x, _y) constructor
{
	x = _x
	y = _y
	
	function add_force(_f)
	{
		return new force(x + _f.x, y + _f.y)
	}
	
	function sub_force(_f)
	{
		return new force(x - _f.x, y - _f.y)
	}
}