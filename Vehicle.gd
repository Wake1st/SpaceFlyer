extends RigidBody3D


@export var translationSpeed:float = 12.0
@export var rotationSpeed:float = 1.2

@export var controlsCapture:Node

const translationDampCoef:float = 1.4
const rotationDampCoef:float = 0.2


func _integrate_forces(_state):
	var controls:Controls = controlsCapture._capture()
#	print_info(controls)
	
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
