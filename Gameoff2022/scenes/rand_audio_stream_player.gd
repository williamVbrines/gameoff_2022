extends AudioStreamPlayer
class_name RandAudioStreamPlayer
@export var samples : Array[AudioStream];


func play_rand()->void:
	var index = randi() % samples.size();
	
	stream = samples[index];
	
	play();
