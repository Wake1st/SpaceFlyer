extends RigidBody3D


@export var translationSpeed:float = 36.0
@export var rotationSpeed:float = 3.0

@export var controlsCapture:Node

const translationCoef:float = 1.4
const rotationCoef:float = 0.2

var grabbableBody:RigidBody3D = null
var grabbable:MeshInstance3D = null
var grabbing:bool = false

var dockable:bool = false
var docked:bool = false
var dock:Transform3D

var deb

var farLightRange = 1200
var farLightAngle = 22
var nearLightRange = 100
var nearLightAngle = 50


func _ready():
	deb = preload("res://debris/debris.tscn")


func _integrate_forces(_state):
	var controls:Controls = controlsCapture._capture()
	
	if docked:
#		print(docked, controls.action)
		docked = not controls.action
	else:
		motion(controls)
		grab(controls)
	
	look_around(controls.lookDirection)
	toggle_headlight(controls.headlightMode)
	
	%Hardware/RadarPanel.draw_radar(controls)


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


func move(destination:Transform3D, isDocked:bool=false):
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	transform = destination
	docked = isDocked


func push(dir:Vector3, rot:Vector3):
	apply_impulse(dir)
	apply_torque(rot)


func grab(controls:Controls):
	if controls.grab:
		if grabbing:
			grabbable.queue_free()
			grabbable = null
			grabbing = false
			
			var debris = deb.instantiate()
			get_parent().add_child(debris)
			var grabOrigin = global_transform.basis * $GrabArea/ReleasePoint.transform.origin
			debris.transform.origin = global_position + grabOrigin
			var armLength = $GrabArea/ReleasePoint.transform.origin.length()
			var tangential_velocity = angular_velocity.cross(
				global_transform.basis * Vector3.FORWARD * armLength
			)
			debris.transform.basis = transform.basis
			debris.angular_velocity = angular_velocity
			debris.linear_velocity = linear_velocity + tangential_velocity
			
			%Hardware.add_radar_item(debris)
		else:
			if grabbableBody != null:
				grabbing = true
				grabbable = grabbableBody.get_child(1)
				
				if grabbableBody.hardware != null:
					%Hardware.add_hardware(grabbableBody.hardware)
				
				if (grabbable.get_parent()):
					grabbable.get_parent().remove_child(grabbable)
				$GrabArea/HoldPoint.add_child(grabbable)
				
				var grabLinVel = grabbableBody.linear_velocity
				var grabAngVel = grabbableBody.angular_velocity
				linear_velocity += grabLinVel/mass
				angular_velocity += grabAngVel/mass
				
				%Hardware.remove_radar_item(grabbableBody)
				grabbableBody.queue_free()


func look_around(lookDirection:Controls.LOOK_DIRECTION):
	match(lookDirection):
		Controls.LOOK_DIRECTION.LEFT:
			%PlayerCamera.transform.basis = %LookDirections/Left.transform.basis
		Controls.LOOK_DIRECTION.FORWARD:
			%PlayerCamera.transform.basis = %LookDirections/Forward.transform.basis
		Controls.LOOK_DIRECTION.RIGHT:
			%PlayerCamera.transform.basis = %LookDirections/Right.transform.basis


func toggle_headlight(mode:Controls.HEADLIGHT_MODE):
	if mode == Controls.HEADLIGHT_MODE.FAR:
		$Headlight.spot_range = farLightRange
		$Headlight.spot_angle = 22
	else:
		$Headlight.spot_range = nearLightRange
		$Headlight.spot_angle = 80


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


func _on_debris_spawner_reset_level(items:Array[RigidBody3D]):
	%Hardware.reset_radar_items(items)


func _on_ship_received_item(body):
	%Hardware.remove_radar_item(body)
