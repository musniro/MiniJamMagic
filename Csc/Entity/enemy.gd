extends CharacterBody2D

var speed = 80

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player_detected = false

var facing_right = true

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if $RayCast2D.is_colliding():
		pass
	else:
		_flip()
	
	if facing_right:
		speed = 80
		$RayCast2D.position.x = 15
		$Sprite2D.flip_h = false
	else:
		speed = -80
		$RayCast2D.position.x = -15
		$Sprite2D.flip_h = true
	
	velocity.x = speed
	move_and_slide()
	
	if player_detected:
		pass
	
	

func _anim():
	pass

func _flip():
	facing_right = !facing_right
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_detected = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_detected = false
