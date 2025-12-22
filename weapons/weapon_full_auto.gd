@tool 
@icon("res://player/hand_lightning.png")
class_name Weapon_FullAuto extends Weapon

@export_range(1.0,60,0.1) var shots_per_secs : float = 20

@onready var particles_left: GPUParticles2D = %ParticlesLeft
@onready var particles_right: GPUParticles2D = %ParticlesRight
var particle_left_material : ParticleProcessMaterial 
var particle_right_material : ParticleProcessMaterial 

@onready var cooldown: Timer = $Cooldown

func _ready() -> void:
	particles_left.emitting=false
	particles_right.emitting=false
	particle_left_material=particles_left.process_material
	particle_right_material=particles_right.process_material
	cooldown.wait_time = 1/shots_per_secs

	if Engine.is_editor_hint():
		set_physics_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		particles_left.emitting =true
		particles_right.emitting =true
		shoot_sound.play()
	elif event.is_action_released("shoot"):
		particles_left.emitting =false
		particles_right.emitting =false
		shoot_sound.stop()

func _physics_process(_delta: float) -> void:
	particle_left_material.angle_min = -20  -rad_to_deg(global_rotation)
	particle_left_material.angle_max = -20  -rad_to_deg(global_rotation)
	particle_right_material.angle_min = +20 -rad_to_deg(global_rotation)
	particle_right_material.angle_max = +20 -rad_to_deg(global_rotation)
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot()->void:
	var bullet : Bullet = bullet_scene.instantiate()
	bullet.global_rotation = global_rotation +randf_range(-spread/2,spread/2)
	bullet.global_position = global_position+Vector2(100,0).rotated(global_rotation)
	bullet.max_range = max_range
	bullet.speed = max_speed
	bullet.scale = Vector2.ONE *0.5
	get_tree().current_scene.add_child(bullet)
	
	shoot_sound.pitch_scale = 0.4
	cooldown.start()
	
	
	
