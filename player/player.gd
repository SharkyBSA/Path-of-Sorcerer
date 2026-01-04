@icon("res://player/godot_bottom.png")
class_name Player extends CharacterBody2D

@export_group("Player Stats")
@export var max_speed : float = 250.0
@export var acceleration: float = 1000.0
@export var max_health: int = 20

enum WeaponType {SEMI_AUTO,SHOTGUN,CHARGED,FULL_AUTO}

var WEAPON_SEMI_AUTO : Weapon_SemiAuto = preload("uid://bngctva7f3mni").instantiate()
var WEAPON_SHOTGUN : Weapon_Shotgun = preload("uid://cqyr28ud7xfyy").instantiate()
var WEAPON_CHARGED : Weapon_Charged = preload("uid://wjydyg84ucq8").instantiate()
var WEAPON_FULL_AUTO : Weapon_FullAuto = preload("uid://t03upx3bu80l").instantiate()

var weapons : Array[Weapon] = [WEAPON_SEMI_AUTO]
var current_weapon_index : int = -1 :
	set = change_weapon

signal died
signal health_changed(new_health : int)
signal max_health_changed(new_max_health : int)
signal weapon_index_changed(new_weapon_index : int)
signal weapons_changed(weapon_type : Array[Weapon])

@onready var health:  = max_health:
	set(val):
		var old_health = health
		health=clampi(val, 0,max_health)
		health_changed.emit(health)
		if health<=0:
			die()
		elif old_health>health:
			_damage_sound_effect.play()

@onready var _damage_sound_effect: AudioStreamPlayer2D = %DamageSoundEffect
@onready var _death_sound_effect: AudioStreamPlayer2D = %DeathSoundEffect
@onready var _collision_shape_2d: CollisionShape2D = %HitBox
@onready var weapon: Weapon 

var speed : float = 0.0
var direction : Vector2

func _ready() -> void:
	tree_entered.connect(func()->void:
		max_health_changed.emit(max_health)
		health_changed.emit(health)
		weapons_changed.emit(weapons)
		weapon_index_changed.emit(current_weapon_index)
		)
	change_weapon(0)

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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("change_weapon_up"):
		current_weapon_index+=1
	if event.is_action_pressed("change_weapon_down"):
		current_weapon_index-=1
	if event is InputEventKey && event.is_released() :
		if event.keycode == KEY_ENTER:
			add_weapon(WeaponType.CHARGED)
		

func die()->void:
	_collision_shape_2d.set_deferred("disabled",true)
	set_all_physics_process(false)
	_death_sound_effect.play()
	await _death_sound_effect.finished
	died.emit()

func add_weapon(_new_weapon_type : WeaponType)->void:
	var weapon_to_add : Weapon
	match _new_weapon_type:
		WeaponType.SEMI_AUTO:
			weapon_to_add=WEAPON_SEMI_AUTO
		WeaponType.SHOTGUN:
			weapon_to_add=WEAPON_SHOTGUN
		WeaponType.CHARGED:
			weapon_to_add=WEAPON_CHARGED
		WeaponType.FULL_AUTO:
			weapon_to_add=WEAPON_FULL_AUTO
		_: 
			return
			
	if weapon_to_add in weapons:
		return
		
	weapons.append(weapon_to_add)
	weapons_changed.emit(weapons)

func change_weapon(new_weapon_index :int)->void:
	if new_weapon_index==current_weapon_index || weapons.is_empty():
		return
	if new_weapon_index<0 :
		current_weapon_index=weapons.size()-1
	elif new_weapon_index>=weapons.size():
		current_weapon_index=0
	else:
		current_weapon_index=new_weapon_index
	
	weapon=weapons[current_weapon_index]
	var weapon_anchor : Marker2D = %WeaponAnchor
	var weapon_anchor_children : Array[Node] = weapon_anchor.get_children()
	for node in weapon_anchor_children:
		if node is Weapon:
			weapon_anchor.remove_child(node)
	weapon_anchor.add_child(weapon)
	weapon_index_changed.emit(current_weapon_index)
	
func set_all_physics_process(val : bool)->void:
	set_physics_process(val)
	$PlayerSprite.set_physics_process(val)
	weapon.set_physics_process(val)
	%WeaponPivot.set_physics_process(val)
