class_name IncreaseMaxAmountLootUpgrade
extends LootUpgrade

@export var value = 1
@export var limit = 7
@export var score = 50

func apply(_item: LootItem, player: Player, _quota: Quota, tube: Tube) -> void:
		var current = tube.get_amount_value();

		if current + value <= limit:
			tube.increase_max_amount(value, limit)
			return

		player.add_score(score)
