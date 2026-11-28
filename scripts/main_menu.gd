extends Control

func _ready():
	# Start the Menu Music on the First Load.
	if AutoloadScript.visited_main_menu_scene:
		MenuMusic.play()
		AutoloadScript.visited_main_menu_scene = false


func _on_start_pressed() -> void:
	# Change Scene to Main Game.
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	MenuMusic.stop()
	Music.play()


func _on_options_pressed() -> void:
	# Cange Scene to Options Scene.
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")


func _on_quit_pressed() -> void:
	# Quit the Game.
	get_tree().quit()
