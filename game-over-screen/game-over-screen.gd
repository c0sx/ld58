class_name GameOverScreen
extends Control

@export var score = 0.0

@onready var _restart_button: Button = $RestartButton
@onready var _score: Label = $Score

func _ready() -> void:
	_restart_button.pressed.connect(_on_clicked)
	
func update_score(score: float) -> void:
	_score.text = "Score: " + str(int(score))

func _on_clicked() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
