extends Control
@onready var _label: RichTextLabel = $Panel/RichTextLabel
@onready var contine_button: Button = $Panel/ContineButton

@onready var opt_button_1: Button = $Panel/OptButton1
@onready var opt_label_1: RichTextLabel = $Panel/OptButton1/OptLabel1

@onready var opt_button_2: Button = $Panel/OptButton2
@onready var opt_label_2: RichTextLabel = $Panel/OptButton2/OptLabel2

@onready var opt_button_3: Button = $Panel/OptButton3
@onready var opt_label_3: RichTextLabel = $Panel/OptButton3/OptLabel3

@onready var line_label: Label = $LineLabel

var dialog_data : DialogData;
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

signal dialog_emit(val : String);

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
	_make_connections();
	
	
func _make_connections() -> void:
	contine_button.pressed.connect(_on_contine_button_pressed);
	opt_button_1.pressed.connect(_on_opt_1_pressed);
	opt_button_2.pressed.connect(_on_opt_2_pressed);
	opt_button_3.pressed.connect(_on_opt_3_pressed);
	EventManager.start_dialog.connect(_on_strat_dialog);
	
	
func _on_strat_dialog(id : String) -> void:
	var data = ResourceManager.get_dialog_data(id) as DialogData;
	
	if data == null:
		exit_dialog();
		return;
	if data.data == { }:
		exit_dialog();
		return;
		
	
	call_deferred("run_dialog" , data);
	
	
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
	
	
func run_dialog(new_dialog_data : DialogData, tag : String = "Start") -> void:
	if new_dialog_data == null: return;
	
	var data = new_dialog_data.data.duplicate(true);
	
	if data == null : 
		exit_dialog();
		return;
	
	if data.has(tag) == false || data == { }: 
		exit_dialog();
		return;
	
	show();
	
	self.dialog_data = new_dialog_data;
	parce_line(data.get(tag), tag);
	
	
func parce_line(line : Dictionary, tag : String) -> void:
	line_label.text = "CurrentLien : " + tag
	var result = parce_condition(line.con);
	if result && typeof(result) == 1:
		parce_action(line.act, tag);
	else:
		parce_action(line.def, tag);
	
	
func parce_action(act : Array, tag : String) -> void:
	if act.size() <= 0: return;
	
	for index in act.size():
		var action = act[index] as String;
		var p1 = action.find("[", 0) + 1;
		var p2 = action.rfind("]") ;
		var params = action.substr(p1,p2-p1);
		if params: action = action.substr(0,p1-1);
		
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
	
	if left != null && opp == null && right == null:
		return str_to_val(left);
	
	if left != null && opp != null && right != null:
		return opps.get(opp).call(parce_condition(left), parce_condition(right));
		
		
	return false;
	
func exit_dialog()->void:
	EventManager.dialog_ended.emit();
	hide();
	
	
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
	var val2 = null;
	
	
	profile = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	key = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	val = str_to_val(params);
	
	val2 = _get_profile_val(profile,key);
	
	if typeof(val) == typeof(val2):
		val += val2;
		
	_set_profile_val(profile,key,val);
	
	return 0;
	
	
func _sub_action(params : String, tag : String) -> int:
	var profile = null;
	var key = null;
	var val = null;
	var val2 = null;
	
	profile = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	key = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	val = str_to_val(params);
	
	val2 = _get_profile_val(profile,key);
	
	if typeof(val) == typeof(val2):
		val -= val2;
		
	_set_profile_val(profile,key, val);
	
	return 0;
	
	
func _say_action(params : String, tag : String) -> int:
	speaker = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	if params.find("[") != -1 && params.find("]") != -1 :
		params = str(str_to_val(params));
	
	text += params;
	
	return 0;
	
	
func _open_action(params : String, tag : String) -> int:
	var new_tag = get_next_str_clean(params,",");
	var new_dialog = ResourceManager.get_dialog_data(clip_str_to(params, ","));
	if new_dialog != null:
		dialog_data = new_dialog;
		call_deferred("run_dialog" , dialog_data , new_tag);
		return -1;
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
	EventManager.dialog_ended.emit();
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
	
	line = get_next_str_clean(params, ",");
	params = clip_str_to(params , ",");
	
	if line.to_upper() == "NEXT":
		var order = dialog_data.data.order as Array;
		var index = order.find(tag);
		
		if index != -1 && index + 1 < order.size():
			line = order[index + 1];
			
	if params.find("[") != -1 && params.find("]") != -1 :
		params = str(str_to_val(params));
		
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
	dialog_emit.emit(params);
	EventManager.dialog_emit.emit(params);
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
	
	
