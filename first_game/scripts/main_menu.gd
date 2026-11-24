extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Music.play()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
