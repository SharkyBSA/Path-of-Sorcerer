class_name PlayerHUD extends Control

@onready var _health_bar: ProgressBar = %HealthBar
@onready var _weapon_selection_bar: HBoxContainer = %WeaponSelectionBar

const FLAME_ICON_INACTIVE = preload("uid://bfongmgv8818b")
const FLAME_ICON_ACTIVE = preload("uid://kc6ajejxliwa")
const ICE_ICON_INACTIVE = preload("uid://e34yvarahyhf")
const ICE_ICON_ACTIVE = preload("uid://dc5c7gg3qpq8l")
const LIGHTNING_ICON_INACTIVE = preload("uid://j2fclskdnc1m")
const LIGHTNING_ICON_ACTIVE = preload("uid://dy61ateuywnyk")

const WEAPON_ICONS : Dictionary[Player.WeaponType,Dictionary]={
	Player.WeaponType.SEMI_AUTO:
		{"active":FLAME_ICON_ACTIVE,
		"inactive":FLAME_ICON_INACTIVE},
	Player.WeaponType.SHOTGUN:
		{"active":FLAME_ICON_ACTIVE,
		"inactive":FLAME_ICON_INACTIVE},
	Player.WeaponType.CHARGED:
		{"active":ICE_ICON_ACTIVE,
		"inactive":ICE_ICON_INACTIVE},
	Player.WeaponType.FULL_AUTO:
		{"active":LIGHTNING_ICON_ACTIVE,
		"inactive":LIGHTNING_ICON_INACTIVE},
}
var _weapon_selection_bar_content : Array[Player.WeaponType]
var _selected_weapon_index : int = -1:
	set = set_selected_weapon_index

func _ready() -> void:
	clear_weapon_selection_bar()
		
func set_health_bar_value(val : int)->void:
	_health_bar.value=val

func set_health_bar_max_value(val: int)->void:
	_health_bar.max_value=val

func clear_weapon_selection_bar()->void:
	for child in _weapon_selection_bar.get_children():
		_weapon_selection_bar.remove_child(child)
		child.queue_free()
	_weapon_selection_bar_content.clear()

func set_selected_weapon_index(weapon_index: int)->void:
	if (weapon_index<0 || weapon_index>=_weapon_selection_bar_content.size()):
		return
		
	var previously_selected_weapon_index : TextureRect = _weapon_selection_bar.get_child(_selected_weapon_index)
	previously_selected_weapon_index.texture= WEAPON_ICONS[_weapon_selection_bar_content[_selected_weapon_index]]["inactive"]

	_selected_weapon_index=weapon_index
	var selected_weapon_texture_rect : TextureRect = _weapon_selection_bar.get_child(weapon_index)
	selected_weapon_texture_rect.texture=WEAPON_ICONS[_weapon_selection_bar_content[_selected_weapon_index]]["active"]

func set_weapon_selection_bar_content(player_weapons : Array[Weapon])->void:
	clear_weapon_selection_bar()
	
	var weapon_inserted_index : int = -1
	for weapon in player_weapons:
		var icon_node : = TextureRect.new()
		icon_node.custom_minimum_size=Vector2i(150,150)
		if weapon is Weapon_SemiAuto:
			_weapon_selection_bar_content.append(Player.WeaponType.SEMI_AUTO)
		elif weapon is Weapon_Shotgun:
			_weapon_selection_bar_content.append(Player.WeaponType.SHOTGUN)
		elif weapon is Weapon_Charged:
			_weapon_selection_bar_content.append(Player.WeaponType.CHARGED)
		elif weapon is Weapon_FullAuto:
			_weapon_selection_bar_content.append(Player.WeaponType.FULL_AUTO)
		else:
			return
				
		weapon_inserted_index+=1
		
		if _selected_weapon_index==weapon_inserted_index:
			icon_node.texture=WEAPON_ICONS[_weapon_selection_bar_content[weapon_inserted_index]]["active"]
		else:
			icon_node.texture=WEAPON_ICONS[_weapon_selection_bar_content[weapon_inserted_index]]["inactive"]
		_weapon_selection_bar.add_child(icon_node)
