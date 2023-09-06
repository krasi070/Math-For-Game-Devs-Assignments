extends Node2D


func _ready() -> void:
	_print_child_positions()


func _print_child_positions(node: Node2D = self, depth: int = 0) -> void:
	for child in node.get_children():
		var position_data: Dictionary = {
			"local": child.position,
			"world": _to_world_position(child),
			"global_position": child.global_position,
		}
		print("-".repeat(depth + 1), " ", child.name, " ", position_data)
		_print_child_positions(child, depth + 1)


func _to_world_position(node: Node2D) -> Vector2:
	if not node.get_parent() is Node2D:
		return node.position
	var parent_transform: Transform2D = node.get_parent().global_transform
	var parent_world_pos: Vector2 = _to_world_position(node.get_parent())
	return parent_world_pos + node.position.x * parent_transform.x + node.position.y * parent_transform.y
