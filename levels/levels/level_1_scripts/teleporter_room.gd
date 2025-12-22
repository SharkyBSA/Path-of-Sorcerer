extends Room

@onready var teleporter: Teleporter = %Teleporter
@onready var mob_5: Mob = $Mob5
@onready var mob_8: Mob = $Mob8
@onready var shooting_mob_2: Shooting_Mob = $ShootingMob2
@onready var shooting_mob: Shooting_Mob = $ShootingMob
@onready var player_enter_room_detect: Area2D = $PlayerEnterRoomDetect
@onready var door: Door = $Door

var room_cleaned : bool = false

func _ready() -> void:
	super()
	player_enter_room_detect.body_entered.connect(_on_player_enter_room)
	get_tree().create_timer(2).timeout.connect(_on_timer_check_room)
	
func _on_player_enter_room(body : CharacterBody2D)->void:
	if body is Player:
		door.opened=room_cleaned
		teleporter.active=room_cleaned
		player_enter_room_detect.queue_free()

func _on_timer_check_room()->void:
	if mob_5 == null && mob_8 == null && shooting_mob_2 == null && shooting_mob == null:
		room_cleaned = true
		door.opened = true
		teleporter.active=true
	else :
		get_tree().create_timer(2).timeout.connect(_on_timer_check_room)
