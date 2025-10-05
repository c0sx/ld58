class_name Spawner
extends Node3D

@export var items: Array[LootItemResource] = []

func spawn() -> LootItemResource:
	var weights = []
	
	for item in items:
		var weight = 1.0 / (item.rarity + 1)
		weights.append(weight)
		
	var total = weights.reduce(func(a, b):
		return a + b
	)
	
	var r = randf_range(0.0, total)
	var acc := 0.0
	
	for i in items.size():
		acc += weights[i]
		
		if r <= acc:
			return items[i]
	
	return items.back()
