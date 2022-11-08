extends Node3D

@onready var interactable_area: InteractableArea3D = $InteractableArea3D
@onready var npc_mesh: MeshInstance3D = $NpcMesh
@onready var camera: Camera3D = $Camera
@export var damage_dist : Dictionary = {};

var selceted : bool = false;

const base_dist = {
	"charm" : 1.0,
	"charm_f" : 0,
	
	"logic" : 1.0,
	"logic_f" : 0,
	
	"decep" : 1.0,
	"decep_f" : 1.0,
	
	"intim" : 1.0,
	"intim_f" : 0
}



var persuasion = 0;

func _ready() -> void:
	for key in base_dist:
		if !damage_dist.has(key):
			damage_dist[key] = base_dist[key];
			
	
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
		EventManager.start_combat.emit(name, camera);
		selceted = true;
	
func _on_attack(target : String,data : Dictionary, sender)->void:
	var damage = data.amt;
	
	if damage_dist.has(data.type):
		damage *= damage_dist.get(data.type);
		damage += damage_dist.get(data.type + "_f");
	
	damage = max(0,damage);
	
	persuasion += damage;
	
	EventManager.persuasion_changed.emit(persuasion);
	
	print("NPC Takeing: " + str(damage) + " damage")
	
func choos_action() -> void:
	pass
	
func heal():
	pass
	
func guard():
	pass
	
func attack():
	pass 
