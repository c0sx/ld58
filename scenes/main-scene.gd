extends Node3D

@onready var _ui: MainSceneUI = $UI
@onready var _working_zone: WorkingZone = $WorkingZone
@onready var _player: Player = $Player

func _ready() -> void:
	_working_zone.enter_working_zone.connect(_on_enter_working_zone)
	_working_zone.exit_working_zone.connect(_on_exit_working_zone)
	

func _on_enter_working_zone() -> void:
	_ui.hide_return_to_the_working_zone_message()
	
func _on_exit_working_zone() -> void:
	_ui.render_return_to_the_working_zone_message()
