extends Control

var data : Resource : set = set_data;
@onready var cost_label: Label = $Button/CostLabel
@onready var button: Button = $Button


func set_data(new_data : ItemData) -> void:
	data = new_data;
	
	
func _ready() -> void:
	if data != null:
		if data is ItemData:
			cost_label.set_text(str(data.cost));
			button.set_text(data.name + " : " + data.discrtiption);
	
	
func store_data():
	if data != null:
		SystemGlobals.player_items.append(data.name);
