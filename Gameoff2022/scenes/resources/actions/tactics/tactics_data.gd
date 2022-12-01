extends PlayerActionData

class_name TacticsData

#Ratting Types
const LOW : int = 30;
const MED : int = 60;
const HIGH : int = 100;

@export_category("TacticsData")
@export_enum(CHARM,LOGIC,DECEPTION,INTIMIDATION) var stat : int = CHARM;
@export_enum("LOW:30","MED:60","HIGH:100") var ratting : int = MED;
@export_range(0,100,0.5) var variance : int = 0;
@export var icon : Texture = null;

#Override
func get_amount(stat_val : float = 0.0) -> float:
	match stat:
		0:
			stat_val = SystemGlobals.player_stats.CHARM
		1:
			stat_val = SystemGlobals.player_stats.LOGIC
		2:
			stat_val = SystemGlobals.player_stats.DECEPTION
		3:
			stat_val = SystemGlobals.player_stats.INTIMIDATION
			
	var amount = stat_val * (float(ratting)/100.0) + randf_range(0.0, variance)
	return amount;
	
	
func gen_attack_info() -> Dictionary:
	var stat_val = 0;
	var type : String = "NON";
	
	match stat:
		CHARM : 
			type = "CHARM";
			stat_val = SystemGlobals.player_stats.CHARM;
		INTIMIDATION : 
			type = "INTIMIDATION";
			stat_val = SystemGlobals.player_stats.INTIMIDATION;
		DECEPTION : 
			type = "DECEPTION";
			stat_val = SystemGlobals.player_stats.DECEPTION;
		LOGIC : 
			type = "LOGIC";
			stat_val = SystemGlobals.player_stats.LOGIC;
		
		
	var attack_info = {
		"type" : type,
		"amt" : get_amount(stat_val),
		"cost" : cost,
		"dialog" : get_dialog()
	};
	
	return attack_info;
	
	
#Override
func gen_label() -> String:
	var text : String = "[";
	
	match stat:
		CHARM:
			text += "CHARM";
		INTIMIDATION:
			text += "INTIMIDATION";
		DECEPTION:
			text += "DECEPTION";
		LOGIC:
			text += "LOGIC";
			
	text += " ,";
	
	match  ratting:
		LOW:
			text += "LOW";
		MED:
			text += "MED";
		HIGH:
			text += "HIGH";
		_: 
			text += "ERR";
			
	text += " ,Cost: " + str(cost) + "] " + discrtiption;
	
	return text;
	
	
