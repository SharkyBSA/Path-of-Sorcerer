@icon("res://icon.png")
class_name GameScreen extends Node2D

@export var level_graph : Level_Graph:
	set(val):
		level_graph=val
		update_configuration_warnings()

@onready var player: Player = %Player
@onready var end_menu: EndMenu = %"End Menu"
@onready var player_hud : PlayerHUD = %PlayerHUD

var current_level : Level 

func _ready() -> void:
	player.died.connect(func()->void:
		get_tree().change_scene_to_file(GameStateManager.get_new_state(GameStateManager.TITLE_SCREEN))
		)
	end_menu.go_to_title.connect(func()->void:
		get_tree().change_scene_to_file(GameStateManager.get_new_state(GameStateManager.TITLE_SCREEN))
		)
	end_menu.play_again.connect(func()->void:
		get_tree().reload_current_scene()
		)
	
	player.health_changed.connect(player_hud.set_health_bar_value)
	player.max_health_changed.connect(player_hud.set_health_bar_max_value)

	var first_level = level_graph.load_level(0)
	if first_level == null:
		print("Oups pas de level à l'initialisation du GameScreen")
		return 
	change_level(first_level)
	

func change_level(next_level : Level)->void:
	if next_level == null:
		end_menu.open()
		return 
		
	if current_level !=null:
		current_level.queue_free()
		
	current_level = next_level
	call_deferred("add_child",current_level)
	remove_child(player)
	current_level.call_deferred("add_sibling",player)
	
	current_level.change_level.connect(func()->void:
		change_level(level_graph.load_next_level()))
		
	current_level.y_sort_enabled=true
	current_level.spawn_player(player)
	
func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray =[]
	if (level_graph.level_list.is_empty()):
		warnings.append("Graph level contains nothing")
	for i in range(level_graph.level_list.size()):
		if level_graph.level_list[i].level_path == "" :
			warnings.append("Level graph index "+str(i)+" has no Scene Path")
		if level_graph.level_list[i].next_level == i:
			warnings.append("Level graph index "+str(i)+" point to itself")
	return warnings
	
