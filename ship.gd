extends Node3D


@export var itemCount:float = 10.0

var items:Array[RigidBody3D] = []
var firstPass:bool = true

func _ready():
	var deb = preload("res://debris.tscn")
	
	for i in itemCount:
		var item = deb.instantiate()
		add_child(item)
		items.append(item)
	
	for i in items.size():
		items[i].transform.origin = Vector3(
			i - 5,
			(i % 3) - 1,
			((i+1) % 3) - 1,
		)
		
		items[i].apply_impulse(
			global_position.normalized() * randf_range(2,5)
		)
		items[i].apply_torque(
			Vector3(
				randf_range(-90,90),
				randf_range(-90,90),
				randf_range(-90,90)
			)
		)


func _physics_process(_delta):
	if firstPass:
		firstPass = false
		for i in items.size():
			items[i].apply_impulse(
				items[i].transform.origin.normalized() * randf_range(4,40)
			)
			items[i].apply_torque(
				Vector3(
					randf_range(-40,40),
					randf_range(-40,40),
					randf_range(-40,40)
				)
			)
