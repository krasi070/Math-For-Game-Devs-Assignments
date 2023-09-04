extends Node2D

@onready var grandparent: Sprite2D = $Grandparent
@onready var child3: Sprite2D = $Grandparent/Parent2/Child3


func _ready() -> void:
	_print_local_positions(self, child3)


func _print_local_positions(node: Node2D, locale: Node2D) -> void:
	for child in node.get_children():
		var position_data: Dictionary = {
			"world": child.global_position,
			"local": _to_local_position(child, locale),
		}
		print(child.name, " ", position_data)
		_print_local_positions(child, locale)


func _to_local_position(node: Node2D, locale: Node2D) -> Vector2:
	return node.global_position - locale.global_position
