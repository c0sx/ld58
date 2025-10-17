class_name LootBox
extends Node3D

@export var colors: Array[Color] = []
@export var loot_items: Array[LootItem] = []
@export var successful_sounds: Array[AudioStream] = []
@export var negative_sounds: Array[AudioStream] = []

@onready var _sprite: Sprite3D = $Sprite3D
@onready var _viewport: SubViewport = $SubViewport
@onready var _progress_bar: ProgressBar = $SubViewport/Control/ProgressBar
@onready var _mesh: MeshInstance3D = $MeshInstance3D
@onready var _audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var _loot_item: LootItem

var _is_picking = false
var _picking_time = 0.0
var _player: Player
var _pick_duration: float = 1.5

func _ready() -> void:
	_loot_item = _spawn()

	var active_material = _mesh.get_active_material(0)
	if active_material is StandardMaterial3D:
		var new_material: StandardMaterial3D = active_material.duplicate(true)
		new_material.resource_local_to_scene = true
		new_material.emission = _select_color()
		new_material.emission_energy_multiplier = _loot_item.emission
		_mesh.material_override = new_material

func _process(delta: float) -> void:
	if not _is_picking:
		return

	var progress = _pick_progress(delta)
	if progress >= 1:
		_pick_complete()

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
		_player.new_item_picked(_loot_item)

		await _play_pick_complete()
		await get_tree().create_timer(0.1).timeout

	get_parent().remove_child(self)

func _play_pick_complete() -> void:
	var sounds = successful_sounds
	if _loot_item.is_negative_item:
		sounds = negative_sounds

	if len(sounds) == 0:
		return

	var stream = sounds.pick_random()
	if not stream:
		return

	if not _audio_stream_player.is_playing():
		_audio_stream_player.stream = stream

		var pitch_variation = randf_range(-0.1, 0.1)
		_audio_stream_player.pitch_scale = 1.0 + pitch_variation

		var delay = randf_range(0.0, 0.1)
		await get_tree().create_timer(delay).timeout
		_audio_stream_player.play()

func _select_color() -> Color:
	var c = colors.pick_random()
	if c == null:
		return Color.WHITE

	return c

func _spawn() -> LootItem:
	var weights = []

	for item in loot_items:
		var weight = 1.0 / (item.rarity + 1)
		weights.append(weight)

	var total = weights.reduce(func(a, b):
		return a + b
	)

	var r = randf_range(0.0, total)
	var acc := 0.0

	for i in loot_items.size():
		acc += weights[i]

		if r <= acc:
			return loot_items[i]

	return loot_items.back()
