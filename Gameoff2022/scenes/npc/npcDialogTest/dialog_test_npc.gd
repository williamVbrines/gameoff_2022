extends Node3D
@export var dialog_id : String = "test_dialog";
@export_node_path(MeshInstance3D) var npc_mesh;
@export_node_path(Area3D) var interactable_area;

var selected : bool = false;

func _ready() -> void:
	npc_mesh = get_node(npc_mesh) as MeshInstance3D;
	interactable_area = get_node(interactable_area) as InteractableArea3D;
	if !npc_mesh || !interactable_area:
		printerr("BAD NODE PATH!!!")
		queue_free();
		return;
		
	_make_connections();
	
	
func _make_connections() -> void:
	interactable_area.area_unhovered.connect(_unhovered);
	interactable_area.area_hovered.connect(_hovered);
	interactable_area.area_pressed.connect(_on_pressed);
	
	EventManager.start_exploration.connect(_on_start_exploration);
	EventManager.dialog_ended.connect(_on_dialog_eneded);
	
	
func _on_dialog_eneded() -> void:
	selected = false;
	
	
func _on_start_exploration() -> void:
	selected = false;
	
func _hovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",0.3);
	
	
func _unhovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);
	
	
func _on_pressed() -> void:
	if !selected:
		EventManager.start_dialog.emit(dialog_id);
		selected = true;
	
