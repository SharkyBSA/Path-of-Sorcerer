extends Node

const game_screen_path : String = "res://game_screen.tscn"
const title_screen_path : String = "res://ui/menus/title_screen_controller.tscn"

enum {GAME,TITLE_SCREEN}
var current_game_state = TITLE_SCREEN;

func get_new_state(next_state)->String:
	current_game_state=next_state
	
	match (next_state):
		GAME:
			return game_screen_path
		TITLE_SCREEN:
			return title_screen_path
	return ""

	
	
	
