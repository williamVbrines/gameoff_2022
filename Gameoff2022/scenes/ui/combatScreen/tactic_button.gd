extends Button

@export var tactic : Resource;
var opponent : String = "";

func _ready() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	pressed.connect(_on_pressed);
	
func _on_start_combat(with : String, _cam : Camera3D) -> void:
	opponent = with;
	set_tactic(tactic);
	
	
func set_tactic(new_tactic : TacticsData) -> void:
	tactic = new_tactic;
	set_text(tactic.gen_label());
	
	
func _on_pressed() -> void:
	disabled == true;
	_on_attack();
	
	
func _on_attack() -> void:
	#TODO: get actual stat val and plug that in to tatic.get_amount
#	tactic = tactic as TacticsData;
	var data = {
		"type" : tactic.stat,
		"amt" : tactic.get_amount(10),
		"cost" : tactic.cost,
		"dialog" : tactic.get_dialog()
	};
	
	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
	EventManager.attack.emit(opponent, data, self);	
	
	
