class_name Quota
extends Node3D

@export var quota_timer: float = 10.0
@export var quota_value: float = 200.0

@onready var _timer: Timer = $Timer
@onready var _total_timer: Timer = $QuotaTimer

var _current_time: float = 0.0

signal quota_changed
signal quota_timer_tick
signal quota_timer_completed

func _ready() -> void:
	_timer.timeout.connect(_on_tick)
	_total_timer.timeout.connect(_on_finish)
	
	_total_timer.wait_time = quota_timer	

func start() -> void:
	_current_time = 0.0
	
	_timer.start()
	_total_timer.start()
	
func next_quota() -> void:
	quota_value *= 1.5
	emit_signal("quota_changed", self)
	
func _on_tick() -> void:
	_current_time += 1
	emit_signal('quota_timer_tick', quota_timer - _current_time)

func _on_finish() -> void:
	_total_timer.stop()
	_timer.stop()
	_current_time = 0.0
	emit_signal('quota_timer_completed')
