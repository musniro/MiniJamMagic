extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var goal = get_global_mouse_position()
	
	var player_delta = (goal - get_parent().global_position)
	
	player_delta.x = clamp(player_delta.x,-100,100)
	player_delta.y = clamp(player_delta.y,-100,100)
	if player_delta.length() > 100:
		player_delta = player_delta.normalized() * 100
		
	self.global_position = get_parent().global_position + player_delta
	#var tween = get_tree().create_tween()
	
	#tween.tween_property(self,"global_position",get_global_mouse_position(),0.1)
	
