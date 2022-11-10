extends Button

@export var dialog : String = "";
var opponent : String = "";

func _ready() -> void:
	set_text("Disengage");
	_make_connections();
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	pressed.connect(_on_pressed);
	
		
func _on_start_combat(with : String, _cam : Camera3D) -> void:
	opponent = with;
	
	
func _on_pressed() -> void:
	disabled = true;
	_on_flee();
	
	
func _on_flee() -> void:
	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
	EventManager.disengage.emit(dialog);
	
