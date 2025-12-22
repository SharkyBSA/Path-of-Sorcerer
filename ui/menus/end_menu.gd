class_name EndMenu extends Control

const CONFETTI_SCREEN_SPAWN = preload("res://ui/menus/confetti_screen_spawn.tscn")

signal go_to_title
signal play_again

@onready var play_again_btn: Button = %PlayAgain
@onready var quit_btn: Button = %Quit
@onready var go_to_title_btn: Button = %GoToTitle

@onready var game_start = Time.get_ticks_msec()
@onready var temps: Label = %Temps
@onready var display_time_ms : float = 0:
	set(val):
		display_time_ms = val
		temps.text = gen_displayed_time(display_time_ms)
	
func _ready() -> void:
	play_again_btn.pressed.connect(func()->void:
		close()
		play_again.emit()
		)
	go_to_title_btn.pressed.connect(func()->void:
		close()
		go_to_title.emit()
		)
	quit_btn.pressed.connect(func()->void:
		get_tree().quit()
	)
	
	if OS.get_name()=="Web":
		quit_btn.queue_free()
	
func open()->void:
	visible = true
	get_tree().paused = true
	display_time_ms = Time.get_ticks_msec() - game_start
	
	for i in randi_range(5,10):
		var confetti : GPUParticles2D = CONFETTI_SCREEN_SPAWN.instantiate()
		var screen_size : = get_viewport_rect().size
		confetti.global_position= Vector2(randf_range(0,screen_size.x),screen_size.y)
		confetti.emitting = true
		add_child(confetti)
		await get_tree().create_timer(randf_range(0.4,0.7)).timeout

func close()->void:
	visible = false
	get_tree().paused = false

func gen_displayed_time(temps_ms : float)->String:
	var text : String = "Temps: "
	if temps_ms < 1000:
		return text + str(int(temps_ms))+"ms"
	else:
		temps_ms/=1000
	
	if temps_ms < 60 :
		return text +str(temps_ms) +"s"
	else:
		var mins = int(temps_ms)/60
		var secs = int(temps_ms)%60
		text += str(mins)+"mins "+str(secs)+"s"
	return text
