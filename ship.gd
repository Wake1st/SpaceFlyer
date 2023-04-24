extends Node3D


@export var itemCount:float = 10.0

var items:Array[RigidBody3D] = []


func _ready():
	var deb = preload("res://debris.tscn")
	
	for i in itemCount:
		var item = deb.instantiate()
		add_child(item)
		items.append(item)
		
		item.apply_impulse(
			Vector3(
				randf_range(-28,28),
				randf_range(-28,28),
				randf_range(-28,28)
			)
		)
		item.apply_torque(
			Vector3(
				randf_range(-9,9),
				randf_range(-9,9),
				randf_range(-9,9)
			)
		)

func _physics_process(_delta):
	for i in items.size():
		print(items[i].transform.origin)
