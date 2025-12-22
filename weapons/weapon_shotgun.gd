@tool 
@icon("res://player/hand_fire.png")
class_name Weapon_Shotgun extends Weapon

@export_group("Weapon Stats")
@export var min_range : float = 0
@export var min_speed : float = 100.0
@export var bullet_amount : int = 8
@export_range(1.0,60,0.1) var shots_per_secs : float = 5

@onready var cooldown: Timer = $Cooldown

func _ready() -> void:
	cooldown.wait_time = 1/shots_per_secs
	if Engine.is_editor_hint():
		set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shoot") && cooldown.is_stopped():
		shoot()

func shoot()->void:
	for i in range(bullet_amount):
		var bullet : Bullet = bullet_scene.instantiate()
		bullet.damage*=4.0/bullet_amount
		bullet.global_rotation = global_rotation +randf_range(-spread/2,spread/2)
		bullet.global_position = global_position
		bullet.max_range = randf_range(min_range,max_range)
		bullet.speed = randf_range(min_speed,max_speed)
		get_tree().current_scene.add_child(bullet)
	
	shoot_sound.stop()
	cooldown.start()
	shoot_sound.play()
