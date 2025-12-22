extends "res://global/game_state_manager.gd"

@onready var button: Button = $CanvasLayer/Button
@onready var button_2: Button = $CanvasLayer/Button2


func _ready() -> void:
	button.pressed.connect(func()->void:
		print(GameStateManager.get_new_state(GAME))
		)
	button_2.pressed.connect(func()->void:
		print(GameStateManager.get_new_state(TITLE_SCREEN))
		)	
		
