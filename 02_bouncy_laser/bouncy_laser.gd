@tool
extends Node2D

@export var start: Vector2:
	get:
		return start
	set(value):
		start = value
		queue_redraw()

@export var target: Vector2:
	get:
		return target
	set(value):
		target = value
		queue_redraw()

@export_range(0, 50, 1) var bounce_limit: int = 1:
	get:
		return bounce_limit
	set(value):
		bounce_limit = value
		queue_redraw()

@onready var laser_start: Node2D = $LaserStart
@onready var laser_target: Node2D = $LaserTarget


func _ready() -> void:
	laser_start.updated.connect(_laser_start_updated)
	laser_target.updated.connect(_laser_target_updated)


func _draw() -> void:
	var remaining_bounces: int = bounce_limit
	var start_from: Vector2 = start
	var laser_dir: Vector2 = (target - start_from).normalized()
	var space_state = get_world_2d().direct_space_state
	# Draws the direction of the laser, ignoring collsions.
	#draw_line(start_from, start_from + laser_dir * 1000, Color.BLUE, 1)
	while remaining_bounces >= 0:
		var scaled_target: Vector2 = start_from + laser_dir * 1000
		var query = PhysicsRayQueryParameters2D.create(start_from, scaled_target)
		query.collide_with_areas = true
		var result: Dictionary = space_state.intersect_ray(query)
		draw_circle(start_from, 10, Color.RED)
		if result.is_empty():
			# If no collisions are found, stop.
			draw_line(start_from, scaled_target, Color.RED, 5)
			break
		else:
			# Correct collision point by subtracting normal, otherwise it might end up
			# inside the collider, which will hamper any subsequent collision checks.
			var result_pos: Vector2 = result.position - result.normal
			draw_line(start_from, result_pos, Color.RED, 5)
			start_from = result_pos
			# These two lines should be the equivalent to calling the bounce
			# function on laser_dir.
			var dot_product: float = laser_dir.x * result.normal.x + laser_dir.y * result.normal.y
			laser_dir = (laser_dir - result.normal * dot_product * 2).normalized()
		remaining_bounces -= 1


func _laser_start_updated() -> void:
	start = laser_start.position


func _laser_target_updated() -> void:
	target = laser_target.position
