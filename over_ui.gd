extends CanvasLayer

@onready var status_label: Label = $PanelContainer/status
@onready var objective_label: Label = $PanelContainer/objective
@onready var replay_button: Button = $PanelContainer/replay
@onready var panel_container: Control = $PanelContainer
@onready var status_2: Label = $PanelContainer/status2

func _ready() -> void:
	status_label.hide()
	replay_button.hide()
	status_2.show()

	GameManager.connect("game_over", Callable(self, "_on_game_over"))
	update_objective()

func _process(delta: float) -> void:
	update_objective()

func update_objective() -> void:
	if Input.is_anything_pressed():
			status_2.hide()
	var remaining = GameManager.total_enemies - GameManager.enemies_defeated
	objective_label.text = "Enemies Left: " + str(remaining)

func _on_game_over(won: bool) -> void:
	status_label.show()
	replay_button.show()
	if won:
		status_label.text = "You Win!"
	else:
		status_label.text = "Game Over"
