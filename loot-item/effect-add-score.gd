class_name AddScoreLootEffect
extends LootEffect

@export var score: int = 0

func apply(_item: LootItem, player: Player, _quota: Quota, _tube: Tube) -> void:
	player.add_score(score)
