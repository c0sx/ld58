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
@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var _first_interacted = false
var _is_quota_started = false
var _score = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Engine.max_fps = 60

	_working_zone.enter_working_zone.connect(_on_enter_working_zone)
	_working_zone.exit_working_zone.connect(_on_exit_working_zone)
	_working_zone.exit_working_zone_tick.connect(_on_exit_working_zone_tick)
	_working_zone.exit_working_zone_exceeded.connect(_on_exit_working_zone_exceeded)
	
	_tube_button.enter_button_area.connect(_on_enter_button_area)
	_tube_button.exit_button_area.connect(_on_exit_button_area)
	_tube_button.pressed.connect(_on_button_pressed)
	
	_player.item_collected.connect(_on_item_collected)
	_player.inventory_changed.connect(_on_inventory_changed)
	
	_quota.quota_started.connect(_on_quota_started)
	_quota.quota_timer_tick.connect(_on_quota_timer_tick)
	_quota.quota_finished.connect(_on_quota_finished)
	
	_pause_controller.game_paused.connect(_on_game_paused)
	_pause_controller.game_resumed.connect(_on_game_resumed)
	
	_pause_controller.visible = false
	_game_over_screen.visible = false
	
	_ui.welcome_message()
	_ui.update_quota_timer(_quota.quota_timer)

func _input(event) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_enter_working_zone() -> void:
	_ui.hide_message()
	
func _on_exit_working_zone(timeout: float) -> void:
	_ui.render_return_to_the_working_zone_message(timeout)
	
func _on_exit_working_zone_tick(remaining: float) -> void:
	_audio_stream_player.stream = load("res://assets/sounds/blip.wav")
	_audio_stream_player.play()
	
	_ui.render_return_to_the_working_zone_message(remaining)
	
func _on_exit_working_zone_exceeded() -> void:
	_game_over()
	
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
	
func _on_item_collected(item: LootItemResource) -> void:
	_score += item.score
	_ui.update_score(_score)

func _on_inventory_changed() -> void:
	var plan = _player.build_plan(_quota.get_current_quota())
	_ui.update_quota_plan(plan)

func _on_quota_timer_tick(remaining: float) -> void:
	_ui.update_quota_timer(remaining)

func _on_quota_started(quota: Dictionary, timer: float) -> void:
	_is_quota_started = true
	var plan = _player.build_plan(quota)
	_ui.update_quota_plan(plan)
	_ui.update_quota_timer(timer)

func _on_quota_finished() -> void:
	_is_quota_started = false
	
	var result = _quota.check_quota(_player)
	if not result:
		_game_over()
	else:
		_player.withdraw_items(_quota.get_current_quota())
		_quota.start()
		
func _game_over() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	_game_over_screen.update_score(_score)
	_game_over_screen.visible = true

func _on_game_paused() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	_pause_screen.visible = true

func _on_game_resumed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	_pause_screen.visible = false
