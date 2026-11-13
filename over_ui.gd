extends CanvasLayer

@onready var status_label: Label = $PanelContainer/status
@onready var objective_label: Label = $PanelContainer/objective
@onready var replay_button: Button = $PanelContainer/replay
@onready var panel_container: Control = $PanelContainer

func _ready() -> void:
	status_label.hide()
	replay_button.hide()
	
	GameManager.connect("game_over", Callable(self, "_on_game_over"))
	update_objective()

func _process(delta: float) -> void:
	update_objective()

func update_objective() -> void:
	var remaining = GameManager.total_enemies - GameManager.enemies_defeated
	objective_label.text = "Enemies Left: " + str(remaining)

func _on_game_over(won: bool) -> void:
	status_label.show()
	replay_button.show()
	if won:
		status_label.text = "You Win!"
	else:
		status_label.text = "Game Over"
