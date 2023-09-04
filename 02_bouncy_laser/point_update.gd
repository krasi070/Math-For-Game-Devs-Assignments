@tool
extends Node2D

signal updated

@export var follow_mouse: bool = false
@export var follow_mouse_click: bool = false

var _last_pos: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and follow_mouse_click:
		position = get_global_mouse_position()
		_check_for_update()


func _physics_process(delta: float) -> void:
	if not follow_mouse:
		return
	position = get_global_mouse_position()
	_check_for_update()


func _check_for_update() -> void:
	if _last_pos == position:
		return
	_last_pos = position
	updated.emit() 
