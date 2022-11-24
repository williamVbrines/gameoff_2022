extends Camera3D

var drag_orgin : Vector2 = Vector2.ZERO;
var rot : Vector2 = Vector2.ZERO;
const MAX_ROT = PI/30;

func _ready() -> void:
	rot = Vector2(rotation.y, rotation.x);
	drag_orgin = Vector2(1920,1080)/2
	
func _input(event: InputEvent) -> void:
	camera_event(event);
	
func camera_event(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.x = rot.y - ((get_viewport().get_mouse_position().y - drag_orgin.y) / 10000);
		rotation.y = rot.x - ((get_viewport().get_mouse_position().x - drag_orgin.x) / 10000);
	
