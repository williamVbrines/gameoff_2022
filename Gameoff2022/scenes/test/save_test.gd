extends Node

var save_data : SaveData = SaveData.new();

func _ready() -> void:
	save_data.save_data();
	save_data.laod_data();
