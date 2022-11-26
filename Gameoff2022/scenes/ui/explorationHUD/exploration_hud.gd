extends Control


func _ready() -> void:
	EventManager.show_mosue.emit();
	
