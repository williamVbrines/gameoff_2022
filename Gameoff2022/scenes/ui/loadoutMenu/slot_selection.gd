extends Button

@export_range(1.0, 3.0, 1.0) var slot_num : int = 1;

var tactic_id : String = "NULL";

func _ready() -> void:
	_update_label();
	
	_make_connectois();
	
	
func _make_connectois() -> void:
	pressed.connect(_on_pressed);
	visibility_changed.connect(_on_visibilty_changed);
	
	
func _on_visibilty_changed() -> void:
	tactic_id = SystemGlobals.player_tactics.get("SLOT:" + str(slot_num), null);
	_update_label();
	
	
func _update_label()->void:
	var data : TacticsData = ResourcManager.get_tactic(tactic_id);
	
	text = "EMPTY";
	
	if data is TacticsData:
		text = data.gen_label();
	
	
func _on_pressed() -> void:
	var available = SystemGlobals.player_tactics.get("AVAILABLE") as Array;
	var data : TacticsData = null;
	var id : String = "NULL";
	
	if available == null: return;
	
	if available.size() > 0:
		id = available[0];
		data = ResourcManager.get_tactic(id);
		
	if data != null:
		tactic_id = id;
		text = data.gen_label();
	
	
func store_data() -> void:
	SystemGlobals.player_tactics["SLOT:" + str(slot_num)] = tactic_id;
	
	
	
	
