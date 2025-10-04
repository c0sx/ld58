class_name WorkingZone
extends Node3D

@export var radius: int = 50

@onready var working_area: Area3D = $Area3D
@onready var collision_area: CollisionShape3D = $Area3D/CollisionShape3D

signal exit_working_zone
signal enter_working_zone

var area_mesh: Node3D

func _ready() -> void:
	working_area.body_entered.connect(_on_enter)
	working_area.body_exited.connect(_on_exit)
	
	collision_area.scale = Vector3(radius, radius, radius)
	
func _on_enter(body) -> void:
	if not body is Player:
		return 
		
	if area_mesh:
		remove_child(area_mesh)
		area_mesh = null
		
		emit_signal('enter_working_zone')

func _on_exit(body) -> void:
	if not body is Player:
		return 
		
	var material = StandardMaterial3D.new()
	material.albedo_color = "#ff0000"
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	area_mesh = CSGTorus3D.new()
	area_mesh.inner_radius = radius / 2.0
	area_mesh.outer_radius = radius / 2.0 + 0.05
	area_mesh.material_override = material
	add_child(area_mesh)
		
	emit_signal('exit_working_zone')
