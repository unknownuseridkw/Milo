extends Button


	

func _pressed() -> void:
	print("Button was clicked!")
	get_tree().paused = false
	GameManager.reset_game()
	get_tree().reload_current_scene()
