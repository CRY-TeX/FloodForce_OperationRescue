extends KinematicBody2D

class_name Truck

onready var JumpSoundPlayer = $JumpSoundPlayer

const GRAVITY = 4200
const JUMP_FORCE = -1000

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += GRAVITY * delta

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_FORCE
			JumpSoundPlayer.play()

	velocity = move_and_slide(velocity, Vector2.UP)
