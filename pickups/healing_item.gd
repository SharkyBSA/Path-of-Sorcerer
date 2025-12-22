class_name HealingItem extends Item

@export var healing_amount : int = 5

func use(body : CharacterBody2D)->void:
	if body is Player:
		body.health+=healing_amount
