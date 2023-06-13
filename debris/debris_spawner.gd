extends Node3D


signal reset_level(i:Array[RigidBody3D])


@export var minImpulse:float = 2
@export var maxImpulse:float = 4
@export var minTorque:Vector3 = Vector3(-40,-40,-40)
@export var maxTorque:Vector3 = Vector3(40,40,40)

@export var itemCount:float = 1.0
var items:Array[RigidBody3D]	# use editor once v4.1 is available
var starterItems:Array[RigidBody3D]

var firstPass:bool = true


func _ready():
	for child in $Layer0.get_children():
		starterItems.append(child)
		items.append(child)
	
	SetupLevel()


func _physics_process(_delta):
	if (Input.is_action_just_pressed("reset_level")):
		SetupLevel()
	
	if firstPass:
		StartLevel()
		emit_signal("reset_level", items)


func SetupLevel():
	firstPass = true
	
	for i in items.size():
		items[i].transform.origin = Vector3(
			i - 5,
			(i % 3) - 1,
			((i+1) % 3) - 1,
		)


func StartLevel():
	firstPass = false
	for i in starterItems.size():
		starterItems[i].transform.origin = $Layer0.transform.origin + Vector3(
			starterItems[i].transform.origin.normalized() * randf_range(
				minImpulse,
				maxImpulse
			)
		)
		starterItems[i].apply_torque(
			Vector3(
				randf_range(minTorque.x/4,maxTorque.x/4),
				randf_range(-minTorque.y/4,maxTorque.y/4),
				randf_range(-minTorque.z/4,maxTorque.z/4)
			)
		)
	
#	for i in items.size():
#		items[i].apply_impulse(
#			items[i].transform.origin.normalized() * randf_range(
#				minImpulse,
#				maxImpulse
#			)
#		)
#		items[i].apply_torque(
#			Vector3(
#				randf_range(minTorque.x,maxTorque.x),
#				randf_range(-minTorque.y,maxTorque.y),
#				randf_range(-minTorque.z,maxTorque.z)
#			)
#		)
