@tool
@icon("res://levels/rooms/teleporter/teleporter_base.png")
class_name Teleporter extends Area2D

signal player_entered

@export var active : bool = true:
	set = set_active
	
@onready var teleporter_beam_green: Sprite2D = %TeleporterBeamGreen
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D

func _ready() -> void:
	set_active(active)
	body_entered.connect(func(body : CharacterBody2D)->void:
		if body is Player:
			player_entered.emit()
		)
		
func set_active(val : bool)->void :
	active = val
	if not is_node_ready():
		return
	teleporter_beam_green.visible = active
	monitoring = active
	gpu_particles_2d.emitting= active
