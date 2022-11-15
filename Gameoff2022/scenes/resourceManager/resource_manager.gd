extends Node

#Tactics Data###################################################################
var tactics_data = {
	#"RefID" : preload(res:path),
	"test" : preload("res://scenes/resources/actions/tactics/test_tactic.tres")
}
func get_tactic(id : String) -> TacticsData:
	return tactics_data.get(id,null);
	
	
	
#Dialog Data####################################################################
var dialog_data = {
	"test_dialog" = preload("res://scenes/resources/dialogs/test_dialog.tres")
}
func get_dialog_data(id : String) -> DialogData:
	
	if FileAccess.file_exists(id):
		var data = ResourceLoader.load(id);
		var key = id.substr(id.rfind("\\")).substr(0,id.find("."));
		print(key);
		dialog_data[key] = data;
		return data;
		
	return dialog_data.get(id, null);
	
	
func add_resource( type : String , path : String , key : String = "null") -> void:
	var data = null;
	
	if key == "null":
		key = path.substr(path.rfind("/") + 1);
		key = key.substr(0,key.rfind("."));
	
	if FileAccess.file_exists(path):
		data = ResourceLoader.load(path);
	
	match type:
		"dialog_data":
			dialog_data[key] = data;
	
	
