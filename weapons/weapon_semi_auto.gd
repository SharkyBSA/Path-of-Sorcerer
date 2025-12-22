@tool 
@icon("res://player/hand_fire_closed.png")

class_name Weapon_SemiAuto extends Weapon

@export_range(1.0,60,0.1) var shots_per_secs : float = 5
@onready var cooldown: Timer = $Cooldown
var weapon_ready: bool = true

func _ready() -> void:
	cooldown.wait_time = 1/shots_per_secs
	cooldown.timeout.connect(func ()->void: 
		weapon_ready=true)
	if Engine.is_editor_hint():
		set_physics_process(false)

func _physics_process(_delta: float) -> void:
	if (Input.is_action_pressed("shoot") && weapon_ready):
		shoot()
		
func shoot()->void:
	var bullet : Bullet = bullet_scene.instantiate()
	bullet.global_rotation = global_rotation +randf_range(-spread/2,spread/2)
	bullet.global_position = global_position
	bullet.max_range = max_range
	bullet.speed = max_speed
	get_tree().current_scene.add_child(bullet)
	
	weapon_ready = false
	shoot_sound.stop()
	shoot_sound.pitch_scale = randf_range(0.20,0.3)
	shoot_sound.play()
	cooldown.start()
	
