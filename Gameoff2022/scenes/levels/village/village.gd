extends Node

@onready var bgm_audio: AudioStreamPlayer = $BGMAudio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bgm_audio.play();
