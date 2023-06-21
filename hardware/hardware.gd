extends Node3D


@export var ship:Node3D

var radarPanel:Node3D
var radarAntena:Node3D

var debrisItems:Array[RigidBody3D]


func _ready():
	radarPanel = get_child(0)
	
	if radarAntena != null:
		radarPanel.connected = true


func add_hardware(scene:PackedScene):
	var item = scene.instantiate()
	if item.name == "RadarAntena":
		add_child(item)
		radarAntena = item
		radarAntena.ship = ship
		radarAntena.hardwarePort = self
		radarAntena.disabled = false
		radarAntena.reset_items(debrisItems)


func received_item_coords(coords:Array[RadarCoord]):
	radarPanel.pass_coords(coords)


func reset_radar_items(items:Array[RigidBody3D]):
	debrisItems = items
	if radarAntena:
		radarAntena.reset_items(items)


func add_radar_item(item:RigidBody3D):
	if radarAntena:
		radarAntena.add_item(item)


func remove_radar_item(item:RigidBody3D):
	if radarAntena:
		radarAntena.remove_item(item)
