extends CharacterBody2D


@onready var timer_label = $Camera2D/Countdown
@onready var game_timer = $Death_Timer
var seconds_left : int = 120

var speed = 100
var jump = 250
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimationPlayer
@onready var walk_particles = $"Particles/Walk particles"

var alive = true
enum State { 
	IDLE,
	RUN,
	JUMP,
	FALL,
	DEAD
}
var state = State.IDLE
var is_running_right:
	get:
		return velocity.x > 0
		
func _ready():
	game_timer.start(1)
	$Sprite2D.modulate = -1

func _physics_process(delta):
	if alive == true:
		if not is_on_floor():
			velocity.y += gravity * delta
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y -= jump
		
		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		move_and_slide()
		
		_determine_state()
		_anim()
		_particles()
		
	timer_label.text = "Time: " + str(seconds_left) + "s"
	
func _determine_state():
	if not alive:
		self.state = State.DEAD
		return 
		
	if is_on_floor():
		if velocity.x > 0:
			self.state = State.RUN
		elif velocity.x <0:
			self.state = State.RUN
		else:
			self.state = State.IDLE
	
	if !is_on_floor():
		if velocity.y >0:
			self.state = State.FALL
		elif velocity.y <0:
			self.state = State.JUMP
	

func _anim():
	match state:
		State.IDLE:
			anim.play("Idle")
		State.RUN:
			anim.play("Run")
			$Sprite2D.flip_h = not is_running_right
		State.FALL:
			anim.play("fall")
		State.JUMP:
			anim.play("jump")
			
func _particles():
	walk_particles.emitting = state == State.RUN
	if is_running_right:
		$Particles.scale.x = 1
	else:
		$Particles.scale.x = -1
		

func _on_death_timer_timeout():
	seconds_left -= 1
	if seconds_left <= 0:
		game_timer.stop()
		alive = false
		anim.play("Hit")
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.show()
	else:
		game_timer.start(1)


func _on_die_timeout():
	Engine.time_scale = 0


func _on_animated_sprite_2d_animation_finished():
	$die.start()
	anim.play("Death")
	$AnimatedSprite2D.hide()
