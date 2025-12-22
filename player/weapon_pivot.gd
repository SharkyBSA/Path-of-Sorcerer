extends Node2D

var is_controller_used = false

func _physics_process(_delta: float) -> void:
	if is_controller_used:
		_control_controller()
	else:
		_control_mouse()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse or event is InputEventKey:
		is_controller_used = false
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		is_controller_used = true

func _control_mouse()->void:
	var direction_to_mouse = global_position.direction_to(get_global_mouse_position())
	global_rotation = direction_to_mouse.angle()

func _control_controller()->void:
	var joystick_direction : Vector2 = Input.get_vector("aim_left","aim_right","aim_up","aim_bottom")
	if joystick_direction.length()==0:
		return
	global_rotation = joystick_direction.angle()
