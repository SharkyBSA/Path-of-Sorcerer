extends Room

@onready var mob_11: Mob = %Mob11
@onready var mob_12: Mob = %Mob12
@onready var mob_13: Mob = %Mob13
@onready var door: Door = %Door
@onready var player_enter_room_detect: Area2D = %PlayerEnterRoomDetect

var room_cleaned : bool = false

func _ready() -> void:
	super()
	player_enter_room_detect.body_entered.connect(_on_player_enter_room)
	get_tree().create_timer(2).timeout.connect(_on_timer_check_room)
	
func _on_player_enter_room(body : CharacterBody2D)->void:
	if body is Player:
		door.opened=room_cleaned
		player_enter_room_detect.queue_free()

func _on_timer_check_room()->void:
	if mob_11 == null && mob_12 == null && mob_13 == null:
		room_cleaned = true
		door.opened = true
	else :
		get_tree().create_timer(2).timeout.connect(_on_timer_check_room)
