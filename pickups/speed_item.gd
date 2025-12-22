class_name SpeedItem extends Item

@export var  boost : int = 0

func use(body : CharacterBody2D)->void:
	if body is Player:
		body.max_speed+= boost
