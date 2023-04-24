class_name DebrisSpawner
extends Node


@export var itemCount:float = 10.0

var items:Array[RigidBody3D] = []


func _ready():
	var deb = preload("res://debris.tscn")
	var parent = get_parent()
	
	for i in itemCount:
		var item = deb.instantiate()
		items.append(item)
	
	for i in items.size():
		items[i].apply_force(
			Vector3(
				randf_range(2,8),
				randf_range(2,8),
				randf_range(2,8)
			)
		)
		items[i].apply_torque(
			Vector3(
				randf_range(0.4,3),
				randf_range(0.4,3),
				randf_range(0.4,3)
			)
		)
		
		parent.add_child(items[i])


func _physics_process(_delta):
	for i in items.size():
		print(items[i].transform.origin)
