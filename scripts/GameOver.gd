extends Control


func _on_PlayAgain_pressed():
	var status = get_tree().change_scene("res://scenes/TruckLevel.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)


func _on_MainMenu_pressed():
	var status = get_tree().change_scene("res://scenes/MainMenu.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)

