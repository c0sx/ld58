class_name MainSceneUI
extends Control

@onready var _message: Panel = $MessagePanel
@onready var _label: Label = $MessagePanel/Label
@onready var _timer: Label = $TimeLeft
@onready var _inventory: VBoxContainer = $Inventory

func _ready() -> void:
	_message.visible = false

func render_return_to_the_working_zone_message() -> void:
	_label.text = "Return to the working zone"
	_message.visible = true

func welcome_message() -> void:
	_label.text = "Get back to work"
	_message.visible = true

func render_interact_message() -> void:
	_label.text = "Press 'E'"
	_message.visible = true
	
func hide_message() -> void:
	_message.visible = false
	_label.text = ""

func update_quota_plan(quota_plan: Dictionary) -> void:
	for child in _inventory.get_children():
		_inventory.remove_child(child)
		
	for k in quota_plan:
		var item = quota_plan[k]
		var need = item["need"]
		var have = item["have"]
		
		var label = Label.new()
		label.text = k + ": " + str(have) + "/" + str(need)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.add_theme_font_size_override("font_size", 32)
		
		if need > 0 and have >= need:
			label.add_theme_color_override("font_color", Color(0, 1, 0, 1))
			
		_inventory.add_child(label)
	
func update_quota_timer(value: float) -> void:
	_timer.text = "Time Left: " + str(int(value))
