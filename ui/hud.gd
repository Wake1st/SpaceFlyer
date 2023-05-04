extends CanvasLayer


@export var targetWeight:float = 3.0
var center:Vector2


func _ready():
	center = $DirectionRetical.position


func setTarget(t:Vector2):
	$DirectionRetical.position = center + t * targetWeight
