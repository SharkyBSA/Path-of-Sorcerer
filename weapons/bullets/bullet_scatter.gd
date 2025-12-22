@icon("res://weapons/bullets/fire.png")
class_name Bullet_Scatter extends Bullet

func _destroy()->void:
	queue_free()
		
