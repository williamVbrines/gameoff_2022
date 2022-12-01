extends Node3D

@onready var chest_open_mesh: MeshInstance3D = $ChestOpenMesh
@onready var chest_close_mesh: MeshInstance3D = $ChestCloseMesh
@onready var interactable_area: Area3D = $InteractableArea3D

signal chest_opend();

var is_open : bool = false;

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	interactable_area.area_unhovered.connect(_unhovered);
	interactable_area.area_hovered.connect(_hovered);
	interactable_area.area_pressed.connect(_on_pressed);
	

func _on_pressed() -> void:
	if !is_open:
		is_open = true;
		chest_opend.emit();
	chest_close_mesh.hide();
	chest_open_mesh.show();
	

func _hovered()->void:
	chest_close_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",1);
	
	
func _unhovered()->void:
	chest_close_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);
	
