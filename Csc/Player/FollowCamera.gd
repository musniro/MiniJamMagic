extends Camera2D

var paused = true

@export var player: Player
var offset_right = Vector2(100,-25)
var offset_left = Vector2(-100,-25)
var offset_neutral = Vector2(0,-25)

func _process(delta):
	var tween = get_tree().create_tween()
	if player.velocity.x == 0:
		tween.tween_property(self,"global_position",player.global_position + offset_neutral,1).set_ease(Tween.EASE_IN)
	elif player.velocity.x > 0:
		tween.tween_property(self,"global_position",player.global_position + offset_right,0.5).set_ease(Tween.EASE_IN)
	else:
		tween.tween_property(self,"global_position",player.global_position + offset_left,0.5).set_ease(Tween.EASE_IN)
	
	if Input.is_action_just_pressed("esc"):
		_pause()
	

func _pause():
	paused = !paused
	if paused:
		$CanvasLayer/Pause_Menu.hide()
		Engine.time_scale = 1
	elif !paused:
		$CanvasLayer/Pause_Menu.show()
		Engine.time_scale = 0
