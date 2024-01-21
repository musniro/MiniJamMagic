extends CharacterBody2D

var speed = 80

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var player : Player

enum State {
	PATROL,
	CHASING,
	RETURNING
}
var state = State.PATROL

var player_detected = false

var facing_right = true
@onready var spawn_point := self.global_position
@onready var detection_area = $ChaseBox

func _ready():
	pass
	
func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	
	if $RayCast2D.is_colliding():
		pass
	else:
		_flip()
		
	match state:
		State.CHASING:
			_physics_process_chasing()
			return
		State.PATROL:
			_physics_process_patrol()
			return
		State.RETURNING:
			_physics_process_returning()
			return

func _physics_process_chasing():
		var direction : Vector2 = -(global_position - player.global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
	
func _physics_process_patrol():
	if $Left.is_colliding():
		facing_right = !facing_right
	if $Right.is_colliding():
		facing_right = !facing_right
	
	if facing_right:
		velocity.x = speed
		$RayCast2D.position.x = 15
		$Sprite2D.flip_h = false
	else:
		velocity.x = -speed
		$RayCast2D.position.x = -15
		$Sprite2D.flip_h = true
	
	move_and_slide()

func _physics_process_returning():
	var delta := -(global_position - spawn_point)
	if delta.length() < 10:
		global_position = spawn_point
		state = State.PATROL
		return
		
	var direction := delta.normalized()
	velocity = direction * speed
	move_and_slide()
	
	
func _anim():
	pass

func _flip():
	facing_right = !facing_right
	


func _on_chase_box_body_entered(body):
	if body.is_in_group("Player"):
		if state == State.PATROL:
			state = State.CHASING
		set_collision_mask(2)
		set_collision_layer(2)
	

func _on_return_box_body_exited(body):
	if body.is_in_group("Player"):
		if state == State.CHASING:
			state = State.RETURNING
		set_collision_mask(1)
		set_collision_layer(1)


func _on_attack_box_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("_hit"):
			body._hit()
			queue_free()


