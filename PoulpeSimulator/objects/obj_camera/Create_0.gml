cam = view_camera[0]; 
follow = self; 
xTo = follow.x
yTo = follow.y
shake_lenght = 0; 
shake_magnitude = 0; 
shake_remain = 0;
camH = camera_get_view_height(cam)
camW =camera_get_view_width(cam)

windowH = window_get_height()
windowW = window_get_width()

zoom_dir = 1
zoom_ammount = 1
zoom_lerp = 0.2

offsetX = 0
offsetY = -40

initialDragX = 0
initialDragY = 0

xMagicValue = 290
yMagicValue = 2820
background_map = ds_map_create()
background_map[? layer_get_id("B_NearLOLGround")] = new force(0.1, 0.1)
background_map[? layer_get_id("B_DistantGround")] = new force(0.2, 0.2)
background_map[? layer_get_id("B_Foreground")] = new force(-0.5, -0.5)

camOnObject = false