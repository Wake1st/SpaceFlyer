extends Node3D


@export var flashTimeout:float = 0.2
var flashTime:float = 0.0
var lightEnergy:float = 40.0


func _physics_process(delta):
	flashTime += delta
	if flashTime >= flashTimeout:
		flash_beacon(false)


func _on_timer_timeout():
	flash_beacon()


func flash_beacon(on:bool=true):
	$Light.light_energy = lightEnergy if on else 0.0
