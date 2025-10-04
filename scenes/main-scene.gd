extends Node3D

@onready var _ui: MainSceneUI = $UI
@onready var _working_zone: WorkingZone = $WorkingZone
@onready var _player: Player = $Player
@onready var _button: TubeButton = $TubeButton

var _first_interacted = false

func _ready() -> void:
	_working_zone.enter_working_zone.connect(_on_enter_working_zone)
	_working_zone.exit_working_zone.connect(_on_exit_working_zone)
	
	_button.enter_button_area.connect(_on_enter_button_area)
	_button.exit_button_area.connect(_on_exit_button_area)
	_button.pressed.connect(_on_button_pressed)
	
	_ui.welcome_message()

func _on_enter_working_zone() -> void:
	_ui.hide_message()
	
func _on_exit_working_zone() -> void:
	_ui.render_return_to_the_working_zone_message()
	
func _on_enter_button_area() -> void:
	if not _first_interacted:
		_ui.render_interact_message()

func _on_exit_button_area() -> void:
	_ui.hide_message()

func _on_button_pressed() -> void:
	if not _first_interacted:
		_first_interacted = true
		_ui.hide_message()
