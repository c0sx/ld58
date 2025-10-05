class_name WorkingZone
extends Node3D

@export var radius: int = 50
@export var deadzone_timer = 10

@onready var _working_area: Area3D = $Area3D
@onready var _collision_area: CollisionShape3D = $Area3D/CollisionShape3D
@onready var _tick_timer: Timer = $TickTimer
@onready var _timer: Timer = $Timer

signal exit_working_zone(timeout: float)
signal enter_working_zone
signal exit_working_zone_tick(remaining: float)
signal exit_working_zone_exceeded

var _area_mesh: Node3D
var _current_time: float = 0.0

func _ready() -> void:
	_working_area.body_entered.connect(_on_enter)
	_working_area.body_exited.connect(_on_exit)
	
	_tick_timer.timeout.connect(_on_tick_timeout)
	_timer.timeout.connect(_on_timeout)
	
	_timer.wait_time = deadzone_timer
	
	_collision_area.scale = Vector3(radius, radius, radius)
	
func _on_enter(body) -> void:
	if not body is Player:
		return 
		
	if _area_mesh:
		remove_child(_area_mesh)
		_area_mesh = null
		
		emit_signal('enter_working_zone')
		
		_tick_timer.stop()
		_timer.stop()

func _on_exit(body) -> void:
	if not body is Player:
		return 
		
	var material = StandardMaterial3D.new()
	material.albedo_color = "#ff0000"
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	_area_mesh = CSGTorus3D.new()
	_area_mesh.inner_radius = radius / 2.0
	_area_mesh.outer_radius = radius / 2.0 + 0.05
	_area_mesh.material_override = material
	add_child(_area_mesh)
		
	emit_signal('exit_working_zone', deadzone_timer)
	
	_current_time = 0.0
	_tick_timer.start()
	_timer.start()

func _on_tick_timeout() -> void:
	_current_time += 1
	
	emit_signal("exit_working_zone_tick", deadzone_timer - _current_time)

func _on_timeout() -> void:
	_tick_timer.stop()
	_timer.stop()
	
	emit_signal("exit_working_zone_exceeded")
