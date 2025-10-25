extends Node

@export var max_sounds: int = 4
@export var bus: AudioBusLayout

var _sounds = []

func play(player: AudioStreamPlayer3D, stream: AudioStream, pitch_scale: float) -> void:
	_sounds = _sounds.filter(func(s):
		return is_instance_valid(s) and s.playing
	)
	
	if _sounds.size() >= max_sounds:
		var oldest = _sounds[0]
		oldest.stop()
		_sounds.erase(oldest)
		return
		
	player.stream = stream;
	player.pitch_scale = pitch_scale
	
	var delay = randf_range(0.0, 0.1)
	await get_tree().create_timer(delay).timeout
	player.play()
	
	_sounds.append(player)
