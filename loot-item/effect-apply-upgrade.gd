class_name ApplyUpgradeLootEffect
extends LootEffect

@export var chance = 0.05
@export var upgrades: Array[LootUpgrade] = []

func apply(item: LootItem, player: Player, quota: Quota, tube: Tube) -> void:
	var roll = randf_range(0, 1)
	if roll > chance:
		return

	var upgrade = upgrades.pick_random()
	if upgrade:
		upgrade.apply(item, player, quota, tube)
