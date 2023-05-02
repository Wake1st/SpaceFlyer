extends Node3D


signal win_game


var requiredCount = 1
var collectedCount = 0
var warpReady:bool = false


func _on_collection_area_body_entered(body):
	if body.name == "Vehicle":
		print("vehicle entered")
		body.move(%VehiclePort.transform)
	else:
		body.queue_free()
		
		collectedCount += 1
		if (collectedCount >= requiredCount):
			warpReady = true
			emit_signal("win_game")
