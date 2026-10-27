extends Node
signal game_over(won:bool)

var total_enemies: int = 0
var enemies_defeated: int = 0

func _ready() -> void:
	reset_game()

func reset_game() -> void:
	enemies_defeated = 0
	total_enemies = get_tree().get_nodes_in_group("enemies").size()

func enemy_defeated() -> void:
	enemies_defeated += 1
	if enemies_defeated >= total_enemies:
		trigger_win()

func trigger_win() -> void:
	emit_signal("game_over", true)
	get_tree().paused = true

func trigger_lose() -> void:
	emit_signal("game_over", false)
	get_tree().paused = true
