@tool
class_name Pickup extends Area2D

@export var item : Item = null :
	set = _set_item
	
func _set_item(val : Item)->void:
	item = val
	if item.texture != null:
		%Sprite.texture = item.texture
	else:
		print("Pas de texture")
	if item.pickup_sound!=null:
		%PickupSound.stop()
		%PickupSound.stream = item.pickup_sound
	else:
		print("Pas de son")
	update_configuration_warnings()

func _ready() -> void:
	body_entered.connect(func(body : CharacterBody2D)->void:
		if body is Player:
			item.use(body)
			%PickupSound.play()
			%Sprite.visible=false
			set_deferred("monitoring",false)
			await %PickupSound.finished
			queue_free()
		)

func _get_configuration_warnings() -> PackedStringArray:
	if item == null:
		return ["Aucun type d'objet chargé" ]
	return []
	
	
