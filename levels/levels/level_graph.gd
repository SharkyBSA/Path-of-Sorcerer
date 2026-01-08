@tool
class_name Level_Graph extends Resource

@export var level_list : Array[Level_Item]:
	set(val):
		level_list=val
		for i in range(level_list.size()):
			if level_list[i]==null:
				level_list[i]=Level_Item.new()

var _current_level_index : int = 0

func load_level(level_index : int)->Level:
	if (level_index<0 || level_index>=level_list.size()):
		return null
	_current_level_index=level_index
	var level_scene : PackedScene = load(level_list[level_index].level_path)
	return level_scene.instantiate()

func load_next_level()->Level:
	return load_level(level_list[_current_level_index].next_level)
