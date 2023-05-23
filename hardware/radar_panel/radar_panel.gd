extends Node3D


@export var controlsCapture:Node
@export var scanningDistance = 1000
@export var innerBorder = 6

var ping:Sprite2D
var pingScale

var XYWindow:Panel
var XZWindow:Panel
var ZYWindow:Panel

var windowCenter:Vector2
var xyFlip:Vector2 = Vector2(1,-1)
var xzFlip:Vector2 = Vector2(1, 1)
var zyFlip:Vector2 = Vector2(-1,-1)

var thrustUp:Sprite2D
var thrustDown:Sprite2D
var thrustRight:Sprite2D
var thrustLeft:Sprite2D
var thrustTowards:Sprite2D
var thrustAway:Sprite2D

var pitchPos:Sprite2D
var pitchNeg:Sprite2D
var rollPos:Sprite2D
var rollNeg:Sprite2D
var yawPos:Sprite2D
var yawNeg:Sprite2D

var pingCoords:Array[RadarCoord]


func _ready():
	screen_to_device()
	reference_capture()
	
	pingScale = XYWindow.size.x / scanningDistance
	windowCenter = Vector2(XYWindow.size.x / 2, XYWindow.size.y / 2)


func screen_to_device():
	# Clear the viewport
	var viewport = %Screen
	%Screen.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)

	# Let two frames pass to make sure the vieport is captured.
	await get_tree().process_frame
	await get_tree().process_frame

	# Retrieve the texture and set it to the viewport quad.
	$Device.material_override.albedo_texture = viewport.get_texture()


func reference_capture():
	ping = %Screen/References/RadarPing
	
	XYWindow = %Screen/Active/XYScan
	XZWindow = %Screen/Active/XZScan
	ZYWindow = %Screen/Active/ZYScan
	
	thrustUp = %Screen/References/ThrustUp
	thrustDown = %Screen/References/ThrustDown
	thrustRight = %Screen/References/ThrustRight
	thrustLeft = %Screen/References/ThrustLeft
	thrustTowards = %Screen/References/ThrustTowards
	thrustAway = %Screen/References/ThrustAway
	
	pitchPos = %Screen/References/PitchPos
	pitchNeg = %Screen/References/PitchNeg
	rollPos = %Screen/References/RollPos
	rollNeg = %Screen/References/RollNeg
	yawPos = %Screen/References/YawPos
	yawNeg = %Screen/References/YawNeg


func draw_radar(controls:Controls):
	clear_window(XYWindow)
	clear_window(XZWindow)
	clear_window(ZYWindow)
	
	draw_thrusts(controls.direction)
	draw_rotations(controls.rotation)
	
	draw_items()


func clear_window(window:Panel):
	for child in window.get_children():
		window.remove_child(child)
		child.queue_free()


func draw_thrusts(dir:Vector3):
	if dir.x > 0:
		draw_motion(XZWindow,thrustRight)
		draw_motion(XYWindow,thrustRight)
		draw_motion(ZYWindow,thrustTowards)
	if dir.x < 0:
		draw_motion(XZWindow,thrustLeft)
		draw_motion(XYWindow,thrustLeft)
		draw_motion(ZYWindow,thrustAway)
	if dir.y > 0:
		draw_motion(XZWindow,thrustTowards)
		draw_motion(XYWindow,thrustUp)
		draw_motion(ZYWindow,thrustUp)
	if dir.y < 0:
		draw_motion(XZWindow,thrustAway)
		draw_motion(XYWindow,thrustDown)
		draw_motion(ZYWindow,thrustDown)
	if dir.z > 0:
		draw_motion(XZWindow,thrustDown)
		draw_motion(XYWindow,thrustTowards)
		draw_motion(ZYWindow,thrustLeft)
	if dir.z < 0:
		draw_motion(XZWindow,thrustUp)
		draw_motion(XYWindow,thrustAway)
		draw_motion(ZYWindow,thrustRight)


func draw_rotations(rot:Vector3):
	if rot.x > 0:
		draw_motion(XYWindow,pitchPos)
		draw_motion(XZWindow,pitchPos)
		draw_motion(ZYWindow,rollPos)
	if rot.x < 0:
		draw_motion(XYWindow,pitchNeg)
		draw_motion(XZWindow,pitchNeg)
		draw_motion(ZYWindow,rollNeg)
	if rot.y > 0:
		draw_motion(XYWindow,yawPos)
		draw_motion(XZWindow,rollPos)
		draw_motion(ZYWindow,yawPos)
	if rot.y < 0:
		draw_motion(XYWindow,yawNeg)
		draw_motion(XZWindow,rollNeg)
		draw_motion(ZYWindow,yawNeg)
	if rot.z > 0:
		draw_motion(XYWindow,rollPos)
		draw_motion(XZWindow,yawNeg)
		draw_motion(ZYWindow,pitchNeg)
	if rot.z < 0:
		draw_motion(XYWindow,rollNeg)
		draw_motion(XZWindow,yawPos)
		draw_motion(ZYWindow,pitchPos)


func draw_motion(window:Panel, sprite:Sprite2D):
	var s = sprite.duplicate()
	s.position = Vector2(window.size.x/2, window.size.y/2)
	window.add_child(s)


func draw_items():
	for coord in pingCoords:
		draw_ping(XYWindow, coord.xy, xyFlip)
		draw_ping(XZWindow, coord.xz, xzFlip)
		draw_ping(ZYWindow, coord.zy, zyFlip)


func draw_ping(window:Panel, pos:Vector2, flip:Vector2):
	var p = ping.duplicate()
	var t = Vector2(
		flip.x * pos.x, 
		flip.y * pos.y
	) * pingScale + windowCenter
	
	var clampHorizontal = clamp(
		t.x,
		innerBorder,
		window.size.x - innerBorder,
	)
	var clampVertical = clamp(
		t.y,
		innerBorder,
		window.size.y - innerBorder,
	)
	
	p.position = Vector2(clampHorizontal, clampVertical)
	window.add_child(p)


func _on_radar_antena_received_item_coords(coords:Array[RadarCoord]):
	pingCoords = coords
