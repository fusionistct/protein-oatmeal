extends AudioStreamPlayer

func _ready():
	var audioStream : AudioStream = preload("res://Dialogue System copy/blip.wav")
	self.set_stream(audioStream)
	self.set_volume_db(2.0)
