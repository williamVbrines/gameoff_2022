extends Label

var annoyance : float = 0;

func _ready() -> void:
	_make_connections();
	hide();
	
	
func _make_connections() -> void:
	EventManager.annoyance_changed.connect(_on_annoyance_changed);
	EventManager.start_combat.connect(_on_combat_started);
	EventManager.start_exploration.connect(_on_exploration_started);
	
	
func _on_combat_started(_with : String, _cam : Camera3D) -> void:
	show();
	
	
func _on_exploration_started() -> void:
	hide();
	
	
func _on_annoyance_changed(val : float) -> void:
	annoyance = min(100, max(0, val));
	
	set_text("Annoyance : " + str(annoyance));
	
