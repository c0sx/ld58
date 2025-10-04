class_name MainSceneUI
extends Control

@onready var _message: Panel = $MessagePanel
@onready var _label: Label = $MessagePanel/Label
@onready var _money: Label = $Money
@onready var _quota: Label = $Quota
@onready var _timer: Label = $TimeLeft

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

func update_money_value(value: float) -> void:
	_money.text = "Money: " + str(int(value))

func update_quota_value(value: float) -> void:
	_quota.text = "Quota: " + str(int(value))

func update_quota_reached(value: bool) -> void:
	if value:
		_quota.add_theme_color_override("font_color", Color(0, 1, 0, 1))
	else:
		_quota.add_theme_color_override("font_color", Color(1, 0, 0, 1))
		
func update_quota_timer(value: float) -> void:
	_timer.text = "Time Left: " + str(int(value))
