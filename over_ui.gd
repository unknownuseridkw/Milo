extends CanvasLayer

@onready var status_label: Label = $PanelContainer/Box/status
@onready var objective_label: Label = $PanelContainer/Box/objective
@onready var replay_button: Button = $PanelContainer/Box/replay
@onready var panel_container: Control = $PanelContainer

func _ready() -> void:
	panel_container.hide()
	GameManager.connect("game_over", Callable(self, "_on_game_over"))
	replay_button.connect("pressed", Callable(self, "_on_replay_pressed"))
	update_objective()

func _process(delta: float) -> void:
	update_objective()

func update_objective() -> void:
	var remaining = GameManager.total_enemies - GameManager.enemies_defeated
	objective_label.text = "Enemies Left: " + str(remaining)

func _on_game_over(won: bool) -> void:
	panel_container.show()
	if won:
		status_label.text = "You Win!"
	else:
		status_label.text = "Game Over"

func _on_replay_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
