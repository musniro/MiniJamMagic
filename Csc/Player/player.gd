extends CharacterBody2D


@onready var timer_label = $Camera2D/Countdown
@onready var game_timer = $Death_Timer
var seconds_left : int = 180

var speed = 100
var jump = 250
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimationPlayer

var alive = true

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
		
		_anim()
	
	timer_label.text = "Time: " + str(seconds_left) + "s"
	

func _anim():
	if alive == true:
		if is_on_floor():
			if velocity.x >0:
				anim.play("Run")
				$Sprite2D.flip_h = false
			elif velocity.x <0:
				anim.play("Run")
				$Sprite2D.flip_h = true
			else:
				anim.play("Idle")
		
		if !is_on_floor():
			if velocity.y >0:
				anim.play("fall")
			elif velocity.y <0:
				anim.play("jump")
		


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
