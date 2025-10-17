class_name TubeButton
extends Node3D

@onready var _area3d: Area3D = $Area3D
@onready var _cursor: Sprite3D = $Cursor
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

signal enter_button_area
signal exit_button_area
signal pressed

var _animation_pending = false

func _ready() -> void:
	_area3d.body_entered.connect(_on_enter)
	_area3d.body_exited.connect(_on_exit)
	_animation_player.animation_finished.connect(_on_animation_finished)

	_cursor.visible = false

func interact() -> void:
	if _animation_pending:
		return

	_animation_player.play("press_button")
	_animation_pending = true
	emit_signal('pressed')

	_audio_stream_player.stream = load("res://assets/sounds/button0.wav")

	var pitch_variation = randf_range(-0.1, 0.1)
	_audio_stream_player.pitch_scale = 1.0 + pitch_variation

	_audio_stream_player.play()

func _on_enter(body) -> void:
	if body is Player:
		body.set_interactable(self)
		emit_signal('enter_button_area')

func _on_exit(body) -> void:
	if body is Player:
		body.set_interactable(null)
		emit_signal('exit_button_area')

func _on_animation_finished(_a) -> void:
	_animation_pending = false
