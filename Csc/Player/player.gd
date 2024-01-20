extends CharacterBody2D
class_name Player

@onready var timer_label = $Camera2D/Countdown
@onready var game_timer = $Death_Timer

var seconds_left := 120

var speed := 100
var jump := 250
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $Animations/AnimationPlayer
@onready var particles : Particles = $Particles
@onready var death_smoke = $Animations/DeathSmoke

var alive := true
enum State { 
	IDLE,
	RUN,
	JUMP,
	FALL,
	DEAD
}
var state := State.IDLE
var previous_state := State.IDLE
var is_running_right:
	get:
		return velocity.x > 0
var is_just_jumped:
	get:
		return state == State.JUMP and previous_state in [State.RUN, State.IDLE] 	
var is_just_landed:
	get:
		return is_on_floor() and previous_state == State.FALL
		
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
		particles.particles(self)
		
	timer_label.text = "Time: " + str(seconds_left) + "s"
	
func _determine_state():
	previous_state = state
	
	if not alive:
		self.state = State.DEAD
		return 
		
	if is_on_floor():
		if _abs(velocity.x) > 0:
			self.state = State.RUN
		else:
			self.state = State.IDLE
	
	if !is_on_floor():
		if velocity.y > 0:
			self.state = State.FALL
		elif velocity.y < 0:
			self.state = State.JUMP
			
func _abs(x:float) -> float:
	return x if x > 0 else -x

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
			
	if is_just_jumped or is_just_landed:
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "scale", Vector2(1,0.5), 0.02)
		tween.tween_property($Sprite2D, "scale", Vector2(1,1), 0.2)
			

func _on_death_timer_timeout():
	seconds_left -= 1
	if seconds_left <= 0:
		game_timer.stop()
		alive = false
		anim.play("Hit")
		death_smoke.play()
		death_smoke.show()
	else:
		game_timer.start(1)

func _hit():
	seconds_left -= 20
	$Indicator.text = "-20 s "
	$Indicator_timer.start()

func _on_die_timeout():
	Engine.time_scale = 0


func _on_animated_sprite_2d_animation_finished():
	$die.start()
	anim.play("Death")
	death_smoke.hide()


func _on_indicator_timer_timeout():
	$Indicator.hide()
