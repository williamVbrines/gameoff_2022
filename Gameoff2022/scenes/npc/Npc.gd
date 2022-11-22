extends Node3D
class_name NPC

@export var npc_res : Resource;
@export_node_path(MeshInstance3D) var npc_mesh;
@export_node_path(Area3D) var interactable_area;
@export_node_path(Camera3D) var camera;

var selected : bool = false;

func _ready() -> void:
	npc_mesh = get_node(npc_mesh) as MeshInstance3D;
	interactable_area = get_node(interactable_area) as InteractableArea3D;
	camera = get_node(camera) as Camera3D;
	if !npc_mesh || !camera || !interactable_area:
		printerr("BAD NODE PATH!!!")
		queue_free();
		return;
		
	_make_connections();
	
	
func _make_connections() -> void:
	interactable_area.area_unhovered.connect(_unhovered);
	interactable_area.area_hovered.connect(_hovered);
	interactable_area.area_pressed.connect(_on_pressed);
	
	EventManager.start_exploration.connect(_on_start_exploration);
	
func _on_start_exploration() -> void:
	selected = false;
	
func _hovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",0.3);
	
	
func _unhovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);
	
	
func _on_pressed() -> void:
	if !selected && get_tree().paused == false:
#		EventManager.combat_state_changed.emit("SET_UP");
		SystemGlobals.opponent = name;
		EventManager.start_combat.emit(camera);
		selected = true;
	
