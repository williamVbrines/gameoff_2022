extends Label

var annoyance : float = 0;

func _ready() -> void:
	EventManager.changed_annoyance.connect(_on_change_annoyance);
	
func _on_change_annoyance(val : float) -> void:
	annoyance = min(100, max(0, val));
	
	set_text("Persuasion : " + str(annoyance));
	
	EventManager.annoyance_changed.emit(annoyance);
