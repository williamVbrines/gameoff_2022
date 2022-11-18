@tool
extends Control

@export_range(0,9,1) var cost = 0 : set = set_cost;
@onready var label: Label = $BattleMenuIconTimeCost/Label

func set_cost(val : int) -> void:
	cost = clampi(val, 0, 9);
	label.set_text(str(cost));
	
