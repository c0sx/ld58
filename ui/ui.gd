class_name MainSceneUI
extends Control

@onready var message: Panel = $MessagePanel
@onready var label: Label = $MessagePanel/Label

func _ready() -> void:
	message.visible = false

func render_return_to_the_working_zone_message() -> void:
	label.text = "Return to the working zone"
	message.visible = true
	
func hide_return_to_the_working_zone_message() -> void:
	label.text = ""
	message.visible = false
