extends Node3D


@export var itemCount:float = 1.0

var deb

var items:Array[RigidBody3D] = []
var firstPass:bool = true


func _ready():
	deb = preload("res://debris.tscn")
	
	SetupLevel()


func _physics_process(_delta):
	if (Input.is_action_just_pressed("reset_level")):
		SetupLevel()
	
	StartLevel()


func SetupLevel():
	firstPass = true
	items.clear()
	var children = get_children()
	for child in children:
		remove_child(child)
	
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


func StartLevel():
	if firstPass:
		firstPass = false
		for i in items.size():
			items[i].apply_impulse(
				items[i].transform.origin.normalized() * randf_range(4,10)
			)
			items[i].apply_torque(
				Vector3(
					randf_range(-40,40),
					randf_range(-40,40),
					randf_range(-40,40)
				)
			)
