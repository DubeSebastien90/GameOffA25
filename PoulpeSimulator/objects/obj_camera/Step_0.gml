if room = rm_finalLevel && instance_exists(obj_poulpe){
	follow = obj_poulpe
} 
if room = rm_menu{
	x = room_width/2 - 400
	y = room_height/2 + 80
	follow = self
	zoom_ammount = 0.75
	zoom_dir = 0.75
}

//update destination
if (instance_exists(follow)) 
{
	xTo = follow.x +offsetX;
	yTo = follow.y +offsetY;
}

zoom_ammount = lerp(zoom_ammount,zoom_dir,zoom_lerp)
//zoom
var _camW = camW * zoom_ammount
var _camH = camH * zoom_ammount

//move camera
x += (xTo - x) / 5	
y += (yTo - y) / 5

//movement
if mouse_wheel_up(){
	zoom_dir *= 0.96
	zoom_dir = max(0.5,zoom_dir)
}
if mouse_wheel_down(){
	zoom_dir *= 1.04
	zoom_dir = min(1.2,zoom_dir)
}

//keep in center
x = clamp(x, _camW / 2, room_width - _camW / 2);
y = clamp(y, _camH / 2, room_height - _camH / 2);

//screen shake
x += random_range(-shake_remain,shake_remain);
y += random_range(-shake_remain,shake_remain);
shake_remain = max(0,shake_remain-((1/shake_lenght)*shake_magnitude));

//update camera view
camera_set_view_pos(cam,x-_camW/2,y-_camH/2);
camera_set_view_size(cam,_camW,_camH)

var _b =ds_map_find_first(background_map)
repeat(ds_map_size(background_map))
{
	layer_x(_b, background_map[? _b].x * (x - xMagicValue))
	layer_y(_b, background_map[? _b].y * (y - yMagicValue))
	_b = ds_map_find_next(background_map, _b)
}
