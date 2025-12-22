@icon("res://player/godot_bottom.png")
class_name Player extends CharacterBody2D

@export_group("Player Stats")
@export var max_speed : float = 250.0
@export var acceleration: float = 1000.0
@export var max_health: int = 20

signal died

@onready var health: = max_health:
	set(val):
		var old_health = health
		health=clampi(val, 0,max_health)
		_health_bar.value=val
		if health<=0:
			die()
		elif old_health>health:
			_damage_sound_effect.play()

@onready var _damage_sound_effect: AudioStreamPlayer2D = %DamageSoundEffect
@onready var _death_sound_effect: AudioStreamPlayer2D = %DeathSoundEffect
@onready var _collision_shape_2d: CollisionShape2D = %HitBox
@onready var _health_bar: ProgressBar = %HealthBar
@onready var weapon: Weapon = %Weapon

var speed : float = 0.0
var direction : Vector2

func _ready() -> void:
	_health_bar.max_value=max_health

func _physics_process(delta: float) -> void:
	_process_movement(delta)

func _process_movement(delta: float)->void:
	var input_direction : Vector2 = Input.get_vector("player_left","player_right","player_up","player_down")
	var target_speed: float = 0.0
	
	if input_direction.length()>0:
		direction = input_direction.normalized()
		target_speed = max_speed
		
	speed = move_toward(speed,target_speed,acceleration*delta)
	velocity = direction*speed
	move_and_slide()

func die()->void:
	_collision_shape_2d.set_deferred("disabled",true)
	set_all_physics_process(false)
	_death_sound_effect.play()
	await _death_sound_effect.finished
	died.emit()
		
func set_all_physics_process(val : bool)->void:
	set_physics_process(val)
	$PlayerSprite.set_physics_process(val)
	weapon.set_physics_process(val)
	%WeaponPivot.set_physics_process(val)
