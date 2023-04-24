extends RigidBody3D


@export var translationSpeed:float = 12.0
@export var rotationSpeed:float = 1.2

@export var controlsCapture:Node

const translationDampCoef:float = 1.4
const rotationDampCoef:float = 0.2

var grabbable:RigidBody3D = null
var grabbing:bool = false


func _integrate_forces(_state):
	var controls:Controls = controlsCapture._capture()
#	print_info(controls)
	
	motion(controls)
	
	if controls.grab:
		if grabbing:
			grabbable = null
			grabbing = false
	
	if grabbing:
		var grabOrigin = global_transform.basis * $GrabArea/GrabCollider.transform.origin
		grabbable.transform.origin = global_position + grabOrigin
		print(grabbable.transform.origin)


func motion(controls:Controls):
	#	translate
	if controls.stopTranslation:
		if linear_velocity.length() > 1:
			apply_force(-linear_velocity.normalized() * translationSpeed * translationDampCoef)
		else:
			linear_velocity = Vector3.ZERO
	else:
		apply_force(global_transform.basis * controls.direction * translationSpeed)
	
	#	rotate
	if controls.stopRotation: 
		if angular_velocity.length() > 0.1:
			apply_torque(-angular_velocity.normalized() * translationSpeed * rotationDampCoef)
		else:
			angular_velocity = Vector3.ZERO
	else:
		apply_torque(global_transform.basis * controls.rotation * rotationSpeed)


func _on_area_3d_body_entered(body):
	if grabbable == null:
		grabbable = body
		grabbable.angular_velocity = Vector3.ZERO
		grabbable.linear_velocity = Vector3.ZERO
		grabbing = true


func _on_area_3d_body_exited(body):
	if not grabbing:
		grabbable = null


func print_info(controls:Controls):
	print(
		"cm: ", controls.CONTROL_MODE.keys()[controls.controlMode],
		" | str: ", controls.stopTranslation, 
		" | dir: ", controls.direction, 
		" | live: ", linear_velocity, 
		" | glo: ", global_transform.origin, 
		" | sro: ", controls.stopRotation, 
		" | rot: ", controls.rotation,
		" | anve: ", angular_velocity, 
		" | glb: ", global_transform.basis, 
	)
