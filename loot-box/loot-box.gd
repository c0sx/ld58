class_name LootBox
extends Node3D

@export var pick_duration: float = 1.5
@export var colors: Array[Color] = []

@onready var _picking_area: Area3D = $Area3D
@onready var _sprite: Sprite3D = $Sprite3D
@onready var _viewport: SubViewport = $SubViewport
@onready var _progress_bar: ProgressBar = $SubViewport/Control/ProgressBar
@onready var _mesh: MeshInstance3D = $MeshInstance3D
@onready var _audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var _sounds = [
	load('res://assets/sounds/pickup0.wav'),
	load('res://assets/sounds/pickup1.wav'),
	load('res://assets/sounds/pickup2.wav'),
	load('res://assets/sounds/pickup3.wav'),
	load('res://assets/sounds/pickup4.wav')
]

var _loot_item: LootItemResource
var _is_picking = false
var _picking_time = 0.0
var _player

func _ready() -> void:
	_picking_area.body_entered.connect(_on_enter)
	_picking_area.body_exited.connect(_on_exit)
	
	var color = _select_color()
	if color:
		var mat = StandardMaterial3D.new()
		mat.emission_enabled = true
		mat.emission = color
		mat.emission_energy_multiplier = 1.2
		_mesh.material_override = mat

func _process(delta: float) -> void:
	if not _is_picking:
		return
		
	var progress = _pick_progress(delta)
	if progress >= 1:
		_pick_complete()

func add_item(item: LootItemResource) -> void:
	_loot_item = item

func _on_enter(body) -> void:
	if not body is Player:
		return
	
	_player = body
	_pick_start()
		
func _on_exit(body) -> void:
	if not body is Player:
		return
		
	_pick_cancel()

func _pick_start() -> void:
	_is_picking = true
	_picking_time = 0.0
	
	_sprite.texture = _viewport.get_texture()
	_sprite.visible = true

func _pick_progress(delta: float) -> float:
	_picking_time = clamp(_picking_time + delta, 0.0, pick_duration)
	var progress = _picking_time / pick_duration
	_progress_bar.value = progress * 100
	
	return progress

func _pick_complete() -> void:
	_is_picking = false
	_sprite.visible = false
	
	if _player:
		if _loot_item.name != "trash":
			_player.collect_item(_loot_item)

		_play_pick_complete()
		await get_tree().create_timer(0.1).timeout

	get_parent().remove_child(self)

func _pick_cancel() -> void:
	_is_picking = false
	_sprite.visible = false
	_player = null

func _select_color() -> Color:
	if len(colors) == 0:
		return Color(1, 1, 1, 1)
		
	var idx = randi_range(0, len(colors) - 1)
	return colors[idx]

func _play_pick_complete() -> void:
	if len(_sounds) == 0:
		return
	
	var stream
	if _loot_item.name == "trash":
		stream = load('res://assets/sounds/pickup-boom.wav')
	else: 
		stream = _sounds.pick_random()
		
	if not _audio_stream_player.is_playing():
		_audio_stream_player.stream = stream
		_audio_stream_player.play()
