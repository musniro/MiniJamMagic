extends CharacterBody2D
class_name Player

@export var timer_label: Label
@onready var game_timer = $Death_Timer

var seconds_left := 120

var speed := 230
var jump := 300
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
var is_just_jumped := false

var is_just_landed:
	get:
		return is_on_floor() and previous_state == State.FALL
var teleport_cooldown: float = 0
var is_just_teleported := false
var is_just_hit := false

var is_double_jump_available = true

func _ready():
	Engine.time_scale = 1
	game_timer.start(1)
	$Sprite2D.modulate = -1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_double_jump_available = true
		
	var can_jump = (is_on_floor() or is_double_jump_available)
	if Input.is_action_just_pressed("Jump") and can_jump:
		velocity.y -= jump
		is_double_jump_available = is_on_floor()
		is_just_jumped = true
	else:
		is_just_jumped = false	
	
	if alive == true:
		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			
		velocity.y = min(velocity.y, 300)	
		move_and_slide()
		
		_determine_state()
		_anim()
		particles.particles(self)
		
		try_teleport(delta)
		is_just_hit = false
		
	
	timer_label.text = "Time: " + str(seconds_left) + "s"
	
func try_teleport(delta):
	is_just_teleported = false
	teleport_cooldown -= delta	
	if teleport_cooldown < 0 and Input.is_mouse_button_pressed(1):
		_hit()
		var mouse_position = get_global_mouse_position()
		var dash_direction = (mouse_position - global_position).normalized()
		var dash_speed = 600
		velocity = dash_direction * dash_speed
		move_and_slide()
		teleport_cooldown = 0.3
		is_just_teleported = true
	

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
	is_just_hit = true
	$Indicator.visible = true
	$Indicator.scale = Vector2(0.02,0.02)
	
	var tween = get_tree().create_tween()
	tween.tween_property($Indicator, "scale", Vector2(0.2,0.2), 0.2)
	$Indicator.text = "-20 s "
	$Indicator_timer.start()
	
	var countdown: Label = $"../Camera2D/CanvasLayer/Countdown"
	countdown.modulate = Color.DARK_RED
	countdown.scale = Vector2(1.2,1.2)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(countdown, "modulate", Color.WHITE, 0.3)
	tween2.tween_property(countdown, "scale", Vector2(1,1), 0.3)
	
	
func _on_die_timeout():
	Engine.time_scale = 0
	$CanvasLayer/Game_Over.show()


func _on_animated_sprite_2d_animation_finished():
	$die.start()
	anim.play("Death")
	death_smoke.hide()


func _on_indicator_timer_timeout():
	$Indicator.hide()

