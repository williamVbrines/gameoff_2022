extends Camera3D

var drag_orgin : Vector2 = Vector2.ZERO;
var next_rot : Vector2 = Vector2.ZERO;
var rot : Vector2 = Vector2.ZERO;
const MAX_ROT = PI/30;
const SOMTHING = 2;

func _ready() -> void:
	rot = Vector2(rotation.x,rotation.y);
	next_rot = rot
	drag_orgin = Vector2(1920,1080)/2
	
func _input(event: InputEvent) -> void:
	camera_event(event);
	
func camera_event(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		next_rot.x = rot.x - ((get_viewport().get_mouse_position().y - drag_orgin.y) / 10000);
		next_rot.y = rot.y - ((get_viewport().get_mouse_position().x - drag_orgin.x) / 10000);
	
func _process(delta: float) -> void:
	rotation.x = lerp_angle(rotation.x,next_rot.x,SOMTHING * delta);
	rotation.y = lerp_angle(rotation.y,next_rot.y,SOMTHING * delta);
