class_name MainSceneUI
extends Control

@onready var message: Panel = $MessagePanel
@onready var label: Label = $MessagePanel/Label

var _timer

func _ready() -> void:
	#message.visible = false
	pass

func render_return_to_the_working_zone_message() -> void:
	label.text = "Return to the working zone"
	message.visible = true

func welcome_message() -> void:
	label.text = "Get back to work"
	message.visible = true

func render_interact_message() -> void:
	label.text = "Press 'E'"
	message.visible = true
	
func hide_message() -> void:
	message.visible = false
	label.text = ""
