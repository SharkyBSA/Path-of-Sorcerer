class_name Title_Screen extends Control

signal require_start
signal require_settings
signal require_credits

@onready var start_btn: Button = %StartBtn
@onready var settings_btn: Button = %SettingsBtn
@onready var credits_btn: Button = %CreditsBtn
@onready var quit_btn: Button = %QuitBtn

func _ready() -> void:
	start_btn.pressed.connect(require_start.emit)
	settings_btn.pressed.connect(require_settings.emit)
	credits_btn.pressed.connect(require_credits.emit)
	
	if OS.get_name()=="Web":
		quit_btn.queue_free()
	else:
		quit_btn.pressed.connect(func()->void:
			get_tree().quit())

func open()->void:
	visible=true
	
func close()->void:
	visible=false
