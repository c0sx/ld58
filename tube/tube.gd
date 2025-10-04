class_name Tube
extends Node3D

@export var item_scene: PackedScene
@export var spawn_radius: float = 0.5
@export var items: Array[LootItemResource] = []

@onready var _spawner: Spawner = $Spawner

func _ready() -> void:
	_spawner.items = items

func spawn() -> void:
	var resouce = _spawner.spawn()
	var item = resouce.scene.instantiate()
	
	item.top_level = true
	item.position = _calc_spawn_position()

	add_child(item)

func _calc_spawn_position() -> Vector3:
	var x = randf_range(_spawner.position.x-spawn_radius, _spawner.position.x + spawn_radius)
	var z = randf_range(_spawner.position.z-spawn_radius, _spawner.position.z + spawn_radius)
	
	return Vector3(x, _spawner.position.y, z)
