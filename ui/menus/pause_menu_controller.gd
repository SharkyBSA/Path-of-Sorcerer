extends Control

@onready var pause_menu: Pause_Menu = $PauseMenu
@onready var settings_menu: Settings_Menu = $SettingsMenu

func _ready() -> void:
	pause_menu.resume_game.connect(close)
	pause_menu.go_to_settings.connect(func()->void:
		pause_menu.visible=false
		settings_menu.open()
		)
	settings_menu.require_back.connect(func()->void:
		settings_menu.close()
		pause_menu.visible=true
		)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			close()
		else:
			open()
	
func open()->void:
	get_tree().paused=true
	visible=true
	pause_menu.visible=true
	
func close()->void:
	get_tree().paused=false
	pause_menu.visible=false
	visible=false
