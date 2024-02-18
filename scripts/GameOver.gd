extends Control

func _ready():
	SoundPlayer.stop_rain()
	SoundPlayer.play_game_over()

func _on_PlayAgain_pressed():
	var status = get_tree().change_scene("res://scenes/TruckLevel.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)


func _on_MainMenu_pressed():
	var status = get_tree().change_scene("res://scenes/MainMenu.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)

