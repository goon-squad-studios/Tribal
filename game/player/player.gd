extends KinematicBody2D
var speed = 400
var pos = self.position
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		pos.x = speed
	elif Input.is_action_pressed("ui_left"):
		pos.x = -speed
	elif Input.is_action_pressed("ui_up"):
		pos.y = -speed
	elif Input.is_action_pressed("ui_down"):
		pos.y = speed
		
	else:
		pos.x = 0
		pos.y = 0
		
	move_and_slide(pos)