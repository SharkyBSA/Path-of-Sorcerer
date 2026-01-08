extends Room

@onready var door: Door = %Door
@onready var player_enter_room_detect: Area2D = %PlayerEnterRoomDetect

var spawned_mobs : Array[Node] = []

func _ready() -> void:
	super()
	player_enter_room_detect.body_entered.connect(_on_player_enter_room)
	
func _on_player_enter_room(body : CharacterBody2D)->void:
	if body is not Player:
		return
		
	door.opened=false
	player_enter_room_detect.queue_free()
	for child in get_children():
		if child is not Spawner:
			continue
		var mob : Node2D = child.spawn()
		spawned_mobs.append(mob)
		mob.tree_exited.connect(_check_room_cleared)
				
func _check_room_cleared()->void:
	var still_connected : int = 0;
	for node in spawned_mobs:
		still_connected+= 0 if node==null || node.get_parent()==null else 1
	
	if still_connected==0:
		get_tree().create_timer(2).timeout.connect(_on_room_cleared)

func _on_room_cleared()->void:
	door.opened=true
