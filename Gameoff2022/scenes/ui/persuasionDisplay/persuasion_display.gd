extends Label

var persuasion : float = 0;

func _ready() -> void:
	_make_connections();
	hide();
	
func _make_connections() -> void:
	EventManager.persuasion_changed.connect(_on_persuasion_changed);
	EventManager.start_combat.connect(_on_combat_started);
	EventManager.start_exploration.connect(_on_exploration_started);
	
	
func _on_combat_started(_with : String, _cam : Camera3D) -> void:
	show();
	
	
func _on_exploration_started() -> void:
	hide();
	
	
func _on_persuasion_changed(val : float) -> void:
	persuasion = min(100, max(0, val));
	
	set_text("Persuasion : " + str(persuasion) + "%");
	
	

