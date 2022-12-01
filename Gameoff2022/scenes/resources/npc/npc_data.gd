extends Resource
class_name NPCData

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

@export var name : String = "NPC"
@export var tatics : Resource;

@export var damage_dist : Dictionary = {};

@export var attack_cost : int = 1;
@export var attack_amount : int = 0;

@export var heal_cost : int = 1;
@export_range(0.0, 1.0) var heal_percent : float = 0;
@export_range(0.0, 100.0) var heal_flat : float = 0;

@export var guard_cost : int = 1;
@export var guard_amount : int = 1;
@export_range(0.0, 1.0) var guard_percent : float = 0.0;
@export var guard_flat : float = 0;

@export var dialog_pool : Array[String] = [];

var guard_stack : int = 0;

var selected : bool = false;

signal selected_action(action);

func _init() -> void:
	tatics = tatics as NPCTactics;
	
	for key in base_dist:
		if !damage_dist.has(key):
			damage_dist[key] = base_dist[key];
			
	_make_connections();
	
	
func _make_connections() -> void:
	EventManager.attack.connect(_on_attacked);
	EventManager.combat_state_changed.connect(_on_combat_state_changed);
	EventManager.start_combat.connect(_on_start_combat);
	EventManager.start_exploration.connect(_on_start_exploration);
	
func _on_start_exploration() -> void:
	selected = false;
	
func _on_start_combat(_cam : Camera3D) -> void:
	selected = SystemGlobals.opponent == name;
	SystemGlobals.persuasion = 0;
	
func _on_combat_state_changed(state : String) -> void:
	if selected:
		match state.to_upper():
			"NPC_ACTION_SELECT":
				_select_action();
			"CHECK_WIN":
				_check_if_persuaded();
			
	
func _check_if_persuaded() -> void:
	if SystemGlobals.persuasion  >= 100:
		EventManager.call_deferred("emit_signal", "combat_state_changed","WIN");
	elif SystemGlobals.stress  >= 100:
		EventManager.call_deferred("emit_signal", "combat_state_changed","LOSS");
	else:
		EventManager.call_deferred("emit_signal", "combat_state_changed","CHECK_Q");
	
	
func _on_attacked(target : String,data : Dictionary)->void:
	if target == name:
		var damage = data.amt;
		
		if damage_dist.has(data.type):
			damage *= damage_dist.get(data.type);
			damage += damage_dist.get(data.type + "_f");
		
		damage = max(0,damage);
		
		if guard_stack > 0:
			damage = max( 0 , damage * (1.0 - guard_percent) - guard_flat);
			guard_stack -= 1;
			
		SystemGlobals.persuasion += damage;
		
		EventManager.persuasion_changed.emit(SystemGlobals.persuasion );
		
		EventManager.display_dialog.emit("PLAYER",data);
	
	
func _select_action() -> void:
	EventManager.combat_state_changed.emit("NPC_ACTION_RESOLVE");
	var action = tatics.get_action(SystemGlobals.persuasion ,0.0, guard_stack);
	
	match action:
		
		NPCTactics.HEAL:
			selected_action.emit(NPCTactics.HEAL);
			heal();
		NPCTactics.GUARD:
			selected_action.emit(NPCTactics.GUARD);
			guard();
		NPCTactics.ATTACK:
			selected_action.emit(NPCTactics.ATTACK);
			attack();
	
	
func heal():
	
	SystemGlobals.persuasion = min(0, SystemGlobals.persuasion  * (1.0 - heal_percent) - heal_flat);
	
	EventManager.persuasion_changed.emit(SystemGlobals.persuasion);
	
	var data = {
		"type" : "NPC_ATTACK",
		"amt" : 0,
		"cost" : heal_cost
	}
	
	EventManager.attack.emit("PLAYER",data);
	EventManager.combat_state_changed.emit("ADJUST_Q");
	
	
func guard():
	guard_stack += guard_amount;
	
	EventManager.battel_queue_changed.emit("NPC" , guard_cost);
	EventManager.combat_state_changed.emit("ADJUST_Q");
	
	
func attack():
	var data = {
		"type" : "NPC_ATTACK",
		"amt" : attack_amount,
		"cost" : attack_cost
	}
	
	EventManager.attack.emit("PLAYER",data);
	
	
