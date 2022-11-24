extends Control


var bounds : Vector2 = Vector2(1920,1080);

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
	EventManager.hide_mosue.connect(hide);
	EventManager.show_mosue.connect(show);
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position();
	
		global_position.x = clamp(global_position.x , 0, bounds.x);
		global_position.y = clamp(global_position.y , 0, bounds.y);
		

