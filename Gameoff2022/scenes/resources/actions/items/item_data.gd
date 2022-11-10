extends PlayerActionData
class_name ItemData

func activate_effect(_opponent : String) -> void:
	pass
	
	
#Override
func gen_label() -> String:
	var text : String = "[" + "Cost: " + str(cost) + "] " + discrtiption;
	
	return text;

