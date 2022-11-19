extends Resource

class_name PlayerActionData
#Stat Types
const CHARM = 0;
const LOGIC = 1;
const DECEPTION = 2;
const INTIMIDATION = 3;

@export_category("PlayerActionData")
@export var discrtiption : String = "This is a test"
@export_range(1,9,1) var cost : int = 1;
@export var dialog_pool : Array[String] = [];
@export var name : String = "name";

func get_amount(stat_val : float = 0.0) -> float: return stat_val;
	
	
func get_dialog() -> String:
	if dialog_pool.size() == 0: return "";
	return dialog_pool[randi() % dialog_pool.size()];
	
	
func gen_label() -> String: return "";
	
	
