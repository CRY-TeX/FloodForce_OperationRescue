extends Control

func _ready():
	SoundPlayer.play_piano_theme()

func _on_HowToPlay_pressed():
	var status = get_tree().change_scene("res://scenes/HowToPlay.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)


func _on_Play_pressed():
	SoundPlayer.stop_piano_theme()
	var status = get_tree().change_scene("res://scenes/TruckLevel.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)

func _on_Quit_pressed():
	get_tree().quit()
