extends Button


func _on_Back_pressed():
    var status = get_tree().change_scene("res://scenes/MainMenu.tscn")
    
    if status != OK:
        print("Error changing scene. Status: ", status)
