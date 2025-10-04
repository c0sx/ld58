class_name LootItem
extends Node3D

@export var reward_approx: float = 100
@export var pick_duration: float = 1.5

@onready var _picking_area: Area3D = $Area3D
@onready var _sprite: Sprite3D = $Sprite3D
@onready var _sub_viewport: SubViewport = $SubViewport
@onready var _progress_bar: ProgressBar = $SubViewport/Control/ProgressBar

var _is_picking = false
var _picking_time = 0.0
var _player

func _ready() -> void:
	_picking_area.body_entered.connect(_on_enter)
	_picking_area.body_exited.connect(_on_exit)

func _process(delta: float) -> void:
	if not _is_picking:
		return
		
	var progress = _pick_progress(delta)
	if progress >= 1:
		_pick_complete()

func _on_enter(body) -> void:
	if not body is Player:
		return
	
	_player = body
	_pick_start()
		
func _on_exit(body) -> void:
	if not body is Player:
		return
		
	_pick_cancel()

func _pick_start() -> void:
	_is_picking = true
	_picking_time = 0.0
	
	_sprite.texture = _sub_viewport.get_texture()
	_sprite.visible = true

func _pick_progress(delta: float) -> float:
	_picking_time = clamp(_picking_time + delta, 0.0, pick_duration)
	var progress = _picking_time / pick_duration
	_progress_bar.value = progress * 100
	
	return progress

func _pick_complete() -> void:
	_is_picking = false
	_sprite.visible = false
	
	if _player:
		var reward = _calc_reward()
		_player.give_reward(reward)
		
	get_parent().remove_child(self)

func _pick_cancel() -> void:
	_is_picking = false
	_sprite.visible = false
	_player = null
	
func _calc_reward() -> float:
	var diff = reward_approx / 2
	
	return randf_range(reward_approx - diff, reward_approx + diff)
