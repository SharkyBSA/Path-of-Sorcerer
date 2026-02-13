class_name PowerBall extends Node2D

@export var active = false : set=set_pulsing
@onready var _animation_player: AnimationPlayer = %AnimationPlayer

signal grow_finished

func _ready() -> void:
	_animation_player.animation_started.connect(func(anim_name : StringName)->void:
		if anim_name == "pulse":
			grow_finished.emit()
		)
		


func set_pulsing(val : bool)->void:
	if active==val:
		return

	active=val
	if not is_node_ready():
		return
		
	if (active):
		_go_to_pulse()
	else:
		_go_to_rest()

func _go_to_pulse()->void:
	_animation_player.play("grow")

func _go_to_rest()->void:
	_animation_player.play("shrink")
	
