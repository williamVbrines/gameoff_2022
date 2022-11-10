extends Label

var persuasion : float = 0;

func _ready() -> void:
	EventManager.persuasion_changed.connect(_on_persuasion_changed);
	
func _on_persuasion_changed(val : float) -> void:
	persuasion = min(100, max(0, val));
	
	set_text("Persuasion : " + str(persuasion) + "%");

