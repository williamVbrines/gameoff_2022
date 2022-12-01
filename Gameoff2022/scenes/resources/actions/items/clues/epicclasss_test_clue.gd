extends ClueData
class_name EpicClassClue

@export var amount : float = 50;

func activate_effect(opponent : String) -> void:
	var attack_info = {
		"type" : "CLUE",
		"amt" : amount,
		"cost" : cost,
		"dialog" : "You found their weakpoint" if dialog_pool.size() <= 0 else dialog_pool[0]
	};
	
	EventManager.attack.emit(opponent, attack_info);
