extends Label

var persuasion : float = 0;

func _ready() -> void:
	EventManager.change_persuasion.connect(_on_change_persuasion);
	
func _on_change_persuasion(val : float) -> void:
	persuasion = min(100, max(0, val));
	
	set_text("Persuasion : " + str(persuasion));
	
	EventManager.persuasion_changed.emit(persuasion);
