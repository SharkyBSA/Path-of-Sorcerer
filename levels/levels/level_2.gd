@tool
extends Level

@onready var teleporter: Teleporter = %Teleporter

func _ready() -> void:
	teleporter.player_entered.connect(change_level.emit)
