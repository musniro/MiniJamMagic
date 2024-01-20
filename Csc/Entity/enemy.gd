extends CharacterBody2D

var speed = 80

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_node("/root/world/Player")
var player_detected = false

var facing_right = true

func _ready():
	var detection_area = $Area2D

func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if $RayCast2D.is_colliding():
		pass
	else:
		_flip()
	
	if player_detected:
		var direction : Vector2 = (global_position - player.global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		set_collision_mask(2)
		set_collision_layer(2)
	
	
	if !player_detected:
		
		if $Left.is_colliding():
			facing_right = !facing_right
		if $Right.is_colliding():
			facing_right = !facing_right
		
		
		if facing_right:
			speed = 80
			$RayCast2D.position.x = 15
			$Sprite2D.flip_h = false
		else:
			speed = -80
			$RayCast2D.position.x = -15
			$Sprite2D.flip_h = true
		
	if !player_detected:
		velocity.x = speed
		move_and_slide()
	

func _anim():
	pass

func _flip():
	facing_right = !facing_right
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_detected = true
	

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_detected = false
		set_collision_mask(1)
		set_collision_layer(1)


func _on_attack_box_body_entered(body):
	if body.is_in_group("Player"):
		if player.has_method("_hit"):
			player._hit()
			queue_free()
