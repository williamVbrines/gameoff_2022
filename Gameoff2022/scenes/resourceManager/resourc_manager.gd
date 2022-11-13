extends Node

var tactics_data = {
	#"RefID" : preload(res:path),
	"test" : preload("res://scenes/resources/actions/tactics/test_tactic.tres")
}
	
var dialog_data = {
	"test_dialog2" : preload("res://scenes/resources/dialogs/test_dialog_data.tres")
}


func get_tactic(id : String) -> TacticsData:
	return tactics_data.get(id,null);
	
	
func get_dialog_data(id : String) -> DialogData:
	prints(id, dialog_data.has(id), dialog_data.get(id, null).data)
	return dialog_data.get(id, null);
	
