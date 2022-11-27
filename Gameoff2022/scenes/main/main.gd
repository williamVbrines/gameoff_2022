extends Control

func _ready() -> void:
	SceneChanger.set_current(self)
	EventManager.load_file_data.emit();
	EventManager.loading_complete.connect(_loading_complete);
	
	
func _loading_complete():
	SceneChanger.load_level("res://scenes/levels/room/room.tscn");
