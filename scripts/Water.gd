extends Node2D

class_name Water

onready var WaterPoly = $WaterPoly


func draw_water(points: Array, end_x: int):
	var screen_size = get_viewport_rect().size
	var bottom_left = Vector2(0, screen_size.y)
	var bottom_right = Vector2(end_x, screen_size.y)
	var poly_points = [bottom_left] + points + [bottom_right]

	WaterPoly.polygon = poly_points
