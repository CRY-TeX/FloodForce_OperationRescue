extends Node2D

onready var Camera = $Camera2D
onready var LifeBoat = $LifeBoat
onready var Water = $Water

const MIN_WATER_LEVEL = 480
const MAX_WATER_LEVEL = 350
const LEVEL_LENGTH = 1024.0 * 2

var points: Array = []
var current_point: int = 0

func create_sin_curve(start_point: Vector2, end_point: Vector2):
	var amplitude = rand_range(50, 100)
	var frequency = rand_range(0.005, 0.01)
	var points = []
	for i in range(0, LEVEL_LENGTH):
		amplitude = rand_range(50, 100)
		var x = lerp(start_point.x, end_point.x, i / LEVEL_LENGTH)
		var y = sin(x * frequency) * amplitude
		points.append(Vector2(x, y))
	return points


func _ready():
	var start_point = Vector2(0, MIN_WATER_LEVEL)
	var end_point = Vector2(LEVEL_LENGTH, MIN_WATER_LEVEL)
	points = create_sin_curve(start_point, end_point)
	Water.draw_water(points, points[points.size() - 1].x)
