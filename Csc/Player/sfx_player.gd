extends AudioStreamPlayer

@onready var _step: Array[String] = [
	"res://Assets/sfx/Footsteps/garage step 1.wav",
	"res://Assets/sfx/Footsteps/garage step 2.wav",
	"res://Assets/sfx/Footsteps/garage step 3.wav",
	"res://Assets/sfx/Footsteps/garage step 4.wav",
	"res://Assets/sfx/Footsteps/garage step 5.wav",
	"res://Assets/sfx/Footsteps/garage step 6.wav"
]

@onready var _pain: Array[String] = [
	"res://Assets/sfx/Player pain/pain 1.wav",
	"res://Assets/sfx/Player pain/pain 2.wav",
	"res://Assets/sfx/Player pain/pain 3.wav",
]
@onready var _dash: Array[String] = [
	"res://Assets/sfx/magic dash.wav"
]
	
func _play(sound_array: Array[String],volume = 0 ):
	var random_sound = sound_array.pick_random()
	var audio: AudioStream = load(random_sound)
	self.set_stream(audio)
	self.volume_db = volume
	self.play()


func step():
	pass #didn't sound good
	#_play(_step, -20)
	
func pain():
	_play(_pain,-10)
	
func dash():
	_play(_dash,-10)
	
