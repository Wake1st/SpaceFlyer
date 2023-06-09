extends Node3D


signal received_item(body:RigidBody3D)
signal win_game


var requiredCount
var collectedCount = 0
var warpReady:bool = false


func _on_debris_spawner_reset_level(items:Array[RigidBody3D]):
	requiredCount = items.size()


func _on_collection_area_body_entered(body):
	if body.name == "Vehicle":
		print("vehicle entered")
		body.move(%VehiclePort.transform)
	else:
		emit_signal("received_item", body)
		body.queue_free()
		
		collectedCount += 1
		if (collectedCount >= requiredCount):
			warpReady = true
			emit_signal("win_game")
