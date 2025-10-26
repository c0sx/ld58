class_name IncreaseLootSpeedLootUpgrade
extends LootUpgrade

@export var min_range = 0.25
@export var max_range = 0.1
@export var limit = 0.2
@export var step = 0.025
@export var score = 50

func apply(_item: LootItem, player: Player, _quota: Quota, _tube: Tube) -> void:
	var current = player.get_picking_duration()

	var value = randf_range(min_range, max_range)
	value = clamp(value, min_range, max_range)
	value = round(value / step) * step

	if current - value >= limit:
		player.reduce_picking_duration(value, limit)
		return

	var diff = limit - (current - value)

	value -= diff
	value = clamp(value, 0, step)
	value = round(value / step) * step

	if value > 0:
		player.reduce_picking_duration(value, limit)
	else:
		player.add_score(score)
