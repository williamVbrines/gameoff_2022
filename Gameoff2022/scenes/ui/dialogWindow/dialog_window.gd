extends Control

@export var dialog_data : Resource;
@onready var _label: RichTextLabel = $Panel/RichTextLabel
@onready var contine_button: Button = $Panel/ContineButton

@onready var opt_button_1: Button = $Panel/OptButton1
@onready var opt_label_1: RichTextLabel = $Panel/OptButton1/OptLabel1

@onready var opt_button_2: Button = $Panel/OptButton2
@onready var opt_label_2: RichTextLabel = $Panel/OptButton2/OptLabel2

@onready var opt_button_3: Button = $Panel/OptButton3
@onready var opt_label_3: RichTextLabel = $Panel/OptButton3/OptLabel3

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
	"SET" : _set_action,
	"ADD" : _add_action,
	"SUB" : _sub_action,
	
	
	"SAY" : _say_action,
	
	"OPEN" : _open_action, 
	
	"LINE" : _line_action,
	
	"SHOW" : _show_action,
	"HIDE[]" : _hide_action,
	
	"WAIT" : _wait_action,
	"WAIT[]" : _wait_action,
	"OPT" : _opt_action,
	
	"EMIT" : _emit_action
	
}
	
	
func _ready() -> void:
	dialog_data = dialog_data as DialogData;
	if dialog_data == null: breakpoint;

	_make_connections();

	run_dialog(dialog_data);
	
	
func _make_connections() -> void:
	contine_button.pressed.connect(_on_contine_button_pressed);
	opt_button_1.pressed.connect(_on_opt_1_pressed);
	opt_button_2.pressed.connect(_on_opt_2_pressed);
	opt_button_3.pressed.connect(_on_opt_3_pressed);
	
	
func _on_opt_1_pressed() -> void:
	if !waiting_for_input || wait_tag != "null": return;
	call_deferred("run_dialog" , dialog_data, opt_action_1);
	_clear_opts();
	
	
func _on_opt_2_pressed() -> void:
	if !waiting_for_input || wait_tag != "null": return;
	call_deferred("run_dialog" , dialog_data, opt_action_2);
	_clear_opts();
	
	
func _on_opt_3_pressed() -> void:
	if !waiting_for_input || wait_tag != "null": return;
	call_deferred("run_dialog" , dialog_data, opt_action_3);
	_clear_opts();
	
	
func _on_contine_button_pressed() -> void:
	if !waiting_for_input || wait_tag == "null": return;
	
	call_deferred("run_dialog" , dialog_data, wait_tag);
	_label.hide();
	waiting_for_input = false;
	wait_tag = "null";
	text = "";
	
	
func _clear_opts() -> void:
	waiting_for_input = false;
	
	opt_button_1.hide();
	opt_text_1 = "null";
	opt_action_1 = "null";

	opt_button_2.hide();
	opt_text_2 = "null";
	opt_action_2 = "null";
	
	opt_button_3.hide();
	opt_text_3 = "null";
	opt_action_3 = "null";
	
	
func run_dialog(dialog_data : DialogData, tag : String = "Start") -> void:
	var data = dialog_data.data.duplicate(true);
	print(tag);
	parce_line(data.get(tag), tag);
	
	
func parce_line(line : Dictionary, tag : String) -> void:
	print(line);#TODO: Remove
	if parce_condition(line.con):
		print("ParceResult: TRUE ###################################")
		parce_action(line.act, tag);
	else:
		print("ParceResult: FALSE ###################################")
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
		
		action = action.replace(" ", "").to_upper();
		
		if action in actions.keys():
			if actions.get(action).call(params, tag) == -1:
				break;
	
	
func parce_condition(con : String):
	var left = null;
	var opp = null;
	var right = null;
	
	for key in opps.keys():
		if con.find(key) != -1:
			opp = key;
			break;
	
	
	left = con.substr(0, con.find(opp) if opp != null else con.length());
	right = clip_str_to(con,opp) if opp != null else null;
	
	prints(left,opp,right,"###########################");

	if left != null && opp == null && right == null:
		return str_to_val(left);
	
	if left != null && opp != null && right != null:
		return opps.get(opp).call(parce_condition(left), parce_condition(right));
		
		
	return false;
	
	
#Actions############################################################################################
func _set_action(params : String, tag : String) -> int:
	var profile = null;
	var key = null;
	var val = null;
	
	profile = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	key = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	val = str_to_val(params);
	
	_set_profile_val(profile,key,val);
	
	return 0;
	
	
