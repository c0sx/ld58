class_name Quota
extends Node3D

@export var quota_timer: float = 10.0
@export var items: Array[LootItemResource] = []
@export var start_quota_items = 3

@onready var _timer: Timer = $Timer
@onready var _total_timer: Timer = $QuotaTimer

var _current_time: float = 0.0
var _current_quota: Dictionary
var _round: int = 0
var _difficulty: int = 0

signal quota_started(quota: Dictionary, time: float)
signal quota_timer_tick
signal quota_finished
signal quota_timer_increased(value: int)

func _ready() -> void:
	_timer.timeout.connect(_on_tick)
	_total_timer.timeout.connect(_on_finish)

func start() -> void:
	_total_timer.wait_time = quota_timer

	_round += 1
	_current_time = 0.0

	if _round > 1 and (_round - 1) % 3 == 0:
		_difficulty += 3
		start_quota_items += _difficulty

	_current_quota = _make_quota()

	_timer.start()
	_total_timer.start()

	emit_signal('quota_started', _current_quota, quota_timer, _difficulty)

func get_current_quota() -> Dictionary:
	return _current_quota

func check_quota(player: Player) -> bool:
	for k in _current_quota:
		var value = _current_quota[k]

		if not player.has_engough(k, value):
			return false

	return true

func increase_timer(value: int) -> void:
	quota_timer += value

	emit_signal("quota_timer_increased", value)

func _on_tick() -> void:
	_current_time += 1

	emit_signal('quota_timer_tick', quota_timer - _current_time)

func _on_finish() -> void:
	_total_timer.stop()
	_timer.stop()
	_current_time = 0.0

	var amount = randi_range(1, 2)
	start_quota_items += amount

	emit_signal('quota_finished')

func _make_quota() -> Dictionary:
	var weights: Array[float] = []

	for item in items:
		var value = 1.0 / item.rarity
		weights.append(value)

	var sum_valuable: float = 0.0
	for i in items.size():
		if items[i].in_quota:
			sum_valuable += weights[i]

	var fractional := []
	for i in items.size():
		if items[i].in_quota:
			var pi_cond := weights[i] / sum_valuable
			fractional.append({"i": i, "value": start_quota_items * pi_cond})

	var quota: Dictionary = {}
	var remain: float = 0.0

	for e in fractional:
		var q := int(floor(e["value"]))
		var item_name = items[e["i"]].name

		quota[item_name] = q
		remain += e["value"] - q

	var need = int(round(remain))
	fractional.sort_custom(func(a, b):
		return a["value"] - int(floor(a["value"])) > b["value"] - int(floor(b["value"]))
	)

	for j in min(need, fractional.size()):
		var i = fractional[j]["i"]
		quota[items[i].name] += 1

	var result: Dictionary = {}
	for k in quota:
		var v = quota[k]
		if v == 0:
			continue

		result[k] = v

	return result
