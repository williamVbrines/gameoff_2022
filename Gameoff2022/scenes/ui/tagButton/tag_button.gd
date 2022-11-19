extends Button
class_name UITagButton

@export var hot_key : int = 0;
@export var normal_color_1 : Color;
@export var normal_color_2 : Color;
@export var hovered_color_1 : Color;
@export var hovered_color_2 : Color;
@export var pressed_color_1 : Color;
@export var pressed_color_2 : Color;
@export var disabled_color_1 : Color;
@export var disabled_color_2 : Color;

var hovered : bool = false : set = set_hovered;

func set_hovered(val) -> void:
	hovered = val;
	if hovered:
		material.set("to_1", hovered_color_1);
		material.set("to_2", hovered_color_2);
	else:
		material.set("to_1", normal_color_1);
		material.set("to_2", normal_color_2);
		
		
func _ready() -> void:
	_make_connections();
	
	
func _make_connections()->void:
	button_down.connect(_on_button_down);
	button_up.connect(_on_button_up);
	mouse_entered.connect(_on_mouse_entered);
	mouse_exited.connect(_on_mouse_exited);
	
	
func _on_button_down() -> void:
	material.set("to_1", pressed_color_1);
	material.set("to_2", pressed_color_2);
	
	
func _on_button_up() -> void:
	if hovered:
		material.set("to_1", hovered_color_1);
		material.set("to_2", hovered_color_2);
	else:
		material.set("to_1", normal_color_1);
		material.set("to_2", normal_color_2);
	
	
func _on_mouse_entered() -> void:
	hovered = true;
	
	
func _on_mouse_exited() -> void:
	hovered = false;
	
	
