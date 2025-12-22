class_name Title_Screen_Controller extends Control

@onready var settings_menu: Settings_Menu = %SettingsMenu
@onready var title_screen: Title_Screen = %Title_screen
@onready var credits_menu: Credits_Menu = %CreditsMenu

func _ready() -> void:
	title_screen.require_start.connect(func()->void:
		get_tree().change_scene_to_file(GameStateManager.get_new_state(GameStateManager.GAME))
	)	
	title_screen.require_settings.connect(func()->void:
		title_screen.close()
		settings_menu.open()
		)
	title_screen.require_credits.connect(func()->void:
		title_screen.close()
		credits_menu.open()
		)
		
	settings_menu.require_back.connect(func()->void:
		settings_menu.close()
		title_screen.open()
		)
	
	credits_menu.require_back.connect(func()->void:
		credits_menu.close()
		title_screen.open()
		)
	
func open()->void:
	visible=true
	
func close()->void:
	visible=false
