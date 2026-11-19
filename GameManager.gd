extends Node
signal game_over(won:bool)

var total_enemies: int = 0
var enemies_defeated: int = 0
var gameStarted = true

func _ready() -> void:
	reset_game()

func reset_game() -> void:
	enemies_defeated = 0
	total_enemies = get_tree().get_nodes_in_group("enemies").size()
	gameStarted = true
	
func enemy_defeated() -> void:
	enemies_defeated += 1
	if total_enemies > 0 and enemies_defeated >= total_enemies:
		trigger_win()

func trigger_win() -> void:
	emit_signal("game_over", true)
	GameManager.gameStarted = false

func trigger_lose() -> void:
	emit_signal("game_over", false)
	GameManager.gameStarted = false
