extends Control

var data : Resource : set = set_data;
@onready var cost_label: Label = $Button/CostLabel
@onready var button: Button = $Button


func set_data(new_data : ClueData) -> void:
	data = new_data;
	
	
func _ready() -> void:
	if data != null:
		if data is ClueData:
			cost_label.set_text(str(data.cost));
			button.set_text(data.name + " : " + data.discrtiption);
	
	
func store_data():
	if data != null:
		SystemGlobals.player_clues.append(data.name);
