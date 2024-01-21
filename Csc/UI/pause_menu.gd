extends Control

@onready var paused = get_node("//root/World/Camera2D")

func _on_resume_pressed():
	if paused.has_method("_pause"):
		paused._pause()
	

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Csc/Scenes/menu.tscn")
