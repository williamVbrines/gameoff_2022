extends Node
#Item Data######################################################################
var item_data = {
	"rock" : preload("res://scenes/resources/actions/items/rock_item.tres")
}

func get_item_data(id : String) -> ItemData:
	return item_data.get(id,null);
	
	
#Clue Data######################################################################
var clues_data = {
	"test_spy_glass" = preload("res://scenes/resources/actions/items/clues/eyeglass_test_clue.tres"),
	"flowers" = preload("res://scenes/resources/actions/items/clues/flowers_clue.tres")
}

func get_clue_data(id : String) -> ClueData:
	return clues_data.get(id,null);
	
	
#Tactics Data###################################################################
var tactics_data = {
	#"RefID" : preload(res:path),
	"test" : preload("res://scenes/resources/actions/tactics/test_tactic.tres"),
	"barate" : preload("res://scenes/resources/actions/tactics/berate_tactic.tres"),
	"big_lie" : preload("res://scenes/resources/actions/tactics/big_lie_tactic.tres"), 
	"complement" : preload("res://scenes/resources/actions/tactics/complement_tactic.tres"), 
	"counter_point" : preload("res://scenes/resources/actions/tactics/counter_point_tactic.tres"), 
	"fast_talking" : preload("res://scenes/resources/actions/tactics/fast_talking_tactic.tres"), 
	"glare" : preload("res://scenes/resources/actions/tactics/glare_tactic.tres"), 
	"incentivize" : preload("res://scenes/resources/actions/tactics/incentivize_tactic.tres"), 
	"lecture" : preload("res://scenes/resources/actions/tactics/lecture_tactic.tres"), 
	"listen" : preload("res://scenes/resources/actions/tactics/listen_listen.tres"), 
	"sweet_talk" : preload("res://scenes/resources/actions/tactics/sweet_talk_tactic.tres"), 
	"vailed_threat" : preload("res://scenes/resources/actions/tactics/vailed_threat_tactic.tres"), 
	"white_lie" : preload("res://scenes/resources/actions/tactics/white_lie_tactic.tres"), 
	"wink" : preload("res://scenes/resources/actions/tactics/wink_tactic.tres")
}
func get_tactic(id : String) -> TacticsData:
	return tactics_data.get(id,null);
	
	
#Dialog Data####################################################################
var dialog_data = {
	"test_dialog" = preload("res://scenes/resources/dialogs/test_dialog.tres"),
	"wizard" = preload("res://dialog/Barnabas - Sheet1.tres"),
	"smith" = preload("res://dialog/Jacques - Sheet1.tres"),
	"innkeeper" = preload("res://dialog/Margo - Sheet1.tres")
}

func get_dialog_data(id : String) -> DialogData:
	
	if FileAccess.file_exists(id):
		var data = ResourceLoader.load(id);
		var key = id.substr(id.rfind("\\")).substr(0,id.find("."));
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
	
	
