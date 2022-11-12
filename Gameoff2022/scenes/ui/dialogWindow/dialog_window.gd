extends Control

@export var dialog_data : Resource;
@onready var _label: RichTextLabel = $Panel/RichTextLabel
var text : String = "";

func _equal_to(a,b) -> bool: return a == b;
func _not_equal_to(a,b) -> bool: return a != b;
func _greater_than(a,b) -> bool: return a > b;
func _less_than(a,b) -> bool: return a < b;
func _greater_than_or_equal_to(a,b) -> bool: return a >= b;
func _less_than_or_equal_to(a,b) -> bool: return a <= b;
func _or(a : bool, b : bool) -> bool: return a || b;
func _and(a : bool, b : bool) -> bool: return a && b;

var opps : Dictionary = {
	"==" : _equal_to,
	"!=" : _not_equal_to,
	">=" : _greater_than_or_equal_to,
	"<=" : _less_than_or_equal_to,
	">" : _greater_than,
	"<" : _less_than,
	"||" : _or,
	"&&" : _and
}

var actions : Dictionary = {
	"Line" : _line_action
}


func _ready() -> void:
	dialog_data = dialog_data as DialogData;
	if dialog_data == null: breakpoint;

	_make_connections();

	run_dialog(dialog_data);

func _make_connections() -> void:
	pass


func run_dialog(dialog_data : DialogData, tag : String = "Start") -> void:
	var data = dialog_data.data;
	parce_line(data.get(tag), tag);
	
func parce_line(line : Dictionary, tag : String) -> void:
	print(line);
	if parce_condition(line.con, line.acc):
		print("TRUE");
		parce_action(line.act, line.acc, tag);
	else:
		print("FALSE");
		parce_action(line.def, line.acc, tag);
	
func parce_action(act : Array, acc : String, tag : String) -> void:
	if act.size() <= 0: return;
	
	for index in act.size():
		var action = act[index] as String;
		var p1 = action.find("[", 0) + 1;
		var p2 = action.rfind("]") ;
		var params = action.substr(p1,p2-p1);
		if params: action = action.substr(0,p1-1);
		
		
		prints(">>>>CurrentTAG : ", tag)
		prints(">>>>Action :", action.replace(" ", ""))
		prints(">>>>Params :", params)
		
		if action.replace(" ", "") in actions.keys():
			if actions.get(action.replace(" ", "")).call(params, acc, tag) == -1:
				break;
		else:
			text = action;
	
	
func parce_condition(con : String, acc : String) -> bool:
	var profile = SystemGlobals.dialog_profiles.get(acc);
	var val = null;
	var opp = null;
	var left = null;
	var right = null;
	
	if profile == null : return false;
	
	for key in opps.keys():
		if con.find(key) != -1:
			opp = key;
			break;
			
	left = con.substr(0, con.find(opp) if opp != null else con.length());
	right = con.substr(con.find(opp), -1) if opp != null else null;
	
	print(left);
	print(opp);
	print(right);

	if left != null && opp == null && right == null:
		#Check Profile for match
		val = profile.get(left);
		
		if val != null:
			return val;
		
		if left.to_upper() in ["TRUE", "T", "1"]: return true;
		if left.to_upper() in ["FALSE", "F", "0"]: return true;
		
		if left.is_valid_float() : return left.to_float();
		
		return val if val != null else false;
	
	
	if left != null && opp != null && right != null:
		return opps.get(opp).call(parce_condition(left, acc), parce_condition(right,acc));
		
		
	return false;
	
	
func _line_action(params : String, acc : String, tag : String) -> int:
	if params.to_upper() == "NEXT":
		var order = dialog_data.data.order as Array;
		var index = order.find(tag);
		if index != -1 && index + 1 < order.size():
			call_deferred("run_dialog", dialog_data, order[index + 1]);
	elif dialog_data.data.has(params):
			call_deferred("run_dialog", dialog_data, params);
			
	return -1;
	
