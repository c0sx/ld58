class_name AddToInventoryLootEffect
extends LootEffect

func apply(item: LootItem, player: Player, _quota: Quota, _tube: Tube) -> void:
	player.add_item_into_inventory(item)
	pass
