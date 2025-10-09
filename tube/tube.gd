class_name Tube
extends Node3D

@export var spawn_radius: float = 0.5
@export var spawn_amount_min: int = 1
@export var spawn_amount_max: int = 2

@export var box_scene: PackedScene
@export var items: Array[LootItemResource] = []

@onready var _spawner: Spawner = $Spawner

signal tube_amount_increased(value: int)

func _ready() -> void:
	_spawner.items = items

func spawn() -> void:
	var amount = randf_range(spawn_amount_min, spawn_amount_max)
	
	for i in amount:
		var item = _spawner.spawn()
		var box = box_scene.instantiate()
		box.add_item(item)
		
		box.top_level = true
		box.position = _calc_spawn_position()

		add_child(box)
		await get_tree().create_timer(0.1).timeout

func increase_amount_value(value: int) -> void:
	spawn_amount_max += value
	
	emit_signal("tube_amount_increased", value)

func _calc_spawn_position() -> Vector3:
	var x = randf_range(_spawner.position.x-spawn_radius, _spawner.position.x + spawn_radius)
	var z = randf_range(_spawner.position.z-spawn_radius, _spawner.position.z + spawn_radius)
	
	return Vector3(x, _spawner.position.y, z)
