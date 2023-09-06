@tool
extends Node2D

@export_range(1.0, 1000.0, 1.0) var radial_radius: float = 200.0:
	get:
		return radial_radius
	set(value):
		radial_radius = value
		queue_redraw()

@export_color_no_alpha var inside_radial_color: Color = Color.RED:
	get:
		return inside_radial_color
	set(value):
		inside_radial_color = value
		_update_character_color()

@export_color_no_alpha var outside_radial_color: Color = Color.GREEN:
	get:
		return outside_radial_color
	set(value):
		outside_radial_color = value
		_update_character_color()

@onready var radial_center: Sprite2D = $RadialCenter
@onready var character: Sprite2D = $Character


func _ready() -> void:
	queue_redraw()
	_update_character_color()


func _physics_process(delta: float) -> void:
	character.position = get_global_mouse_position()
	_update_character_color()


func _draw() -> void:
	draw_circle(radial_center.position, radial_radius, Color.YELLOW)


func _update_character_color() -> void:
	var diff_vector: Vector2 = radial_center.position - character.position
	# This is the same as using the distance_squared_to function.
	var sq_distance: float = diff_vector.x * diff_vector.x + diff_vector.y * diff_vector.y
	# Faster to compare squared values than calculating the square root.
	if sq_distance <= radial_radius * radial_radius:
		character.self_modulate = inside_radial_color
	else:
		character.self_modulate = outside_radial_color
