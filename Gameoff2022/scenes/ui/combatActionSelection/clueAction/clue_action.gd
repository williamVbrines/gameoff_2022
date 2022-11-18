extends Button

@export var data : Resource : set = set_data;
var opponent : String = "";


func _init(new_data : ClueData = null) -> void:
	
	set_data(new_data if new_data else data);
	pass


func _ready() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	pressed.connect(_on_pressed);
	
	if !data: 
		queue_free();
		return;
	
func _on_start_combat(with : String, _cam : Camera3D) -> void:
	opponent = with;
	
	
func set_data(new_data : ClueData) -> void:
	if !new_data: return;
	data = new_data;
	set_text(data.gen_label());


func _on_pressed() -> void:
	disabled = true;
	_use_action();


func _use_action() -> void:
	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
	data.activate_effect(opponent);

