@tool
class_name Spawner extends Marker2D

enum SpawnableEntities {MOB, SHOOT_MOB}

@export var spawn_on_ready : bool = true
@export var spawn_type : SpawnableEntities = SpawnableEntities.MOB :
	set(val):
		spawn_type=val
		if Engine.is_editor_hint():
			_preview()

const MOB_SCENE : PackedScene = preload("uid://c0i2gypp2yyrp")
const MOB_SHOOT_SCENE : PackedScene = preload("uid://80fwms4qyswm")

var _preview_node : Node2D = null

func _ready() -> void:
	if Engine.is_editor_hint():
		_preview()
	else:
		if spawn_on_ready:
			spawn()

func select_entity_to_spawn(type : SpawnableEntities)->Node2D:
	match type:
		SpawnableEntities.MOB:
			return MOB_SCENE.instantiate()
		SpawnableEntities.SHOOT_MOB:
			return MOB_SHOOT_SCENE.instantiate()
		_:
			return Node2D.new()

#Preview et _preview_node sont uniquement présents pour servir d'indication visuelle 
#lors du placement du spawner
func _preview()->void:
	var mob : Node2D = select_entity_to_spawn(spawn_type)
	mob.modulate.a=mob.modulate.a/2
	if _preview_node!=null && _preview_node.get_parent()!=null:
		_preview_node.get_parent().remove_child(_preview_node)
		
	add_child(mob,false,Node.INTERNAL_MODE_BACK)
	_preview_node=mob

func spawn()->Node2D:
	var spawned : Node2D = select_entity_to_spawn(spawn_type)
	get_tree().current_scene.call_deferred("add_child",spawned)
	spawned.global_transform=global_transform
	return spawned
