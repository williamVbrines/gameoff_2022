extends Node3D

@onready var interactable_area: InteractableArea3D = $InteractableArea3D
@onready var npc_mesh: MeshInstance3D = $NpcMesh
@onready var camera: Camera3D = $Camera

var selceted : bool = false;

func _ready() -> void:
	interactable_area.area_unhovered.connect(_unhovered);
	interactable_area.area_hovered.connect(_hovered);
	interactable_area.area_pressed.connect(_on_pressed);
	
	EventManager.attack.connect(_on_attack);

func _hovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",0.3);

func _unhovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);

func _on_pressed() -> void:
	if !selceted:
		EventManager.start_combat.emit(camera);
		selceted = true;
	
func _on_attack(target : String,data : Dictionary, sender : Node3D)->void:
	pass
