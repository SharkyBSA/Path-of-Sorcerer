@tool
extends Level

@onready var teleporter: Teleporter = %Teleporter

func _ready() -> void:
	if not Engine.is_editor_hint():
		teleporter.player_entered.connect(change_level.emit)
