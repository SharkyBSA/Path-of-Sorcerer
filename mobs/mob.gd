@icon("res://mobs/sword_inactive.png")
class_name Mob extends CharacterBody2D

@export_group("Movement Stats")
@export var max_speed : float 
@export var acceleration : float
@export var slow_distance : float
@export var slow_factor : float = 1.0
var rotation_speed : float = 3.0
var speed : float = 0.0
var current_direction : Vector2

@export_group("Damage&Health")
@export var damage: int = 3
@export var max_health: float = 10

var health := max_health:
	set(val):
		var old_health = health
		health=val
		if health<=0:
			die()
		elif old_health>health:
			%DamageSound.play()
			

#Player detection
var detected_player : Player = null
var collided_player : Player = null

@onready var hit_animation: AnimationPlayer = %HitAnimation
@onready var player_detection_area: Area2D = %PlayerDetectionArea
@onready var player_hit_area: Area2D = %HitPlayerArea
@onready var hit_timer: Timer = %HitTimer
@onready var shadow_rotation_point: Node2D = %ShadowRotationPoint

func _ready() -> void:
	hit_timer.timeout.connect(init_hit_player)
	player_hit_area.body_entered.connect(_on_player_hit_area_entered)
	player_hit_area.body_exited.connect(_on_player_hit_area_exited)

	player_detection_area.body_entered.connect(_on_player_detection_area_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_exited)
	
	hit_animation.animation_set_next("hit_player","hit_reset")
	hit_animation.animation_changed.connect(func(old_anim: StringName,_new_anim: StringName)->void:
		if old_anim.contains("hit_player") :
			_hit_player()
			hit_timer.start()
		)
		
func _physics_process(delta: float) -> void:
	if(detected_player==null):
		_idle_mouvement(delta)
	else:
		_move_to_player(delta)
	
	rotation = rotate_toward(rotation, current_direction.angle(),rotation_speed*delta)
	shadow_rotation_point.global_rotation=0
	velocity = current_direction*speed
	move_and_slide()
	
func _move_to_player(delta: float)->void:
	current_direction = global_position.direction_to(detected_player.global_position)
	var target_speed : float = max_speed*slow_factor if global_position.distance_to(detected_player.global_position)<slow_distance else max_speed 
	speed = move_toward(speed,target_speed,acceleration*delta)

func _idle_mouvement(delta: float)->void:
	speed = move_toward(speed,0.0, acceleration*delta)
	
func _on_player_hit_area_entered(body : Node2D)->void:
	if body is Player:
		collided_player=body
		init_hit_player()

func _on_player_hit_area_exited(body : Node2D)->void:
	if body is Player:
		collided_player=null
		hit_timer.stop()

func init_hit_player()->void:
	if collided_player != null:
		hit_animation.play("hit_player")
	
func _hit_player()->void:
	if collided_player != null :
		collided_player.health-=damage

func _on_hit_timer_ended()->void:
	pass
	
func _on_player_detection_area_entered(body : Node2D)->void:
	if body is Player:
		detected_player = body

func _on_player_detection_area_exited(body : Node2D)->void:
	if body == detected_player:
		detected_player = null
		
func die() ->void:
	set_physics_process(false)
	set_deferred("collision_layer",8)
	set_deferred("collision_mask",8)
	player_hit_area.set_deferred("monitoring",false)
	collided_player=null
	_on_player_hit_area_exited(collided_player)
	
	%DeathSound.play()
	await %DeathSound.finished
	queue_free()
