class_name LootItemResource
extends Resource

@export var name: String
@export var rarity: int
@export var score: int
@export var color: Color
@export var in_quota: bool

@export var increase_timer_value: int = 0
@export var increase_picking_area_value: float = 0.0
@export var reduce_picking_duration_value: float = 0.0
@export var increase_amount_value: int = 0

func handle_collected(player: Player, quota: Quota, tube: Tube) -> void:
	if in_quota:
		player.add_item_into_inventory(self)
	
	var upgrades := []
	if increase_timer_value > 0:
		upgrades.append({ "fn": quota.increase_timer, "value": increase_timer_value })
		
	if increase_picking_area_value > 0.0:
		upgrades.append({ "fn": player.increase_picking_area, "value": increase_picking_area_value })
	
	if reduce_picking_duration_value > 0:
		upgrades.append({ "fn": player.reduce_picking_duration, "value": reduce_picking_duration_value })
	
	if increase_amount_value > 0:
		upgrades.append({ "fn": tube.increase_amount_value, "value": increase_amount_value })
	
	if upgrades.size() > 0:
		var upgrade = upgrades.pick_random()
		
		upgrade["fn"].call(upgrade["value"])
