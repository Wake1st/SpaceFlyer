extends Node3D


@export var ping:Sprite2D
@export var scanningDistance = 400
var pingScale

var XYWindow:Panel
var XZWindow:Panel
var ZYWindow:Panel

var windowCenter:Vector2
var xyFlip:Vector2 = Vector2(1,-1)
var xzFlip:Vector2 = Vector2(1, 1)
var zyFlip:Vector2 = Vector2(-1,-1)


func _ready():
	screen_to_device()
	
	XYWindow = $Screen/Node2D/XYScan
	XZWindow = $Screen/Node2D/XZScan
	ZYWindow = $Screen/Node2D/ZYScan
	
	pingScale = XYWindow.size.x / scanningDistance
	windowCenter = Vector2(XYWindow.size.x / 2, XYWindow.size.y / 2)


func screen_to_device():
	# Clear the viewport
	var viewport = $Screen
	$Screen.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)

	# Let two frames pass to make sure the vieport is captured.
	await get_tree().process_frame
	await get_tree().process_frame

	# Retrieve the texture and set it to the viewport quad.
	$Device.material_override.albedo_texture = viewport.get_texture()


func _on_radar_antena_received_item_coords(coords:Array[RadarCoord]):
	remove_all_children(XYWindow)
	remove_all_children(XZWindow)
	remove_all_children(ZYWindow)
	
	for coord in coords:
#		print("coords: ", coord.xy, coord.xz, coord.zy)
		add_ping(XYWindow, coord.xy, xyFlip)
		add_ping(XZWindow, coord.xz, xzFlip)
		add_ping(ZYWindow, coord.zy, zyFlip)


func remove_all_children(window:Panel):
	for child in window.get_children():
		window.remove_child(child)
		child.queue_free()


func add_ping(window:Panel, pos:Vector2, flip:Vector2):
	var p = ping.duplicate()
	p.transform[2] = Vector2(
		flip.x * pos.x, 
		flip.y * pos.y
	) * pingScale + windowCenter
	print(p.transform[2])
	window.add_child(p)
