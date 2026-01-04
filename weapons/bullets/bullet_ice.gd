@icon("res://weapons/bullets/ice.png")
class_name Bullet_Ice extends Bullet

func _destroy()->void:
	visible=false
	set_physics_process(false)
	set_deferred("monitoring","false")
	if has_hit:
		$ImpactSound.play()
		await $ImpactSound.finished 
	queue_free()
