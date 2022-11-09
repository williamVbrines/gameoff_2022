extends Node3D

@onready var interactable_area: InteractableArea3D = $InteractableArea3D
@onready var npc_mesh: MeshInstance3D = $NpcMesh
@onready var camera: Camera3D = $Camera
@export var damage_dist : Dictionary = {};
var persuasion : float = 0;
var guard_effectiveness : float = 0.5;
var selected : bool = false;
var guarding_turns : int = 0;
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

func _ready() -> void:
	for key in base_dist:
		if !damage_dist.has(key):
			damage_dist[key] = base_dist[key];
	_make_connections();
	
func _make_connections() -> void:
	interactable_area.area_unhovered.connect(_unhovered);
	interactable_area.area_hovered.connect(_hovered);
	interactable_area.area_pressed.connect(_on_pressed);
	
	EventManager.attack.connect(_on_attack);
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	
	
func _on_combat_state_changed(state : String) -> void:
	
	if selected:
		match state.to_upper():
			"NPC_ACTION_SELECT":
				_select_action();
			"CHECK_WIN":
				_check_if_persuaded();
			
func _check_if_persuaded() -> void:
	if persuasion == 100:
		EventManager.combat_state_changed.emit("WIN");
	else:
		EventManager.combat_state_changed.emit("CHECK_Q");
		
		
func _hovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",0.3);

func _unhovered()->void:
	npc_mesh.get_active_material(0).get("next_pass").set("shader_parameter/str",300.0);

func _on_pressed() -> void:
	if !selected:
		EventManager.combat_state_changed.emit("SET_UP");
		EventManager.start_combat.emit(name, camera);
		selected = true;
	
func _on_attack(target : String,data : Dictionary, sender)->void:
	if target == "NPC":
		var damage = data.amt;
		
		if damage_dist.has(data.type):
			damage *= damage_dist.get(data.type);
			damage += damage_dist.get(data.type + "_f");
		
		damage = max(0,damage);
		
		if guarding_turns > 0:
			damage *= (1.0 - guard_effectiveness);
			guarding_turns -= 1;
			
		persuasion += damage;
		
		EventManager.persuasion_changed.emit(persuasion);

		EventManager.change_battel_queue.emit("PLAYER", data.cost)
		
		EventManager.combat_state_changed.emit("CHECK_WIN")
	
func _select_action() -> void:
	EventManager.combat_state_changed.emit("NPC_ACTION_RESOLVE");
	attack();
#	match randi() % 3:
#		0:
#			heal();
#		1:
#			guard();
#		2:
#			attack();
	
func heal():
	var cost = 2;
	persuasion = min(0, persuasion - 10);
	
	EventManager.persuasion_changed.emit(persuasion);
	
	EventManager.battel_queue_changed.emit("NPC" , cost);
	EventManager.combat_state_changed.emit("CHECK_LOSS");
	
func guard():
	
	var cost = 2;
	guarding_turns += 2;
	
	EventManager.battel_queue_changed.emit("NPC" , cost);
	EventManager.combat_state_changed.emit("CHECK_LOSS");
	
func attack():
	var cost = 2;
	var data = {
		"type" : "NPC_ATCK",
		"amt" : 50,
		"cost" : cost
	}
	
	EventManager.attack.emit("PLAYER",data, self);
	
