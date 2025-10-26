class_name LootItem
extends Resource

@export var name: String
@export var rarity: int
@export var in_quota: bool
@export var is_negative_item: bool
@export var emission: float = 1
@export var effects: Array[LootEffect]

func on_loot(player: Player, quota: Quota, tube: Tube) -> void:
	for effect in effects:
		effect.apply(self, player, quota, tube)
