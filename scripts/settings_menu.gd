extends Control

@onready var mute: CheckBox = $ButtonManager/Mute
@onready var screen_mode: OptionButton = $ButtonManager/ScreenMode
@onready var volume: HSlider = $ButtonManager/Volume

func _ready() -> void:
	# Visually Sync Buttons Across Scene Transitions.
	mute.button_pressed = AudioServer.is_bus_mute(0)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		screen_mode.selected = 0
	else:
		screen_mode.selected = 1
	volume.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(0)))


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)


func _on_screen_mode_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
