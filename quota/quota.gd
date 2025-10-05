class_name Quota
extends Node3D

@export var quota_timer: float = 10.0
@export var items: Array[LootItemResource] = []
@export var start_quota_items = 3

@onready var _timer: Timer = $Timer
@onready var _total_timer: Timer = $QuotaTimer

var _current_time: float = 0.0
var _current_quota: Dictionary

signal quota_started(quota: Dictionary, time: float)
signal quota_timer_tick
signal quota_finished

func _ready() -> void:
	_timer.timeout.connect(_on_tick)
	_total_timer.timeout.connect(_on_finish)
	
	_total_timer.wait_time = quota_timer

func start() -> void:
	_current_time = 0.0
	_current_quota = _make_quota()
	
	_timer.start()
	_total_timer.start()
	
	emit_signal('quota_started', _current_quota, quota_timer)
	
func get_current_quota() -> Dictionary:
	return _current_quota
	
func check_quota(player: Player) -> bool:
	for k in _current_quota:
		var value = _current_quota[k]
		
		if not player.has_engough(k, value):
			return false
	
	return true
	
func _on_tick() -> void:
	_current_time += 1
	
	emit_signal('quota_timer_tick', quota_timer - _current_time)

func _on_finish() -> void:
	_total_timer.stop()
	_timer.stop()
	_current_time = 0.0
	start_quota_items += 1
	
	emit_signal('quota_finished')

func _make_quota() -> Dictionary:
	randomize()
	
	var weights: Array[float] = []
	var sum: float = 0.0
	
	for item in items:
		var value = 1.0 / item.rarity
		weights.append(value)
		
		sum += value
	
	for i in weights.size():
		weights[i] /= sum
		
	var quota: Dictionary = {}
	for k in start_quota_items:
		var r := randf()
		var acc := 0.0
		
		for i in items.size():
			acc += weights[i]
			if r <= acc:
				var value = quota.get(items[i].name, 0)
				quota[items[i].name] = value + 1
				break
	
	return quota
