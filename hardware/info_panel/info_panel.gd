extends Node3D


func _ready():
	$EditorNode.visible = false
	
	screen_to_device()


func screen_to_device():
	# Clear the viewport
	var viewport = %Screen
	%Screen.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)

	# Let two frames pass to make sure the vieport is captured.
	await get_tree().process_frame
	await get_tree().process_frame

	# Retrieve the texture and set it to the viewport quad.
	$Device.material_override.albedo_texture = viewport.get_texture()
