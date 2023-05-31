extends Node3D


var radarPanel:Node3D
var radarAntena:Node3D


func _ready():
	radarPanel = get_child(0)a
	radarAntena = get_child(1)


func received_item_coords(coords:Array[RadarCoord]):
	radarPanel.pass_coords(coords)


func reset_radar_items(items:Array[RigidBody3D]):
	radarAntena.reset_items(items)


func remove_radar_item(item:RigidBody3D):
	radarAntena.remove_item(item)
