extends Node2D

@onready var end_menu: EndMenu = %"End Menu"
@onready var current_level : Level = %"Level 1"
@onready var player: Player = %Player

func _ready() -> void:
	current_level.change_level.connect(_on_change_level)
	if Engine.is_embedded_in_editor()&&false:
		%MusicPlayer.stop()
		pass
		
func _on_change_level()->void:
	end_menu.open()
