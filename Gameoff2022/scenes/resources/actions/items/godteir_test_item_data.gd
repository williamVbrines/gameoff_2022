extends ItemData
class_name GODTeirItem
func activate_effect(opponent : String) -> void:
	var attack_info = {
		"type" : "GOD",
		"amt" : 50,
		"cost" : 0,
		"dialog" : "Ypu pick up a random pebbel and throw it"
	};
	
	EventManager.attack.emit(opponent, attack_info);
	
	
	
