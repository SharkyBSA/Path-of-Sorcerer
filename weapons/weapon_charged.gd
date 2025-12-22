@tool 
@icon("res://player/hand_ice.png")
class_name Weapon_Charged extends Weapon

@export_group("Weapon Stats")
@export var max_charge_time : float = 3
@export var min_charge_time : float = 1

@onready var particles: GPUParticles2D = %Particles
var current_charge_time : float = 0.0
var particle_max_velocity : float = 150

func _ready() -> void:
	particles.emitting=false
	if Engine.is_editor_hint():
		set_physics_process(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		particles.emitting =true
	elif event.is_action_released("shoot"):
		particles.emitting=false

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		current_charge_time = clampf(current_charge_time+delta,0.0,max_charge_time)
		var charge_ratio : float = current_charge_time/max_charge_time
		var particle_properties : ParticleProcessMaterial = particles.process_material
		particle_properties.initial_velocity_min=0.7*particle_max_velocity*charge_ratio
		particle_properties.initial_velocity_max=1.3*particle_max_velocity*charge_ratio
	elif current_charge_time>0:
		shoot()
	
func shoot()->void:
	if current_charge_time >min_charge_time:
		var bullet : Bullet = bullet_scene.instantiate()
		var charge_ratio = current_charge_time/max_charge_time
		bullet.damage*= charge_ratio
		bullet.scale= Vector2.ONE*2*charge_ratio
		bullet.global_rotation = global_rotation +randf_range(-spread/2,spread/2)
		bullet.global_position = global_position
		bullet.max_range = max_range
		bullet.speed =  max_speed
		get_tree().current_scene.add_child(bullet)
		shoot_sound.play()
		
	current_charge_time=0.0
