extends Control

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_combat_started);
	EventManager.start_exploration.connect(_on_exploration_started);
	
	
func _on_combat_started(_wiht : String , _cam : Camera3D) -> void:
	hide();
	
	
func _on_exploration_started() -> void:
	show();
	
	
