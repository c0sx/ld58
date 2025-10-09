class_name LootBox
extends Node3D

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
var _player: Player
var _pick_duration: float = 1.5

func _ready() -> void:
	var mat = StandardMaterial3D.new()
	mat.emission_enabled = true
	mat.emission = _loot_item.color
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

func pick_start(player: Player) -> void:
	_player = player
	_is_picking = true
	_picking_time = 0.0
	
	_sprite.texture = _viewport.get_texture()
	_sprite.visible = true
	_pick_duration = player.player_pick_duration

func _pick_progress(delta: float) -> float:
	_picking_time = clamp(_picking_time + delta, 0.0, _pick_duration)
	var progress = _picking_time / _pick_duration
	_progress_bar.value = progress * 100
	
	return progress

func pick_cancel() -> void:
	_is_picking = false
	_sprite.visible = false
	_player = null

func _pick_complete() -> void:
	_is_picking = false
	_sprite.visible = false
	
	if _player:
		_player.collect_item(_loot_item)

		_play_pick_complete()
		await get_tree().create_timer(0.1).timeout

	get_parent().remove_child(self)

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
