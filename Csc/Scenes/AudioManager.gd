extends Node2D

@onready var death : AudioStreamPlayer = $Death
@onready var music : AudioStreamPlayer = $Music
@onready var won : AudioStreamPlayer = $Won


func _death():
	death.play()
	music.stop()


func _on_player_won():
	won.play()
	music.stop()
	
