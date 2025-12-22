@icon("res://mobs/shield_active.png")
class_name Mob_Weapon extends Weapon

func shoot()->void:
	var bullet : Bullet = bullet_scene.instantiate()
	bullet.target_player=true
	bullet.global_rotation = global_rotation +randf_range(-spread/2,spread/2)
	bullet.global_position = global_position
	bullet.max_range = max_range
	bullet.speed = max_speed
	get_tree().current_scene.call_deferred("add_child",bullet)
	
	shoot_sound.stop()
	shoot_sound.pitch_scale = randf_range(0.8,0.85)
	shoot_sound.play()
