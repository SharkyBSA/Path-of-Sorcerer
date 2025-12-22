@tool
@icon("res://npc/dialogue/dialogue_scene_icon.svg")
class_name PNJ_Dialog extends Control

signal dialog_ended

@export var dialog_content : Array[Dialog_Item] =[]:
	set(array):
		for i in range(array.size()):
			if (array[i]==null):
				array[i] = Dialog_Item.new()
		dialog_content=array
		update_configuration_warnings()

@onready var pnj_face: TextureRect = %PNJ_Face
@onready var text_box: RichTextLabel = %TextBox
@onready var next_button: Button = %NextButton

const CHARACTER_PER_SEC: float = 40
var dialog_index : int = 0:
	set(val):
		dialog_index = clampi(val,0,dialog_content.size()-1)
		
var text_tween : Tween 

func _ready() -> void:
	if not Engine.is_editor_hint():
		text_tween = create_tween()
		go_to_dialog_item(0)
		next_button.pressed.connect(_on_next_button_pressed)
	
func go_to_dialog_item(index : int)->void:
	dialog_index=index
	var dialog_item : Dialog_Item = dialog_content[dialog_index]
	if dialog_item.text.is_empty():
		print("Warning text empty")
	if dialog_item.texture == null:
		print("Warning texture empty")
		
	text_box.text = dialog_item.text
	pnj_face.texture=dialog_item.texture
	next_button.text="end" if is_last_entry() else "next"
	
	if text_tween !=null && text_tween.is_running():
		text_tween.kill()
		
	text_tween = create_tween()
	var tween_duration : float = text_box.get_total_character_count()/CHARACTER_PER_SEC
	text_box.visible_ratio=0
	text_tween.tween_property(text_box,"visible_ratio",1.0,tween_duration)

func is_last_entry()->bool:
	return dialog_index==dialog_content.size()-1

func _on_next_button_pressed()->void:
	if text_tween !=null && text_tween.is_running():
		text_tween.custom_step(INF)
		return

	if is_last_entry():
		emit_signal("dialog_ended")
		queue_free()
	else:
		go_to_dialog_item(dialog_index+1)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	if (dialog_content.is_empty()):
		warnings.append("No dialog content set")
	return warnings
