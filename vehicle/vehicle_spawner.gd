extends Node3D


@export var vehicle:RigidBody3D
var firstTime = true


func _physics_process(_delta):
	if firstTime:
		start_level()
		firstTime = false


func _on_debris_spawner_reset_level(_i):
	start_level()


func start_level():
	vehicle.move(transform)
	vehicle.push(
		Vector3(
			randf_range(-10,10),
			randf_range(-10,10),
			randf_range(-10,10)
		),
		Vector3(
			randf_range(-22,22),
			randf_range(-22,22),
			randf_range(-22,22)
		)
	)
