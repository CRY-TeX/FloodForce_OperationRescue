extends Button


func _on_HowToPlay_pressed():
	var status = get_tree().change_scene("res://scenes/HowToPlay.tscn")

	if status != OK:
		print("Error changing scene. Status: ", status)
