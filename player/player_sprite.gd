extends Sprite2D

const GODOT_BOTTOM : Texture2D = preload("uid://bw03btxpkxde4")
const GODOT_BOTTOM_RIGHT : Texture2D  = preload("uid://cm33qabjyo48g")
const GODOT_RIGHT : Texture2D  = preload("uid://dscj1kv8s4bxa")
const GODOT_UP : Texture2D  = preload("uid://b2q8n8kfhhbi7")
const GODOT_UP_RIGHT : Texture2D  = preload("uid://deiak2vt25cwr")

func _physics_process(_delta: float) -> void:
	var input_vec :  = Input.get_vector("player_left","player_right","player_up","player_down")
	if input_vec.length()==0:
		return
		
	var input_rotation : float = input_vec.angle()
	var input_code : int = round(input_rotation/(PI/4))
	
	if [-4,4,0,0].has(input_code):
		texture = GODOT_RIGHT
	elif [-3,-1].has(input_code):
		texture= GODOT_UP_RIGHT
	elif [3,1].has(input_code):
		texture= GODOT_BOTTOM_RIGHT
	elif input_code == 2:
		texture = GODOT_BOTTOM
	elif input_code==-2:
		texture = GODOT_UP
	
	flip_h = abs(input_code)>=3

	
	
	
