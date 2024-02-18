extends Node2D

const PLAYER_START_POS = Vector2(130, 546)
const CAMERA_START_POS = Vector2(512, 300)

const START_SPEED = 10.0
const MAX_SPEED = 35.0
const SPEED_MODIFIER = 5000.0

onready var Player = $Truck
onready var Camera = $Camera2D
onready var Ground = $Ground
onready var RainParticles = $RainParticles
onready var ObstacleSpawnTimer = $ObstacleSpawnTimer
onready var SpawnTimer = $SpawnTimer
onready var TruckHUD = $TruckHUD

var BrokenTreeScene = preload("res://scenes/BrokenTree.tscn")
var CarBrokenEngineScene = preload("res://scenes/CarBrokenEngine.tscn")
var CarBrokenWindshieldScene = preload("res://scenes/CarBrokenWindshield.tscn")
var FallenTreeScene = preload("res://scenes/FallenTree.tscn")
var LayingTreeScene = preload("res://scenes/LayingTree.tscn")
var Person = preload("res://scenes/Person.tscn")

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
var persons = []


func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	new_game()

func _physics_process(_delta):
	speed = START_SPEED + distance / SPEED_MODIFIER
	if speed > MAX_SPEED:
		speed = MAX_SPEED

	distance += speed

	Player.position.x += speed
	Camera.position.x += speed
	RainParticles.position.x += speed

	if Camera.position.x - Ground.position.x > screen_size.x * 1.5:
		Ground.position.x += screen_size.x

# Function to start a new game.
func new_game():
	Globals.persons_rescued = 0
	distance = 0.0
	Player.position = PLAYER_START_POS
	Player.velocity = Vector2(0, 0)
	Camera.position = CAMERA_START_POS
	Ground.position = Vector2(0, 0)
	RainParticles.position = Vector2(854, -49)
	TruckHUD.get_node("Score").text = str(0)

	for obstacle in obstacles:
		obstacle.queue_free()
	obstacles = []
	for person in persons:
		person.queue_free()
	persons = []

func generate_obstacles():
	var obstacle = obstacle_scenes[randi() % obstacle_scenes.size()].instance()
	obstacle.position = calc_obstacle_spawn_position(obstacle)
	obstacle.connect("body_entered", self, "_on_obstacle_body_entered")
	obstacles.append(obstacle)
	add_child(obstacle)

func calc_obstacle_spawn_position(obstacle: Area2D):
	var ground_collision_rect = Ground.get_node("Collider")
	var obstacle_height = obstacle.get_node("Sprite").texture.get_height()
	var obstacle_scale = obstacle.get_node("Sprite").scale
	var obstacle_x = screen_size.x + distance + 100
	var obstacle_y = ground_collision_rect.position.y - obstacle_height * obstacle_scale.y / 2 - 20
	return Vector2(obstacle_x, obstacle_y)


func remove_obstacles():
	for obstacle in obstacles:
		if obstacle.position.x < Camera.position.x - screen_size.x / 2 - 300:
			obstacle.queue_free()
			obstacles.erase(obstacle)

	for person in persons:
		if person.position.x < Camera.position.x - screen_size.x / 2 - 300:
			person.queue_free()
			persons.erase(person)

func _on_obstacle_body_entered(body: Node):
	if body is Truck:
		var next_scene = "res://scenes/GameOver.tscn"
		if Globals.persons_rescued > 0:
			next_scene = "res://scenes/WaterLevel.tscn"			

		var status = get_tree().change_scene(next_scene)

		if status != OK:
			print("Error changing scene. Status: ", status)


func _on_SpawnTimer_timeout():
	var person_spawned = false

	if randi() % 8 == 0:
		var person = Person.instance()
		person.position = calc_obstacle_spawn_position(person)
		person.connect("body_entered", self, "_on_person_body_entered", [person])
		persons.append(person)
		add_child(person)
		person_spawned = true

	if not person_spawned and randi() % 2 == 0:
		generate_obstacles()

	remove_obstacles()

func _on_person_body_entered(body: Node, person: Node):
	if not body is Truck: return

	Globals.persons_rescued += 1
	TruckHUD.get_node("Score").text = str(Globals.persons_rescued)
	var index = persons.find(person)
	if index != -1:
		persons.remove(index)
	person.queue_free()
