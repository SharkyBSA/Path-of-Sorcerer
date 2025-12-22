class_name Pause_Menu extends Control

signal resume_game
signal go_to_settings

@onready var resume: Button = %Resume
@onready var settings: Button = %Settings
@onready var quit: Button = %Quit

func _ready() -> void:
	
	resume.pressed.connect(resume_game.emit)
	settings.pressed.connect(go_to_settings.emit)
	quit.pressed.connect(func()->void:
		get_tree().quit()
		)
	
	if OS.get_name()=="Web":
		quit.queue_free()
		
