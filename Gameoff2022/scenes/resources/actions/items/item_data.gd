extends PlayerActionData
class_name ItemData

func activate_effect() -> void:
	pass
	
	
#Override
func gen_label() -> String:
	var text : String = "[";
	
	text += " ,Cost: " + str(cost) + "] " + discrtiption;
	
	return text;

