class_name Controls
extends Node


enum CONTROL_MODE {
	TRANSLATION,
	ROTATION,
}
var controlMode:= CONTROL_MODE.TRANSLATION

var direction:= Vector3.ZERO
var rotation:= Vector3.ZERO

var stopTranslation:= false
var stopRotation:= false

var grab:=false
var action:=false

enum LOOK_DIRECTION {
	LEFT,
	FORWARD,
	RIGHT,
}
var lookDirection:= LOOK_DIRECTION.FORWARD

enum HEADLIGHT_MODE {
	BROAD,
	FAR
}
var headlightMode:= HEADLIGHT_MODE.FAR


func _capture()->Controls:
	direction = Vector3.ZERO
	rotation = Vector3.ZERO
	
	stopTranslation = Input.is_action_pressed("stop_translation")
	stopRotation = Input.is_action_pressed("stop_rotation")
	
	if Input.is_action_just_pressed("control_mode_swap"):
		controlMode = CMSwap()
	
	if controlMode == CONTROL_MODE.TRANSLATION:
		if stopTranslation == false:
			direction.z += int(Input.is_action_pressed("backward")) - int(Input.is_action_pressed("forward"))
			direction.x += int(Input.is_action_pressed("right")) - int(Input.get_action_strength("left"))
			direction.y += int(Input.is_action_pressed("up")) - int(Input.get_action_strength("down"))
	else:
		if stopRotation == false:
			rotation.x += int(Input.is_action_pressed("pitch")) - int(Input.is_action_pressed("a-pitch"))
			rotation.z += int(Input.is_action_pressed("roll")) - int(Input.is_action_pressed("a-roll"))
			rotation.y += int(Input.is_action_pressed("yaw")) - int(Input.is_action_pressed("a_yaw"))
	
	grab = Input.is_action_just_pressed("grab")
	action = Input.is_action_just_pressed("action")
	
	var lookRight = Input.is_action_just_pressed("look_right") 
	var lookLeft = Input.is_action_just_pressed("look_left")
	
	if lookLeft:
		if lookDirection == LOOK_DIRECTION.RIGHT:
			lookDirection = LOOK_DIRECTION.FORWARD
		elif lookDirection == LOOK_DIRECTION.FORWARD:
			lookDirection = LOOK_DIRECTION.LEFT
	elif lookRight:
		if lookDirection == LOOK_DIRECTION.LEFT:
			lookDirection = LOOK_DIRECTION.FORWARD
		elif lookDirection == LOOK_DIRECTION.FORWARD:
			lookDirection = LOOK_DIRECTION.RIGHT
	
	if Input.is_action_just_pressed("toggle_headlight_mode"):
		if headlightMode == HEADLIGHT_MODE.BROAD:
			headlightMode = HEADLIGHT_MODE.FAR
		else:
			headlightMode = HEADLIGHT_MODE.BROAD
	
	
	return self


func CMSwap() -> CONTROL_MODE:
	if controlMode == CONTROL_MODE.TRANSLATION:
		return CONTROL_MODE.ROTATION
	else:
		return CONTROL_MODE.TRANSLATION


func _to_string():
	return "%f,%f" % [direction.z,direction.x]
