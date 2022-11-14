extends Node


var dialog_data = {
#	"test_dialog" : preload("res://scenes/resources/dialogs/test_dialog_data.tres");
}


func get_dialog_data(id : String) -> DialogData:
	prints(id, dialog_data.has(id), dialog_data.get(id, null).data)
	return dialog_data.get(id, null);
	
