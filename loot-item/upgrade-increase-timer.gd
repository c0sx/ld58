class_name IncreaseTimerLootUpgrade
extends LootUpgrade

@export var value = 1
@export var limit = 50
@export var score = 50

func apply(_item: LootItem, player: Player, quota: Quota, _tube: Tube) -> void:
	var current = quota.get_quota_timer()
	
	if current + value <= limit:
		quota.increase_timer(value, limit)
		return
		
	player.add_score(score)
