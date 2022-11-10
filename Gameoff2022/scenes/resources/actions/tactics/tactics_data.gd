extends PlayerActionData

class_name TacticsData
#Ratting Types
const LOW = 30;
const MED = 60;
const HIGH = 100;



@export_category("TacticsData")
@export_enum(CHARM,LOGIC,DECEPTION,INTIMIDATION) var stat = CHARM;
@export_enum(LOW,MED,HIGH) var ratting = MED;
@export_range(0,100,0.5) var variance : int = 0;

#Override
func get_amount(stat_val : float = 0.0) -> float:
	return stat_val * (1/ratting) + randf_range(0.0, variance);

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
			
	text += " ,Cost: " + str(cost) + "] " + discrtiption;
	
	return text;
