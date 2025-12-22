@tool
@icon("res://pickups/chest/chest_bottom.png")
class_name Chest extends StaticBody2D

@export_group("Pickups")
@export var _possible_pickups : Array[Item] = []:
	set(val):
		_possible_pickups = val
		update_configuration_warnings()
@export_range(1,5,1) var pickup_amount : int = 1

@onready var _player_detection_area: Area2D = %PlayerDetectionArea

const PICKUP_FLIGHT_TIME : float = 0.5
const FLIGHT_RADIUS : int = 100 
const PICKUP_FLIGHT_TIME_HALF : = PICKUP_FLIGHT_TIME/2
const FLIGHT_RADIUS_HALF := FLIGHT_RADIUS/2

var _player_detected : bool = false
var _opened = false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = [] 
	if _possible_pickups.size()==0 :
		warnings.append("No possible pickups defined")
	
	return warnings

func _ready() -> void:
	_player_detection_area.body_entered.connect(func(body : CharacterBody2D)->void:
		if body is Player:
			_player_detected=true
		)
	_player_detection_area.body_exited.connect(func(body : CharacterBody2D)->void:
		if body is Player:
			_player_detected=false
		)
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction"):
		if not _opened and _player_detected:
			open()
			
func open()->void:
	if _opened:
		return
	_opened =true
	$AnimationPlayer.play("open")
	for i in pickup_amount:
		create_pickup()
	
func create_pickup()->void:
	if _possible_pickups.is_empty():
		return
	
	var pickup_scene : Pickup = preload("res://pickups/pickup.tscn").instantiate()
	pickup_scene.item = _possible_pickups.pick_random()
	pickup_scene.monitoring = false
	add_child(pickup_scene)
	
	var land_distance = randi_range(FLIGHT_RADIUS_HALF,FLIGHT_RADIUS)
	var land_position = Vector2.RIGHT.rotated(randf_range(0,2*PI))*land_distance
	
	var tween := create_tween()
	tween.set_parallel()
	pickup_scene.scale = Vector2(0.25, 0.25)
	tween.tween_property(pickup_scene, "scale", Vector2(1.0, 1.0), PICKUP_FLIGHT_TIME_HALF)
	tween.tween_property(pickup_scene, "position:x", land_position.x, PICKUP_FLIGHT_TIME)

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	var jump_height := randf_range(30.0, 80.0)
	tween.tween_property(pickup_scene, "position:y", land_position.y - jump_height, PICKUP_FLIGHT_TIME_HALF)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(pickup_scene, "position:y", land_position.y, PICKUP_FLIGHT_TIME_HALF)
	
	tween.finished.connect(func()->void:
		pickup_scene.monitoring=true
		)
		
