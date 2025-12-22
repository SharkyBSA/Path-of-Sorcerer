@tool
@icon("res://levels/background/island_1.png")
class_name Level extends Node2D

@export var _player_spawn : Vector2 = Vector2.ZERO:
	set(val):
		_player_spawn=val
		update_configuration_warnings()

signal change_level

func spawn_player(player : Player)->void:
	player.velocity=Vector2.ZERO
	player.speed=0
	player.global_position=_player_spawn
	
func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray =[]
	if (_player_spawn == Vector2.ZERO):
		warnings.append("Player spawn position no set (is (0,0) for now)")
	return warnings
