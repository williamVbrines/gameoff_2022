extends Control

func _ready() -> void:
	SceneChanger.set_current(self)
	SceneChanger.load_level("res://scenes/levels/room/room.tscn")

