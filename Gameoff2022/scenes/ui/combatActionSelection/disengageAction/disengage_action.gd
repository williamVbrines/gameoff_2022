extends Control

@onready var tag_button: Button = $TagButton
@export var dialog : String = "";

var opponent : String = "";

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_start_combat);
	tag_button.pressed.connect(_on_pressed);
	
		
func _on_start_combat(with : String, _cam : Camera3D) -> void:
	opponent = with;
	
	
func _on_pressed() -> void:
	tag_button.set_disabled(true);
	_on_flee();
	
	
func _on_flee() -> void:
	EventManager.combat_state_changed.emit("PLAYER_ACTION_RESOLVE");
	EventManager.disengage.emit(dialog);
	
