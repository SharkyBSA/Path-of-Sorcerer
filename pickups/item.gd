@abstract class_name Item extends Resource

@export var texture : Texture2D = null
@export var pickup_sound : AudioStream = null

@abstract func use(body : CharacterBody2D)->void
