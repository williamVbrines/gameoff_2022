extends Node

var play_start_anim : bool = true;#Do not save this data
var opponent : String = "";#Do not save this data
var current_save_file : String = "null";#Do not save this data

var stress = 0;
var persuasion = 0;

var windowed : bool = true;
var masterVol : float = 0.0;
var sfxVol : float = 0.0;
var bgmVol : float = -14.0;

var day : float = 0;
var in_battel : bool = false;

var victory : bool = false;

var player_stats : Dictionary = {
	"CHARM" : 50,
	"LOGIC" : 40,
	"DECEPTION" : 40,
	"INTIMIDATION" : 35
}
	
	
var player_tactics : Dictionary = {
	"SLOT:1" : "",
	"SLOT:2" : "",
	"SLOT:3" : "",
	"AVAILABLE" : [	"test",
	"barate",
	"big_lie", 
	"complement", 
	"counter_point", 
	"fast_talking", 
	"glare", 
	"incentivize", 
	"lecture", 
	"listen", 
	"sweet_talk", 
	"vailed_threat", 
	"white_lie", 
	"wink"] #List of all available tatictics to the player.
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
	save_dic["windowed"] = windowed;
	save_dic["masterVol"] = masterVol;
	save_dic["sfxVol"] = sfxVol;
	save_dic["bgmVol"] = bgmVol;
	save_dic["day"] = day;
	save_dic["stress"] = stress;
	save_dic["persuasion"] = persuasion;
	
	return save_dic;

func load_data(data : Dictionary) -> void:
	if data.has("SystemGlobals"):
		var dic : Dictionary = data.SystemGlobals;
		if dic.has_all(["day","stress","persuasion","masterVol","sfxVol","bgmVol","windowed","player_stats","player_tactics","player_items","player_clues","dialog_profiles"]):
			player_stats = dic.player_stats;
			player_tactics = dic.player_tactics;
			player_items = dic.player_items;
			player_clues = dic.player_clues;
			dialog_profiles = dic.dialog_profiles;
			windowed = dic.windowed
			masterVol = dic.masterVol
			sfxVol = dic.sfxVol;
			bgmVol = dic.bgmVol;
			
			day = dic.day;
			stress = dic.stress;
			persuasion = dic.persuasion;
			
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), masterVol);
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfxVol);
#			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), bgmVol);
			
			if !SystemGlobals.windowed:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
