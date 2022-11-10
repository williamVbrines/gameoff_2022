extends Label

var annoyance : float = 0;

func _ready() -> void:
	EventManager.annoyance_changed.connect(_on_annoyance_changed);
	
func _on_annoyance_changed(val : float) -> void:
	annoyance = min(100, max(0, val));
	
	set_text("Annoyance : " + str(annoyance));
	
