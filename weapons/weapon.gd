@abstract class_name Weapon extends Node2D

@export_group("Weapon Stats")
@export var max_speed : float = 200.0
@export var max_range : float = 400.0
@export_range(0.0,180,1.0,"radians_as_degrees") var spread : float = 0.0

var target_player:bool=true

@export_group("Weapon parameters")
@export var shoot_audio_stream : AudioStream = null :
	set(audio_stream):
		if shoot_sound !=null:
			shoot_sound.stream = audio_stream
		update_configuration_warnings()
	get():
		if shoot_sound != null:
			return shoot_sound.stream
		else:
			return null
			
@export var bullet_scene : PackedScene = null:
	set = _set_bullet_scene

@export_group("Mandatory Nodes")
@export var shoot_sound: AudioStreamPlayer2D = null:
	set(node):
		shoot_sound = node
		update_configuration_warnings()
		
@abstract func shoot()->void

func _set_bullet_scene(scene : PackedScene)-> void:
	if (scene == null):
		bullet_scene = scene
	elif (scene.instantiate() is Bullet):
		bullet_scene = scene
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = []
	if (bullet_scene==null):
		warnings.append( "Weapon: No bullet scene defined")
	if shoot_audio_stream == null:
		warnings.append("No sound set for weapon")
	if shoot_sound == null:
		warnings.append("No AudioStream2D node set for shoot sound")
	return warnings
