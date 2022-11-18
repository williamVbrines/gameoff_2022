extends Node

var current_save_file : String = "null";
var stress = 0;

var player_stats : Dictionary = {
	"CHARM" : 50,
	"LOGIC" : 50,
	"DECEPTION" : 50,
	"INTIMIDATION" : 50
}
	
	
var player_tactics : Dictionary = {
	"SLOT:1" : "test",
	"SLOT:2" : "test",
	"SLOT:3" : "test",
	"AVAILABLE" : ["test"] #List of all available tatictics to the player.
}
	
	
var player_items : Array[String] = [] #List of refids to all items the player has
var player_clues : Array[String] = [] #List of refids to all clues the player has


var dialog_profiles : Dictionary = {}

func _ready() -> void:
	EventManager.load_data.connect(load_data);
	
func data_dump() -> Dictionary:
	var save_dic : Dictionary = {};
	save_dic["player_stats"] = player_stats;
	save_dic["player_tactics"] = player_tactics;
	save_dic["player_items"] = player_items;
	save_dic["player_clues"] = player_clues;
	save_dic["dialog_profiles"] = dialog_profiles;
	return save_dic;

func load_data(data : Dictionary) -> void:
	if data.has("SystemGlobals"):
		var dic : Dictionary = data.SystemGlobals;
		if dic.has_all(["player_stats","player_tactics","player_items","player_clues","dialog_profiles"]):
			player_stats = dic.player_stats;
			player_tactics = dic.player_tactics;
			player_items = dic.player_items;
			player_clues = dic.player_clues;
			dialog_profiles = dic.dialog_profiles;
