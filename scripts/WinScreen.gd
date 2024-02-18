extends Control

func _ready():
	$TitleContainer/WinTitle.text = "Congratulations!\nYou Saved " + str(Globals.persons_rescued) + (" Person" if Globals.persons_rescued == 1 else " People") + "!"
	SoundPlayer.stop_rain()

func _on_PlayAgain_pressed():
	var status = get_tree().change_scene("res://scenes/TruckLevel.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)


func _on_MainMenu_pressed():
	var status = get_tree().change_scene("res://scenes/MainMenu.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)


