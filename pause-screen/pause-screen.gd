class_name PauseScreen
extends Control

@onready var _quit_button: Button = $QuitButton

func _ready() -> void:
	_quit_button.pressed.connect(_on_quit_clicked)
	
func _on_quit_clicked() -> void:
	get_tree().quit()
