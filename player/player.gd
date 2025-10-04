class_name Player
extends CharacterBody3D

@export_group("Player")
@export var player_speed: int = 10

@export_group("Mouse")
@export var mouse_sensitivity = 0.2

@onready var camera: Camera3D = $Camera3D

var _rotation: Vector3 = Vector3.ZERO
var _target_velocity: Vector3 = Vector3.ZERO
var _vertical_looking_limit: int = 60
var _interactable: Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
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
		
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event.is_action_pressed("interact"):
		print("interact")
		_interact()

func set_interactable(interactable: Node3D) -> void:
	_interactable = interactable

func _interact() -> void:
	if _interactable and "interact" in _interactable:
		_interactable.interact()
