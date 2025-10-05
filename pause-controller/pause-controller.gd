class_name PauseController
extends Node3D

var _is_paused = false

signal game_paused
signal game_resumed

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if _is_paused:
			_is_paused = false
			emit_signal("game_resumed")
		else:
			_is_paused = true
			emit_signal("game_paused")
		
