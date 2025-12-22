@tool
@icon("res://levels/rooms/entrances/door_closed.png")
class_name Door extends StaticBody2D

enum Direction {HORIZONTAL,VERTICAL}
@export var direction : Direction : 
	set = set_direction
@export var opened : bool = false :
	set = set_opened
	
const DOOR_BEAM : Texture2D = preload("uid://d08now2ab4buo")
const DOOR_BEAM_VERTICAL : Texture2D = preload("uid://bprfgkbp5oaxa")
const DOOR_CLOSED : Texture2D = preload("uid://imlsp3py47kg")
const DOOR_CLOSED_VERTICAL : Texture2D = preload("uid://c7efh436s8re")
const DOOR_OPEN : Texture2D = preload("uid://bqopblk5ilols")
const DOOR_OPEN_VERTICAL : Texture2D = preload("uid://cqewufr1s28k5")

@onready var base_sprite: Sprite2D = %BaseSprite
@onready var beam_sprite: Sprite2D = %BeamSprite
@onready var hit_box: CollisionShape2D = %CollisionShape2D

func _ready() -> void:
	set_direction(direction)
	set_opened(opened)

func set_direction(val : Direction)->void:
	direction=val
	if not is_node_ready():
		return
		
	if (direction == Direction.HORIZONTAL):
		if opened:
			base_sprite.texture = DOOR_OPEN
		else :
			base_sprite.texture = DOOR_CLOSED
		beam_sprite.texture = DOOR_BEAM
		beam_sprite.position = Vector2(0,-7)
		base_sprite.position = Vector2(0,42)
		var hit_box_rectangle = hit_box.shape as RectangleShape2D
		hit_box_rectangle.size = Vector2(130,64)
		hit_box.position= Vector2(0,32)
	else:
		if opened:
			base_sprite.texture = DOOR_OPEN_VERTICAL
		else :
			base_sprite.texture = DOOR_CLOSED_VERTICAL
		beam_sprite.texture = DOOR_BEAM_VERTICAL
		beam_sprite.position = Vector2(0,-1)
		base_sprite.position = Vector2(0,70)
		var hit_box_rectangle = hit_box.shape as RectangleShape2D
		hit_box_rectangle.size = Vector2(64,130)
		hit_box.position= Vector2(0,64)
	
	
func set_opened(val : bool)->void:
	opened=val
	if not is_node_ready():
		return
	hit_box.set_deferred("disabled",val)
	beam_sprite.visible=not val
	set_direction(direction)
	
