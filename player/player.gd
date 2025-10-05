class_name Player
extends CharacterBody3D

@export_group("Player")
@export var player_speed: int = 10
@export var player_pick_duration: float = 1.5

@export_group("Mouse")
@export var mouse_sensitivity = 0.2

@onready var camera: Camera3D = $Camera3D

signal inventory_changed(value: Dictionary)

var _rotation: Vector3 = Vector3.ZERO
var _vertical_looking_limit: int = 60
var _interactable: Node3D
var _inventory: Dictionary = {} # [string, int]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x * player_speed
	velocity.z = direction.z * player_speed

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotation.y -= event.relative.x * mouse_sensitivity * 0.01
		_rotation.x -= event.relative.y * mouse_sensitivity * 0.01
		_rotation.x = clamp(_rotation.x, deg_to_rad(-_vertical_looking_limit), deg_to_rad(_vertical_looking_limit))
		
		rotation.y = _rotation.y
		camera.rotation.x = _rotation.x
		
	if event.is_action_pressed("interact") and not event.is_echo():
		_interact()

func set_interactable(interactable: Node3D) -> void:
	_interactable = interactable
		
func collect_item(item: LootItemResource) -> void:
	var value = _inventory.get(item.name, 0)
	_inventory[item.name] = value + 1
	
	emit_signal("inventory_changed")

func build_plan(quota: Dictionary) -> Dictionary:
	var plan = {}
	
	for k in quota:
		var value = quota.get(k, 0)
		
		plan[k] = {
			"need": value,
			"have": 0,
		}
		
	for k in _inventory:
		var value = _inventory.get(k, 0)
		var item = plan.get(k)
		
		if not item:
			plan[k] = {
				"need": 0,
				"have": value
			}
		else:
			plan[k]["have"] = value
	
	return plan
	
func has_engough(item_name: String, need_value: int) -> bool:
	if not _inventory.has(item_name):
		return false
		
	var have_value = _inventory[item_name];
	
	return have_value >= need_value

func withdraw_items(items: Dictionary) -> void:
	for k in items:
		var value = items[k]
		var current_value = _inventory.get(k, 0)
		
		if current_value - value < 0:
			_inventory[k] = 0
		else:
			_inventory[k] = current_value - value

func _interact() -> void:
	if not _interactable:
		return
		
	if _interactable is TubeButton:
		_interactable.interact()
