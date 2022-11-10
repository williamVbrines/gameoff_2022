extends Button

@export var data : Resource : set = set_data;
var opponent : String = "";

func _init(new_data : ItemData = null) -> void:
	set_data(new_data if new_data else data);
	
	
func _ready() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	pressed.connect(_on_pressed);
	
	if !data: 
		queue_free();
		return;
	
func _on_start_combat(with : String, _cam : Camera3D) -> void:
	if !data: 
		queue_free();
		return;
		
	opponent = with;
	set_data(data);
	
	
func set_data(new_data : TacticsData) -> void:
	if !new_data: return;
		
	data = new_data;
	set_text(data.gen_label());
	
	
func _on_pressed() -> void:
	disabled = true;
	_on_attack();
	
	
func _on_attack() -> void:
	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
	EventManager.attack.emit(opponent, data.gen_attack_info(), self);	
	
	
