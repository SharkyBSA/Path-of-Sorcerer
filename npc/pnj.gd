@tool
@icon("res://npc/sophia.png")
class_name PNJ extends StaticBody2D

@export_group("Dialog")
@export var dialog_scene : PackedScene = null:
	set(val):
		dialog_scene=val
		update_configuration_warnings()

@export var dialog_content : Array[Dialog_Item] =[]:
	set(array):
		for i in range(array.size()):
			if (array[i]==null):
				array[i] = Dialog_Item.new()
		dialog_content=array
		update_configuration_warnings()

@export_group("Scene properties shortcut")
@export var pnj_sprite_texture : Texture2D:
	get():
		return pnj_sprite_texture
	#set(val):
		#pnj_sprite_texture=val
		#if is_node_ready():
			#pnj_sprite.texture=val

@onready var pnj_sprite: Sprite2D = %PnjSprite
@onready var player_detection_area: Area2D = %PlayerDetectionArea
@onready var dialog_layer: CanvasLayer = %DialogLayer

var dialog_box : PNJ_Dialog = null
var player_detected : Player = null

func _ready() -> void:
	#pnj_sprite.texture = pnj_sprite_texture
	player_detection_area.body_entered.connect(_on_player_detection_area_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction") && dialog_box==null:
		open_dialog()
		
func open_dialog()->void:
	if not _is_player_detected():
		return
	dialog_box = dialog_scene.instantiate()
	dialog_box.dialog_content=dialog_content
	player_detected.set_all_physics_process(false)
	dialog_box.dialog_ended.connect(close_dialog)
	dialog_layer.add_child(dialog_box)
	
func close_dialog()->void:
	dialog_box = null
	player_detected.set_all_physics_process(true)
	
func _on_player_detection_area_entered(body : Node2D)->void:
	if body is Player:
		player_detected = body

func _on_player_detection_area_exited(body : Node2D)->void:
	if body is Player:
		player_detected = null

func _is_player_detected()->bool:
	return !player_detected==null

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	if (dialog_content.is_empty()):
		warnings.append("No dialog content set")
	if (dialog_scene == null) :
		warnings.append("No dialog scene model set")
	return warnings
