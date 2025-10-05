extends Node3D

@onready var _ui: MainSceneUI = $UI
@onready var _working_zone: WorkingZone = $WorkingZone
@onready var _player: Player = $Player
@onready var _tube_button: TubeButton = $TubeButton
@onready var _tube: Tube = $Tube
@onready var _quota: Quota = $Quota
@onready var _pause_controller: PauseController = $PauseController
@onready var _pause_screen: Control = $PauseScreen
@onready var _game_over_screen: Control = $GameOverScreen

var _first_interacted = false
var _is_quota_started = false

func _ready() -> void:
	_working_zone.enter_working_zone.connect(_on_enter_working_zone)
	_working_zone.exit_working_zone.connect(_on_exit_working_zone)
	
	_tube_button.enter_button_area.connect(_on_enter_button_area)
	_tube_button.exit_button_area.connect(_on_exit_button_area)
	_tube_button.pressed.connect(_on_button_pressed)
	
	_player.money_changed.connect(_on_money_changed)
	
	_quota.quota_started.connect(_on_quota_started)
	_quota.quota_changed.connect(_on_quota_changed)
	_quota.quota_timer_tick.connect(_on_quota_timer_tick)
	_quota.quota_finished.connect(_on_quota_finished)
	
	_pause_controller.game_paused.connect(_on_game_paused)
	_pause_controller.game_resumed.connect(_on_game_resumed)
	
	_pause_controller.visible = false
	_game_over_screen.visible = false
	
	_ui.welcome_message()
	_ui.update_quota_value(_quota.quota_value)
	_ui.update_quota_timer(_quota.quota_timer)

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
	if not _is_quota_started:
		_quota.start()
		
	if not _first_interacted:
		_first_interacted = true
		_ui.hide_message()
		
	_tube.spawn()

func _on_money_changed(value: float) -> void:
	_ui.update_money_value(value)
	
	var current_quota = _quota.quota_value
	_ui.update_quota_reached(value >= current_quota)

func _on_quota_changed(quota: Quota) -> void:
	_ui.update_quota_value(quota.quota_value)
	_ui.update_quota_timer(quota.quota_timer)

func _on_quota_timer_tick(remaining: float) -> void:
	_ui.update_quota_timer(remaining)

func _on_quota_started() -> void:
	_is_quota_started = true

func _on_quota_finished() -> void:
	_is_quota_started = false
	var quota_value = _quota.quota_value
	if _player.has_enough_money(quota_value):
		_player.withdraw_money(quota_value)
		_quota.next_quota()
		_quota.start()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		_game_over_screen.visible = true

func _on_game_paused() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	_pause_screen.visible = true

func _on_game_resumed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	_pause_screen.visible = false
