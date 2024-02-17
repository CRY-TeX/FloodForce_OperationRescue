extends Node2D

const PLAYER_START_POS = Vector2(130, 546)
const CAMERA_START_POS = Vector2(512, 300)

const START_SPEED = 10.0
const MAX_SPEED = 25.0
const SPEED_MODIFIER = 5000.0

onready var Player = $Truck
onready var Camera = $Camera2D
onready var Ground = $Ground

var BrokenTreeScene = preload("res://scenes/BrokenTree.tscn")
var CarBrokenEngineScene = preload("res://scenes/CarBrokenEngine.tscn")
var CarBrokenWindshieldScene = preload("res://scenes/CarBrokenWindshield.tscn")
var FallenTreeScene = preload("res://scenes/FallenTree.tscn")
var LayingTreeScene = preload("res://scenes/LayingTree.tscn")

var speed: float
var distance: float
var screen_size: Vector2
var obstacle_scenes = [
	BrokenTreeScene,
	CarBrokenEngineScene,
	CarBrokenWindshieldScene,
	FallenTreeScene,
	LayingTreeScene
]
var obstacles = []


func _ready():
	screen_size = get_viewport_rect().size
	new_game()

func _physics_process(_delta):
	speed = START_SPEED + distance / SPEED_MODIFIER
	if speed > MAX_SPEED:
		speed = MAX_SPEED

	distance += speed

	Player.position.x += speed
	Camera.position.x += speed

	if Camera.position.x - Ground.position.x > screen_size.x * 1.5:
		Ground.position.x += screen_size.x

	if randi() % 100 == 0:
		generate_obstacles()

	remove_obstacles()


# Function to start a new game.
func new_game():
	distance = 0.0
	Player.position = PLAYER_START_POS
	Player.velocity = Vector2(0, 0)
	Camera.position = CAMERA_START_POS
	Ground.position = Vector2(0, 0)

func generate_obstacles():
	var obstacle = obstacle_scenes[randi() % obstacle_scenes.size()].instance()
	# obstacle.position = Vector2(screen_size.x + 100, Ground.position.y - 50)
	obstacle.position = calc_obstacle_spawn_position(obstacle)
	obstacles.append(obstacle)
	add_child(obstacle)

func calc_obstacle_spawn_position(obstacle: Area2D):
	var ground_collision_rect = Ground.get_node("Collider")
	var obstacle_height = obstacle.get_node("Sprite").texture.get_height()
	var obstacle_scale = obstacle.get_node("Sprite").scale
	var obstacle_x = screen_size.x + distance + 100
	var obstacle_y = ground_collision_rect.position.y - obstacle_height * obstacle_scale.y / 2
	return Vector2(obstacle_x, obstacle_y)


func remove_obstacles():
	for obstacle in obstacles:
		if obstacle.position.x < Camera.position.x - screen_size.x / 2:
			obstacle.queue_free()
			obstacles.erase(obstacle)
