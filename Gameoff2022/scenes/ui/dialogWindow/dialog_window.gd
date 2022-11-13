extends Control

@export var dialog_data : Resource;
@onready var _label: RichTextLabel = $Panel/RichTextLabel
@onready var contine_button: Button = $Panel/ContineButton
@onready var opt_button_1: Button = $Panel/OptButton1
@onready var opt_button_2: Button = $Panel/OptButton2
@onready var opt_button_3: Button = $Panel/OptButton3


var speaker : String = "";
var text : String = "";
var wait_tag : String = "null";
var waiting_for_input : bool = false;

var opt_text_1 : String = "null";
var opt_action_1 : String = "null";

var opt_text_2 : String = "null";
var opt_action_2 : String = "null";

var opt_text_3 : String = "null";
var opt_action_3 : String = "null";

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
	"Line" : _line_action,
	"Set" : _set_action,
	"Say" : _say_action,
	"Show" : _show_action,
	"Wait" : _wait_action,
	"Opt" : _opt_action
}


func _ready() -> void:
	dialog_data = dialog_data as DialogData;
	if dialog_data == null: breakpoint;

	_make_connections();

	run_dialog(dialog_data);
	
	
func _make_connections() -> void:
	contine_button.pressed.connect(_on_contine_button_pressed);
	pass
	
	
func _on_contine_button_pressed() -> void:
	if !waiting_for_input || wait_tag == "null": return;
	
	run_dialog(dialog_data, wait_tag);
	
	
func run_dialog(dialog_data : DialogData, tag : String = "Start") -> void:
	var data = dialog_data.data.duplicate(true);
	print(tag);
	parce_line(data.get(tag), tag);
	
	
func parce_line(line : Dictionary, tag : String) -> void:
	print(line);
	if parce_condition(line.con):
		print("TRUE");
		parce_action(line.act, tag);
	else:
		print("FALSE");
		parce_action(line.def, tag);
	
	
func parce_action(act : Array, tag : String) -> void:
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
			if actions.get(action.replace(" ", "")).call(params, tag) == -1:
				break;
	
	
func parce_condition(con : String) -> bool:
	
	var profile = null;# SystemGlobals.dialog_profiles.get(acc);
	var val = null;
	var opp = null;
	var left = null;
	var right = null;
	
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
		#Get Profile;
		profile = null;
		SystemGlobals.dialog_profiles.get(get_con_profile(left));
		
		if val != null:
			var p1 = left.find("[");
			var p2 = left.rfind("]");
			left = left.substr(p1,p2-p1);
			
			#Check Profile for match
			val = profile.get(left);
		
			return val;
		
		if left.to_upper() in ["TRUE", "T", "1"]: return true;
		if left.to_upper() in ["FALSE", "F", "0"]: return true;
		
		if left.is_valid_float() : return left.to_float();
		
		return val if val != null else false;
	
	
	if left != null && opp != null && right != null:
		return opps.get(opp).call(parce_condition(left), parce_condition(right));
		
		
	return false;
	
	
func get_con_profile(val : String) -> String:
	var profile = val.substr(0,val.find("[")).replace(" ", "");
	return profile;
	
	
func _line_action(params : String, tag : String) -> int:
	if params.to_upper() == "NEXT":
		var order = dialog_data.data.order as Array;
		var index = order.find(tag);
		if index != -1 && index + 1 < order.size():
			call_deferred("run_dialog", dialog_data, order[index + 1]);
	elif dialog_data.data.has(params):
			call_deferred("run_dialog", dialog_data, params);
			
	return -1;
	
	
func _set_action(params : String, tag : String) -> int:
	var profile = null;
	var key = null;
	var val = null;
	
	profile = params.substr(0, params.find(","));
	params = params.substr(params.find(",") + 1, params.length() - profile.length());
	profile = profile.replace(" ", "");
	
	key = params.substr(0, params.find(","));
	params = params.substr(params.find(",") + 1, params.length() - key.length());
	key = key.replace(" ", "");
	
	val = params.substr(0, params.find(",")).replace(" ", "");
	
	if val in ["False", "F", "FALSE", "false", "null", "NULL", "Null"]:
		val = false;
	elif val in ["True", "T", "TRUE", "true"] :
		val = true;
	elif val.is_valid_float():
		val = val.to_float();
	else:
		val = params;
	
	if !SystemGlobals.dialog_profiles.has(profile):
		SystemGlobals.dialog_profiles[profile] = {};
		
	if !SystemGlobals.dialog_profiles[profile].has(key):
		SystemGlobals.dialog_profiles[profile][key] = null;
		
	SystemGlobals.dialog_profiles[profile][key] = val;
	
	
	return 0;
	
	
func _say_action(params : String, tag : String) -> int:
	var profile = null;
	
	profile = params.substr(0, params.find(","));
	params = params.substr(params.find(",") + 1, params.length() - profile.length());
	profile = profile.replace(" ", "");
	
	text += params;
	speaker = profile;
	
	return 0;
	
	
func _show_action(params : String, tag : String) -> int:
	params = params.replace(" ", "").to_upper();
	
	if params == "TEXT":
		_label.set_text(text);
		_label.show();
	elif params == "OPT":
		if opt_text_1 == "null":
			opt_button_1.show()
		
		if opt_text_2 == "null":
			opt_button_2.show()
			
		if opt_text_3 == "null":
			opt_button_2.show()
		
	return 0;
	
	
func _wait_action(params : String, tag : String) -> int:
	params = params.replace(" ", "");
	wait_tag = params if params != "" else "null";
	
	if wait_tag.to_upper() == "NEXT":
		var order : Array = dialog_data.data.order;
		wait_tag = order[(order.find(tag) + 1) if order.find(tag) + 1 < order.size() else order.size()];
		
	waiting_for_input = true;
	return -1;
	
	
func _opt_action(params : String, tag : String) -> int:
	var line = "null";
	
	line = params.substr(0, params.find(","));
	params = params.substr(params.find(",") + 1, params.length() - line.length());
	line = line.replace(" ", "");
	
	if opt_text_1 == "null":
		opt_text_1 = params;
		opt_action_1 = line;
	elif opt_text_2 == "null":
		opt_text_2 = params;
		opt_action_2 = line;
	elif opt_text_3 == "null":
		opt_text_3 = params;
		opt_action_3 = line;
	
	return 0;
