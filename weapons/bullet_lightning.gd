@icon("res://weapons/bullets/lightning.png")
class_name Bullet_Lightning extends Bullet

func _destroy()->void:
	queue_free()
