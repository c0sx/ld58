class_name IncreaseAreaLootUpgrade
extends LootUpgrade

@export var min_range = 0.05
@export var max_range = 0.2
@export var limit = 6
@export var step = 0.05
@export var score = 50

func apply(_item: LootItem, player: Player, _quota: Quota, _tube: Tube) -> void:
	var area: Vector3 = player.get_picking_area()
	var size = area.length() / sqrt(3)

	var value = randf_range(min_range, max_range)
	value = clamp(value, min_range, max_range)
	value = round(value / step) * step

	if size + value < limit:
		print("1 Increasing picking area by ", value)
		player.increase_picking_area(value, limit)
		return

	var diff = (size + value) - limit
	value -= diff
	value = clamp(value, 0, step)
	value = round(value / step) * step

	if value > 0:
		print("2 Increasing picking area by ", value)
		player.increase_picking_area(value, limit)
	else:
		print("3 loot area score: ", score)
		player.add_score(score)
