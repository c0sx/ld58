class_name Tube
extends Node3D

@export var spawn_radius: float = 0.5
@export var spawn_amount_min: int = 1
@export var spawn_amount_max: int = 2
@export var spawn_timer_min = 0.05
@export var spawn_timer_max = 0.2

@export var box_scene: PackedScene

@onready var _spawner: Node3D = $Spawner

signal tube_amount_increased(value: int, maximum: bool)

func spawn() -> void:
	var amount = randf_range(spawn_amount_min - 1, spawn_amount_max)

	for i in amount:
		var box = box_scene.instantiate()

		box.top_level = true
		box.position = _calc_spawn_position()

		add_child(box)
		var timeout = _get_spawn_timeout()
		await get_tree().create_timer(timeout).timeout

func get_amount_value() -> int:
	return spawn_amount_max

func increase_max_amount(value: int, limit: int) -> void:
	if spawn_amount_max + value <= limit:
		spawn_amount_max += value

		emit_signal("tube_amount_increased", value, spawn_amount_max >= limit)

func _calc_spawn_position() -> Vector3:
	var x = randf_range(_spawner.position.x - spawn_radius, _spawner.position.x + spawn_radius)
	var z = randf_range(_spawner.position.z - spawn_radius, _spawner.position.z + spawn_radius)

	return Vector3(x, _spawner.position.y, z)

func _get_spawn_timeout() -> float:
	return randf_range(spawn_timer_min, spawn_timer_max)
