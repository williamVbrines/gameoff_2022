extends ClueData
class_name EpicClassClue

func activate_effect(opponent : String) -> void:
	var attack_info = {
		"type" : "CLUE",
		"amt" : 50,
		"cost" : cost,
		"dialog" : "You found their weakpoint"
	};
	
	EventManager.attack.emit(opponent, attack_info, self);
