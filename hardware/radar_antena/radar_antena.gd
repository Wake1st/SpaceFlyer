extends Node3D


signal received_item_coords(coords:Array[RadarCoord])


var items:Array[RigidBody3D] = []
var coords:Array[RadarCoord] = []


func reset_items(i:Array[RigidBody3D]):
	items = i
#	print("reset items: ", items)


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
		
#		print("item: ", item)
		var originToItem = item.global_position - global_position
		var local = originToItem * global_transform.basis
#		print("vec: ", originToItem, local)
		
		var coord:RadarCoord = RadarCoord.new()
#		print(coord)
		coord.xy = Vector2(local.x, local.y)
		coord.xz = Vector2(local.x, local.z)
		coord.zy = Vector2(local.z, local.y)
		
		coords.push_back(coord)
		
	
	emit_signal("received_item_coords", coords)
