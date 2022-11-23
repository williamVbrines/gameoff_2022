extends Node3D
class_name RoomInteractable3D

@export var mesh : MeshInstance3D;
@export var area : Area3D;

@export var message : String = "Keep Calm this is just a test"
@export var tooltip : String = "test of tool tip"
@export var action : String = "Test";

var mouse_in_area : bool = false;

func _ready() -> void:
	_make_connections();
	
func _make_connections()->void:
	area.mouse_entered.connect(_on_mouse_entered);
	area.mouse_exited.connect(_on_mouse_exited);
	
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("mouse_left") && mouse_in_area:
		EventManager.room_show_confirm.emit(message,action);
		EventManager.room_hide_tooltip.emit();

func _on_mouse_entered() -> void:
	EventManager.room_show_tooltip.emit(tooltip);
	_hovered();


func _on_mouse_exited() -> void:
	EventManager.room_hide_tooltip.emit();
	_unhovered();


func _hovered()->void:
	mouse_in_area = true;
	mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",1.8);
	
	
func _unhovered()->void:
	mouse_in_area = false;
	mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);
