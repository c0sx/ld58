class_name TubeButton
extends Node3D

@onready var _area3d: Area3D = $Area3D
@onready var _cursor: Sprite3D = $Cursor

func _ready() -> void:
	_area3d.body_entered.connect(_on_enter)
	_area3d.body_exited.connect(_on_exit)
	
	_cursor.visible = false
	
func interact() -> void:
	print("interact with button")

func _on_enter(body) -> void:
	_cursor.visible = true
	
func _on_exit(body) -> void:
	_cursor.visible = false
