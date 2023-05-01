extends RigidBody3D


@export var translationSpeed:float = 12.0
@export var rotationSpeed:float = 1.2

@export var controlsCapture:Node

const translationCoef:float = 1.4
const rotationCoef:float = 0.2

var grabbableBody:RigidBody3D = null
var grabbable:MeshInstance3D = null
var grabbing:bool = false

var deb

func _ready():
	deb = preload("res://debris.tscn")


func _integrate_forces(_state):
	var controls:Controls = controlsCapture._capture()
	
	motion(controls)
	
	if controls.grab:
		if grabbing:
			grabbable.queue_free()
			grabbable = null
			grabbing = false
			
			var debris = deb.instantiate()
			get_parent().add_child(debris)
			var grabOrigin = global_transform.basis * $GrabArea/GrabCollider.transform.origin
			debris.transform.origin = global_position + grabOrigin
			var len = $GrabArea/GrabCollider.transform.origin.length()
			var tangential_velocity = angular_velocity.cross(
				global_transform.basis * Vector3.FORWARD * len
			)
			debris.linear_velocity = linear_velocity + tangential_velocity
		else:
			if grabbableBody:
				grabbing = true
				grabbable = grabbableBody.get_child(1)
				
				if (grabbable.get_parent()):
					grabbable.get_parent().remove_child(grabbable)
				$GrabArea/GrabCollider.add_child(grabbable)
				
				grabbableBody.queue_free()


func motion(controls:Controls):
	#	translate
	if controls.stopTranslation:
		if linear_velocity.length() > 1:
			apply_force(
				-linear_velocity.normalized() * translationSpeed * translationCoef
			)
		else:
			linear_velocity = Vector3.ZERO
	else:
		apply_force(global_transform.basis * controls.direction * translationSpeed)
	
	#	rotate
	if controls.stopRotation: 
		if angular_velocity.length() > 0.1:
			apply_torque(
				-angular_velocity.normalized() * translationSpeed * rotationCoef
			)
		else:
			angular_velocity = Vector3.ZERO
	else:
		apply_torque(global_transform.basis * controls.rotation * rotationSpeed)


func _on_area_3d_body_entered(body):
	if grabbable == null:
		grabbableBody = body


func _on_area_3d_body_exited(_body):
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
