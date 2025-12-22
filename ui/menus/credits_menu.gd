class_name Credits_Menu extends Control

signal require_back
@onready var back_btn: Button = %BackBtn
@onready var godot_license: Label = %"Godot license"

func _ready() -> void:
	back_btn.pressed.connect(require_back.emit)
	godot_license.text="Godot Engine MIT License:\n"+ Engine.get_license_text()

func open()->void:
	visible=true
	
func close()->void:
	visible=false
