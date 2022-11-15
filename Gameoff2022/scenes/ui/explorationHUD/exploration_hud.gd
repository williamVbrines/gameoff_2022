extends Control

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	EventManager.start_combat.connect(_on_combat_started);
	EventManager.start_exploration.connect(_on_exploration_started);
	EventManager.start_dialog.connect(_on_start_dialog)
	EventManager.dialog_ended.connect(_on_dialog_eneded)
	
func _on_start_dialog(_str : String) -> void:
	hide();
	
	
func _on_dialog_eneded() -> void:
	show();
	
	
func _on_combat_started(_wiht : String , _cam : Camera3D) -> void:
	hide();
	
	
func _on_exploration_started() -> void:
	show();
	
	
