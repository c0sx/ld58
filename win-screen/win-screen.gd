class_name WinScreen
extends Control

@onready var _score: Label = $Panel/MarginContainer/HBoxContainer/Center/VBoxContainer/Score
@onready var _upgrades: VBoxContainer = $Panel/MarginContainer/HBoxContainer/Left/CenterContainer/Upgrades
@onready var _items: VBoxContainer = $Panel/MarginContainer/HBoxContainer/Right/CenterContainer/Items
@onready var _restart_button: Button = $Panel/MarginContainer/HBoxContainer/Center/CenterContainer/RestartButton

func _ready() -> void:
	_restart_button.pressed.connect(_on_restart_pressed)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide()

func render(score: int, upgrades: Dictionary, items: Dictionary) -> void:
	_score.text = "Score: " + str(score) + "\n"
	
	get_tree().paused = true
	_update_upgrades(upgrades)
	_update_items(items)
	show()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _update_upgrades(upgrades: Dictionary) -> void:
	for child in _upgrades.get_children():
		_upgrades.remove_child(child)
		
	for key in upgrades:
		var value = upgrades[key]
		
		var label = Label.new()
		label.text = key + ": " + value["str"]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
		label.label_settings = preload("res://assets/label.tres")
		
		_upgrades.add_child(label)

func _update_items(items: Dictionary) -> void:
	for child in _items.get_children():
		_items.remove_child(child)
		
	for key in items:
		var value = items[key]
		
		var label = Label.new()
		label.text = key + ": " + str(value)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		
		label.label_settings = preload("res://assets/label.tres")
		
		_items.add_child(label)
