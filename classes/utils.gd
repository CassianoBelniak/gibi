class_name Utils
extends Node

static func stepify_vector(vector: Vector2, size: Vector2) -> Vector2:
	var x = floor(vector.x/size.x) * size.x
	var y = floor(vector.y/size.y) * size.y
	return Vector2(x,y)

static func choose(array: Array):
	if array.is_empty():
		return null
	return array[randi_range(0, array.size()-1)]

static func rangef(start: float, end: float, step: float) -> Array[float]:
	var res = Array()
	var i = start
	while i < end:
		res.push_back(i)
		i += step
	return res 

static func for_initialization(node: Node):
	if node.get_meta("ready", false):
		return
	await node.ready
	node.set_meta("ready", true)
	return 

static func chance(dice: float) -> bool:
	return randf_range(0,dice) > dice - 1