func _add_action(params : String, tag : String) -> int:
	var profile = null;
	var key = null;
	var val = null;
	
	profile = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	key = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	val = str_to_val(params);
	
	_set_profile_val(profile,key,val + _get_profile_val(profile,key));
	
	return 0;
	
	
func _sub_action(params : String, tag : String) -> int:
	var profile = null;
	var key = null;
	var val = null;
	
	profile = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	key = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	val = str_to_val(params);
	
	_set_profile_val(profile,key,_get_profile_val(profile,key) - val);
	
	return 0;
	
	
func _say_action(params : String, tag : String) -> int:
	var profile = null;
	
	profile = params.substr(0, params.find(","));
	params = params.substr(params.find(",") + 1, params.length() - profile.length());
	profile = profile.replace(" ", "");
	
	text += params;
	speaker = profile;
	
	return 0;
	
	
func _open_action(params : String, tag : String) -> int:
	return 0;
	
	
func _line_action(params : String, tag : String) -> int:
	if params.to_upper() == "NEXT":
		var order = dialog_data.data.order as Array;
		var index = order.find(tag);
		if index != -1 && index + 1 < order.size():
			call_deferred("run_dialog", dialog_data, order[index + 1]);
	elif dialog_data.data.has(params):
			call_deferred("run_dialog", dialog_data, params);
			
	return -1;
	
	
func _show_action(params : String, tag : String) -> int:
	params = params.replace(" ", "").to_upper();
	
	if params == "TEXT":
		_label.set_text(text);
		_label.show();
	elif params == "OPT":
		if opt_text_1 != "null":
			opt_button_1.show()
			opt_button_1.set_disabled(opt_action_1 == "null")
			opt_label_1.set_text(opt_text_1);
			
		if opt_text_2 != "null":
			opt_button_2.show()
			opt_button_2.set_disabled(opt_action_2 == "null")
			opt_label_2.set_text(opt_text_2);
			
		if opt_text_3 != "null":
			opt_button_3.show()
			opt_button_3.set_disabled(opt_action_3 == "null")
			opt_label_3.set_text(opt_text_3);
			
			
	return 0;
	
	
func _hide_action(params : String, tag : String) -> int:
	hide();
	return -1;
	
	
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
	
	
	if line.to_upper() == "NEXT":
		var order : Array = dialog_data.data.order;
		line = order[(order.find(tag) + 1) if order.find(tag) + 1 < order.size() else order.size()];
		
		
		
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
	
	
func _emit_action(params : String, tag : String) -> int:
	return 0;
	
	
#utils##############################################################################################
func get_next_str_clean(val : String, del : String) -> String:
	return val.substr(0,val.find(del)).replace(" ", "");
	
	
func clip_str_to(val : String, del : String) -> String:
	var p = val.find(del) + del.length();
	return val.substr(p , val.length() - p);
	
	
func str_to_val(val : String):
	var old_val = val;
	var new_val = null;
	
	val = val.replace(" ", "");#Clean
	
	#Check type
	if val in ["False", "F", "FALSE", "false", "null", "NULL", "Null"]:
		return  false;
	elif val in ["True", "T", "TRUE", "true"] :
		return true;
	elif val.is_valid_float():
		return val.to_float();
	
	if val.find("[") != -1 && val.rfind("]") != -1:
		var p = get_next_str_clean(val, "[");
		var k = get_next_str_clean(clip_str_to(val, "["), "]");
		
		new_val = _get_profile_val(p,k); 
		
	if new_val == null: return old_val;
	
	return new_val;
	
	
func _get_profile_val(profile : String, key : String):
	var p = null;#P is a dictionary
	
	#Clean data
	profile = profile.replace(" ", ""); 
	key = key.replace(" ", "");
	
	if profile.to_upper() == "STATS":
		key = key.to_upper()
		p = SystemGlobals.player_stats;
	else:
		p = SystemGlobals.dialog_profiles.get(profile);
	
	
	if p == null : return null; #Guard
	
	#Return data or null
	return p.get(key, null);
	
	
func _set_profile_val(profile : String, key : String, val) -> void:
	var p = null;#P is a dictionary
	
	#Clean data
	profile = profile.replace(" ", ""); 
	key = key.replace(" ", "");
	
	if profile.to_upper() == "STATS":
		key = key.to_upper()
		p = SystemGlobals.player_stats;
	else:
		p = SystemGlobals.dialog_profiles.get(profile);
	
	if p == null :
		SystemGlobals.dialog_profiles[profile] = {};
		p = SystemGlobals.dialog_profiles.get(profile);
	
	if !p.has(key):
		p[key] = null;
		
	p[key] = val;
	
	
	
