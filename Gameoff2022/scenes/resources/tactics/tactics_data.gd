extends Resource

class_name TacticsData

const CHARM = 0;
const LOGIC = 1;
const DECEPTION = 2;
const INTIMIDATION = 3;

const LOW = 30;
const MED = 60;
const HIGH = 100;


@export_enum(CHARM,LOGIC,DECEPTION,INTIMIDATION) var stat = CHARM;
@export_enum(LOW,MED,HIGH) var ratting = LOW;
@export_range(0,100,0.5) var variance : int = 0;
@export var discrtiption : String = "This is a test"
@export_range(1,9,1) var cost : int = 1;
@export var dialog_pool : Array[String] = [];


func get_amount(stat_val : float) -> float:
	return stat_val * (1/ratting) + randf_range(0.0, variance);

func get_dialog() -> String:
	if dialog_pool.size() == 0: return "";
	return dialog_pool[randi() % dialog_pool.size()];
