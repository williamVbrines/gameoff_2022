extends Label

var stress : float = 0;

func _ready() -> void:
	_make_connections();
	hide();
	
	
func _make_connections() -> void:
	EventManager.stress_changed.connect(_on_stress_changed);
	EventManager.start_combat.connect(_on_combat_started);
	EventManager.start_exploration.connect(_on_exploration_started);
	
	
func _on_combat_started(_cam : Camera3D) -> void:
	show();
	
	
func _on_exploration_started() -> void:
	hide();
	
	
func _on_stress_changed(val : float) -> void:
	stress = min(100, max(0, val));
	
	set_text("stress : " + str(stress));
	
