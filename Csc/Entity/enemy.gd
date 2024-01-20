extends CharacterBody2D

var speed = 80

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_detected = false

var facing_right = true

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if player_detected == false:
		
		if $Right.is_colliding():
			speed = -80
		if $Left.is_colliding():
			speed = 80
	else:
		pass
	
	if $RayCast2D.is_colliding():
		pass
	else:
		_flip()
	
	velocity.x = speed
	move_and_slide()
	

func _anim():
	pass

func _flip():
	facing_right = !facing_right
	
	if facing_right:
		speed = 80
	else:
		speed = -80


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_detected = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_detected = false
