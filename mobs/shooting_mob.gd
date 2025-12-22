@icon("res://mobs/shield_inactive.png")
class_name Shooting_Mob extends CharacterBody2D

@export_group("Movement Stats")
@export var max_speed : float 
@export var acceleration : float
@export var min_target_distance : float
@export var max_target_distance : float
var speed : float = 0.0
var current_direction : Vector2 = Vector2.ZERO

@export_group("Damage&Health")
@export var damage: float = 1.5
@export var shots_per_sec : float= 1.0
@export var max_health: float = 10
@export_group("Detection")
@export var detection_distance: float 
@export var lose_distance: float 

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

@onready var body_sprite: Sprite2D = %BodySprite
@onready var damage_sound: AudioStreamPlayer2D = %DamageSound
@onready var shoot_timer: Timer = %ShootTimer
@onready var player_detection_area: Area2D = %PlayerDetectionArea
@onready var player_detection_shape: CircleShape2D = %PlayerDetectionShape.shape
@onready var mob_weapon: Mob_Weapon = %MobWeapon

func _ready() -> void:
	shoot_timer.wait_time=1.0/shots_per_sec
	shoot_timer.timeout.connect(shoot_player)
	player_detection_shape.radius = detection_distance
	player_detection_area.body_entered.connect(_on_player_detection_area_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_exited)
	
func _physics_process(delta: float) -> void:
	if(detected_player==null):
		_idle_mouvement(delta)
	else:
		_move_to_player(delta)
	velocity = current_direction*speed
	move_and_slide()
	
func _move_to_player(delta: float)->void:
	current_direction = global_position.direction_to(detected_player.global_position)
	calculate_speed(delta)
	var distance_to_player = global_position.distance_to(detected_player.global_position)
	if distance_to_player<(max_target_distance+min_target_distance)/2:
		current_direction*=-1

func is_in_target_zone()->bool:
	if detected_player == null:
		return false
	var distance_to_player = global_position.distance_to(detected_player.global_position)
	return distance_to_player<max_target_distance && distance_to_player>min_target_distance

func calculate_speed(delta)->void:
	if is_in_target_zone():
		var mu : float = (max_target_distance+min_target_distance)/2
		var sigma : float = (max_target_distance-min_target_distance)/2
		var distance_to_player = global_position.distance_to(detected_player.global_position)
		if abs(distance_to_player-mu)<sigma/2:
			speed=0
		else:
			speed = max_speed*(1-exp(-(distance_to_player-mu)**2)/(2*sigma**2))
	else :
		speed = move_toward(speed,max_speed,acceleration*delta)

func _idle_mouvement(delta: float)->void:
	speed = move_toward(speed,0.0, acceleration*delta)

func shoot_player()->void:
	if detected_player != null:
		mob_weapon.look_at(detected_player.global_position)
		mob_weapon.shoot()
		shoot_timer.start()
	
func _on_player_detection_area_entered(body : Node2D)->void:
	if body is Player:
		detected_player = body
		player_detection_shape.radius = lose_distance
		shoot_player()

func _on_player_detection_area_exited(body : Node2D)->void:
	if body == detected_player:
		detected_player = null
		player_detection_shape.radius = detection_distance

func die() ->void:
	
	set_physics_process(false)
	set_deferred("collision_layer",8)
	set_deferred("collision_mask",8)
	player_detection_area.set_deferred("monitoring",false)
	detected_player=null
	
	%DeathSound.play()
	await %DeathSound.finished
	queue_free()
