@icon("res://weapons/bullets/fire.png")
class_name Bullet extends Area2D

@export var speed :float = 600.0
@export var max_range : float = 500.0
@export var damage : float = 1.5
@export var target_player : bool = false

var direction : Vector2 
var start_position : Vector2
var has_hit : bool = false

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(rotation)
	start_position = global_position
	body_entered.connect(deal_damage)

func _physics_process(delta: float) -> void:
	global_position+=direction*speed*delta
	if ( start_position.distance_to(global_position) >max_range):
		_destroy()

func deal_damage(body : Node)->void:
	if body is CharacterBody2D:
		if (body.get_collision_layer_value(3) && not target_player) || (body.get_collision_layer_value(1) && target_player):
			body.health -= damage
		else:
			return
	has_hit=true
	_destroy()

func _destroy()->void:
	visible=false
	set_physics_process(false)
	set_deferred("monitoring","false")
	if has_hit:
		$ImpactSound.play()
		await $ImpactSound.finished 
	queue_free()
		
