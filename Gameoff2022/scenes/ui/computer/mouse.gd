extends Control
	
var bounds : Vector2 = Vector2(1080, 1080);
@onready var mouse_press_audio: AudioStreamPlayer = $MousePressAudio

var shown : bool = true;

func _ready() -> void:
	EventManager.show_mosue.connect(hide_mouse);
	EventManager.hide_mosue.connect(show_mouse);
	
	
func show_mouse():
	shown = true;
	
func hide_mouse():
	shown = false;
	
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position();
	
		global_position.x = clamp(global_position.x , 0, bounds.x);
		global_position.y = clamp(global_position.y , 0, bounds.y);
	if shown == true:
		if event is InputEventMouseButton:
			if event.is_pressed():
				mouse_press_audio.play();
