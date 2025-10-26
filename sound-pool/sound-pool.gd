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

	player.stream = stream;
	player.pitch_scale = pitch_scale

	player.play()
	_sounds.append(player)
	player.finished.connect(func():
		_sounds.erase(player)
	)
