extends Camera2D

var paused = true

@export var player: Player
var offset_right = Vector2(100,-25)
var offset_left = Vector2(-100,-25)
var offset_neutral = Vector2(0,-25)
var pos  :Vector2
func _process(delta):
	var tween = get_tree().create_tween()
	if player.velocity.x == 0:
		pos = player.global_position + offset_neutral
	elif player.velocity.x > 0:
		pos = player.global_position + offset_right
	else:
		pos = player.global_position + offset_left

	pos.y = clamp(pos.y,150,250)
	_tween(tween,pos)


	if Input.is_action_just_pressed("esc"):
		_pause()
	
func _tween(tween,pos):
	tween.tween_property(self,"global_position",pos,0.5).set_ease(Tween.EASE_IN)

func _pause():
	paused = !paused
	if paused:
		$CanvasLayer/Pause_Menu.hide()
		Engine.time_scale = 1
	elif !paused:
		$CanvasLayer/Pause_Menu.show()
		Engine.time_scale = 0
