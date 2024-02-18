extends Node2D

onready var Camera = $Camera2D
onready var LifeBoat = $LifeBoat
onready var Water = $Water

const MIN_WATER_LEVEL = 480
const MAX_WATER_LEVEL = 350
const LEVEL_LENGTH = 1024.0 * 2

var points: Array = []
var current_point: int = 0

func _ready():
	# for i in range(0, LEVEL_LENGTH, 80):
	# 	var t = i / LEVEL_LENGTH
	# 	var p0 = Vector2(i, rand_range(MIN_WATER_LEVEL, MAX_WATER_LEVEL))
	# 	var p1 = Vector2(i + 512, rand_range(MIN_WATER_LEVEL, MAX_WATER_LEVEL))
	# 	var p2 = Vector2(i + 1024, rand_range(MIN_WATER_LEVEL, MAX_WATER_LEVEL))
	# 	points.append(bezier(t, p0, p1, p2))

	# print(points.size())

	# Water.draw_water(points, points[points.size() - 1].x)

func _process(delta):
	pass
	# var target_point = points[current_point]
	# var direction = (target_point - LifeBoat.position).normalized()
	# var velocity = direction * 150 * delta

	# LifeBoat.position += velocity
	# Camera.position.x += velocity.x

	# if LifeBoat.position.distance_to(target_point) < 1:
	#     current_point += 1
	#     if current_point >= points.size():
	#         current_point = 0
		

	
