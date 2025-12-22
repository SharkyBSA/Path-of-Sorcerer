class_name Settings_Menu extends Control

signal require_back

@onready var game_slider: HSlider = %GameSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var effect_slider: HSlider = %EffectSlider
@onready var back_button: Button = %BackButton

func _ready() -> void:
	
	game_slider.value=AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	music_slider.value=AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music"))
	effect_slider.value=AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Effects"))
	
	game_slider.value_changed.connect(func(val : float)->void:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),val)
		)
	music_slider.value_changed.connect(func(val : float)->void:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),val)
		)
	effect_slider.value_changed.connect(func(val : float)->void:
		AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Effects"),val)
		)
	
	back_button.pressed.connect(require_back.emit)

func open()->void:
	visible=true
	
func close()->void:
	visible=false
