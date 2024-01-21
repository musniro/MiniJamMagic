extends Node2D
class_name Particles

@onready var run_particles = $Run
@onready var jump_particles = $Jump
@onready var land_particles = $Land

func particles(player: Player):
	run_particles.emitting = player.state == player.State.RUN
	$AfterImage.emitting = player.state != player.State.IDLE
	
	if player.is_just_jumped:
		jump_particles.emitting = true 
		jump_particles.restart()
	
	if player.is_just_landed:
		land_particles.emitting = true 
		land_particles.restart()
	
	if player.is_just_teleported:
		$Teleport.emitting = true
		$Teleport.restart()
	
	if player.is_just_hit:
		$HitParticles.emitting = true
		$HitParticles.restart()
	
	if player.is_running_right:
		self.scale.x = 1
	else:
		self.scale.x = -1
		
