extends Node2D

var Person = preload("res://scenes/Person.tscn")

onready var Camera = $Camera2D
onready var LifeBoat = $LifeBoat
onready var Water = $Water
onready var Hospital = $Hospital
onready var TruckHUD = $TruckHUD
onready var RainParticles = $RainParticles
onready var FallingPersonPlayer = $FallingPersonPlayer

const MIN_WATER_LEVEL = 480.0
const MAX_WATER_LEVEL = 350.0
const LEVEL_LENGTH = 1024.0 * 8.0
const LIFEBOAT_SPEED = 200.0
const ROTATION_MODIFIER = 0.08
const MAX_ROTATION = 1.0
const FALL_OFF_ROTATION = 0.7

var points: Array = []
var current_point: int = 0
var falling_persons: Array = []
var last_fall_off_time: float = 0

func create_water_points(start_point: Vector2, end_point: Vector2, n: int):
	var step = (end_point.x - start_point.x) / (n + 1)
	var points = [start_point]
	
	for i in range(n):
		var x = start_point.x + step * (i + 1)
		var y = rand_range(MIN_WATER_LEVEL, MAX_WATER_LEVEL)
		points.append(Vector2(x, y))
	
	return points

func create_curve_between_points(points: Array, n: int):
	var curve_points = []
	
	for i in range(points.size() - 1):
		var p0 = points[i]
		var p1 = points[i + 1]
		var step = (p1.x - p0.x) / (n + 1)
		
		for j in range(n):
			var x = p0.x + step * (j + 1)
			var y = p0.y + (p1.y - p0.y) * (x - p0.x) / (p1.x - p0.x)
			curve_points.append(Vector2(x, y))
	
	return curve_points



func _ready():
	var start_point = Vector2(0, MIN_WATER_LEVEL)
	var end_point = Vector2(LEVEL_LENGTH, MIN_WATER_LEVEL)
	points = create_water_points(start_point, end_point, LEVEL_LENGTH / 256)
	points = create_curve_between_points(points, 12)
	points = [Vector2(0, points[0].y)] + points + [Vector2(LEVEL_LENGTH, points[points.size() - 1].y)]
	Water.draw_water(points, points[points.size() - 1].x)
	Hospital.position.x = LEVEL_LENGTH - Hospital.get_node("Sprite").texture.get_width()
	Hospital.connect("body_entered", self, "_on_Hospital_body_entered")
	TruckHUD.get_node("Score").text = str(Globals.persons_rescued)

func _process(delta):
	move_lifeboat(delta)
	rotation_input()
	rotate_lifeboat_on_wave()
	person_fall_off()
	move_and_free_falling_persons(delta)

func person_fall_off():
	if LifeBoat.rotation > FALL_OFF_ROTATION or LifeBoat.rotation < -FALL_OFF_ROTATION:
		if OS.get_ticks_msec() - last_fall_off_time > 1000:
			var person_instance = Person.instance()
			last_fall_off_time = OS.get_ticks_msec()
			person_instance.scale = Vector2(0.5, 0.5)
			person_instance.position = LifeBoat.position
			falling_persons.append(person_instance)
			add_child(person_instance)

			Globals.persons_rescued -= 1
			FallingPersonPlayer.play()
			TruckHUD.get_node("Score").text = str(Globals.persons_rescued)


	if Globals.persons_rescued < 0:
		Globals.persons_rescued = 0
		var status = get_tree().change_scene("res://scenes/GameOver.tscn")

		if status != OK:
			print("Error changing scene. Status: ", status)

func move_and_free_falling_persons(delta):
	var falling_person_indexes = []
	for i in range(falling_persons.size()):
		var person = falling_persons[i]
		person.position.y += 100 * delta
		person.rotation += 0.3
		if person.position.y > 800:
			falling_person_indexes.append(i)
			person.queue_free()

	for i in falling_person_indexes:
		falling_persons.remove(i)


func get_angle(p0: Vector2, p1: Vector2):
	return atan2(p1.y - p0.y, p1.x - p0.x)

func rotation_input():
	if Input.is_action_pressed("ui_right"):
		var new_roation = LifeBoat.rotation + ROTATION_MODIFIER
		if new_roation >= MAX_ROTATION:
			new_roation = LifeBoat.rotation
		LifeBoat.rotation = new_roation
	elif Input.is_action_pressed("ui_left"):
		var new_roation = LifeBoat.rotation - ROTATION_MODIFIER
		if new_roation <= -MAX_ROTATION:
			new_roation = LifeBoat.rotation
		LifeBoat.rotation = new_roation

func rotate_lifeboat_on_wave():
	if current_point < points.size() - 1:
		var angle = get_angle(points[current_point], points[current_point + 1])
		var new_roation = LifeBoat.rotation + angle / 10
		if new_roation >= MAX_ROTATION or new_roation <= -MAX_ROTATION:
			new_roation = LifeBoat.rotation
		
		LifeBoat.rotation = new_roation

func move_lifeboat(delta):
	Camera.position.x += LIFEBOAT_SPEED * delta
	LifeBoat.position.x += LIFEBOAT_SPEED * delta
	RainParticles.position.x += LIFEBOAT_SPEED * delta

	# set the height of the boat to the water level
	if LifeBoat.position.x > points[current_point].x:
		current_point += 1
		if current_point >= points.size():
			current_point = points.size() - 1
			return
		LifeBoat.position.y = points[current_point].y


func _on_Hospital_body_entered(_body):
	SoundPlayer.play_reach_hospital()
	var status = get_tree().change_scene("res://scenes/WinScreen.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)
