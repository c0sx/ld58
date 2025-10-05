class_name GameOverScreen
extends Control

@onready var _restart_button: Button = $RestartButton

func _ready() -> void:
	_restart_button.pressed.connect(_on_clicked)
	
func _on_clicked() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
