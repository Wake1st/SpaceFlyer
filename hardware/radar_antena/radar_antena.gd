extends Node3D


signal received_item_coords(coords:Array[RadarCoord])


var items:Array[RigidBody3D] = []
var coords:Array[RadarCoord] = []
@export var ship:Node3D


func reset_items(i:Array[RigidBody3D]):
	items = i


func add_item(i: RigidBody3D):
	items.push_back(i)


func remove_item(i:RigidBody3D):
	var index = items.find(i)
	if (index > -1):
		items.remove_at(index)


func _physics_process(_delta):
	coords.clear()
	
	for item in items:
		if (item == null):
			continue
		
		var coord = get_coords(item)
		coords.push_back(coord)
	
	#	finally, lets add the ship coords
	assert(ship, "the Radar Antena needs a connection to the ship")
	var shipCoord = get_coords(ship)
	shipCoord.type = RadarType.SHIP
	coords.push_back(shipCoord)
	
	emit_signal("received_item_coords", coords)


func get_coords(item:Node3D):
	var originToItem = item.global_position - global_position
	var local = originToItem * global_transform.basis
	
	var coord:RadarCoord = RadarCoord.new()
	coord.xy = Vector2(local.x, local.y)
	coord.xz = Vector2(local.x, local.z)
	coord.zy = Vector2(local.z, local.y)
	
	return coord
