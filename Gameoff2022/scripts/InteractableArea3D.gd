extends Area3D
class_name InteractableArea3D

@export var detection_groups : Array[String] = [];

var is_hovered : bool = false : set = set_is_hovered;
var is_pressed : bool = false : set = set_is_pressed;
var _num_hovered : int = 0;
var _num_pressed : int = 0;
signal area_pressed();
signal area_hovered();
signal area_unhovered();
signal area_released();
	
func set_is_hovered(val : bool):
	if val == true:
		_num_hovered += 1;
		is_hovered = val;
		area_hovered.emit();
	else:
		_num_hovered -= 1;
		
		if _num_hovered <= 0:
			
			
			area_unhovered.emit();
			_num_hovered = 0;
			_num_pressed = 0;
			is_hovered = val;
	
	
func set_is_pressed(val : bool):
	if val == true:
		_num_pressed += 1;
		is_pressed = val;
		area_pressed.emit();
	else:
		_num_pressed -= 1;
		if _num_pressed <= 0:
			_num_pressed = 0;
			is_pressed = val;
			area_released.emit();
	
	
func _ready() -> void:
	area_entered.connect(_on_area_entered);
	area_exited.connect(_on_area_exited);
	body_entered.connect(_on_body_entered);
	body_exited.connect(_on_body_exited);
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left") && is_hovered:
		is_pressed = true;
	if event.is_action_released("mouse_left") && is_hovered:
		is_pressed = false;
	
	
func _on_area_entered(area: Area3D) -> void:
	_check_entered(area);
	
	
func _on_area_exited(area: Area3D) -> void:
	_check_exited(area);
	
	
func _on_body_entered(body: Node3D) -> void:
	_check_entered(body);
	
	
func _on_body_exited(body: Node3D) -> void:
	_check_exited(body)
	
	
func _check_exited(node : Node3D) -> void:
	if detection_groups.size() <= 0:
		is_hovered = false;
		return;
		
	for group in detection_groups:
		if node.is_in_group(group):
			is_hovered = false;
			break;
	
	
func _check_entered(node : Node3D) -> void:
	if detection_groups.size() <= 0:
		is_hovered = true;
		return;
		
	for group in detection_groups:
		if node.is_in_group(group):
			is_hovered = true;
			break;
	
	
