extends Node

var save_name : String = "Save_0001"
var save_data : SaveData;

func _ready() -> void:
	_set_up();
	_make_connections();
	
func _make_connections() -> void:
	EventManager.save_file_data.connect(_on_save);
	EventManager.load_file_data.connect(_on_load);
	
	
func _set_up()->void:
	var path = OS.get_executable_path();
	path = path.substr(0,path.rfind("/")+1) + save_name + ".tres"
	if FileAccess.file_exists(path):
		save_data = load(path);
	else:
		save_data = SaveData.new();
		save_data.save_data(save_name);
		
		
func _on_load()->void:
	var path = OS.get_executable_path();
	path = path.substr(0,path.rfind("/")+1) + save_name + ".tres"
	if FileAccess.file_exists(path):
		save_data = load(path);
	else:
		save_data = SaveData.new();
	save_data.laod_data();
	
	EventManager.call_deferred("emit_signal" , "loading_complete" );
		
func _on_save()->void:
	var path = OS.get_executable_path();
	path = path.substr(0,path.rfind("/")+1) + save_name + ".tres"
	if FileAccess.file_exists(path):
		save_data = load(path);
	else:
		save_data = SaveData.new();
	save_data.save_data(save_name);
	
	EventManager.call_deferred("emit_signal" , "saving_complete" );
	
	
	
