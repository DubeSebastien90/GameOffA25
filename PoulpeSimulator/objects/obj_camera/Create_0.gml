cam = view_camera[0]; 
follow = obj_poulpe; 
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
offsetY = 0

initialDragX = 0
initialDragY = 0