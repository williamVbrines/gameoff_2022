extends Node3D

@export var mesh : MeshInstance3D;


var mouse_in_area : bool = false;
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("mouse_left") && mouse_in_area:
		EventManager.room_show_confirm.emit("This is a tool tip");
		EventManager.room_hide_tooltip.emit();

func _on_area_3d_mouse_entered() -> void:
	EventManager.room_show_tooltip.emit("This is a tool tip");
	_hovered();


func _on_area_3d_mouse_exited() -> void:
	EventManager.room_hide_tooltip.emit();
	_unhovered();


func _hovered()->void:
	mouse_in_area = true;
	mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",1.8);
	
	
func _unhovered()->void:
	mouse_in_area = false;
	mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);
