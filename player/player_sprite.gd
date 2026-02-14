extends Sprite2D

@export_range(0.0,30.0,1.0,"radians_as_degrees") var inclinaison_max : float 

const GODOT_BOTTOM : Texture2D = preload("uid://bw03btxpkxde4")
const GODOT_BOTTOM_RIGHT : Texture2D  = preload("uid://cm33qabjyo48g")
const GODOT_RIGHT : Texture2D  = preload("uid://dscj1kv8s4bxa")
const GODOT_UP : Texture2D  = preload("uid://b2q8n8kfhhbi7")
const GODOT_UP_RIGHT : Texture2D  = preload("uid://deiak2vt25cwr")

var inclinaison_tweener : Tween 
var inclinaison_target : float = 0.0

func _ready() -> void:
	inclinaison_tweener = create_tween()

func _physics_process(_delta: float) -> void:
	var input_vec := Input.get_vector("player_left","player_right","player_up","player_down")
	if input_vec.length()==0:
		tween_inclinaison(0)
		return
		
	var input_rotation : float = input_vec.angle()
	var input_code : int = round(input_rotation/(PI/4))
	
	if [-4,4,0].has(input_code):
		texture = GODOT_RIGHT
	elif input_code==0:
		texture = GODOT_RIGHT
	elif [-3,-1].has(input_code):
		texture= GODOT_UP_RIGHT
	elif [3,1].has(input_code):
		texture= GODOT_BOTTOM_RIGHT
	elif input_code == 2:
		texture = GODOT_BOTTOM
	elif input_code==-2:
		texture = GODOT_UP
	
	tween_inclinaison(get_target_inclinaison_from_input_code(input_code))
	flip_h = abs(input_code)>=3

func get_target_inclinaison_from_input_code(input_code: int)->float:
	return (abs(input_code)-2)*(-inclinaison_max/2)

func tween_inclinaison(new_target_inclinaison: float)->void:
	if new_target_inclinaison == inclinaison_target:
		return
		
	if inclinaison_tweener != null:
		inclinaison_tweener.kill()
	
	inclinaison_target=new_target_inclinaison
	inclinaison_tweener = create_tween()
	inclinaison_tweener.tween_property(self,"rotation",inclinaison_target,0.1)
	print("Set target inclinaison: ",rad_to_deg(inclinaison_target))
	
